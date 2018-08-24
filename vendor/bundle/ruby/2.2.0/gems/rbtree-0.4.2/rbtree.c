/*
 * MIT License
 * Copyright (c) 2002-2013 OZAWA Takuma
 */
#include <ruby.h>
#ifdef HAVE_RUBY_ST_H
#include <ruby/st.h>
#else
#include <st.h>
#endif
#include "dict.h"

#define RBTREE_PROC_DEFAULT FL_USER2
#define HASH_PROC_DEFAULT   FL_USER2

#ifdef RETURN_SIZED_ENUMERATOR
#define HAVE_SIZED_ENUMERATOR
#else
#ifdef RETURN_ENUMERATOR
#define RETURN_SIZED_ENUMERATOR(obj, argc, argv, size_fn) RETURN_ENUMERATOR(obj, argc, argv)
#else
#define RETURN_SIZED_ENUMERATOR(obj, argc, argv, size_fn) ((void)0)
#endif
#endif

#ifndef RARRAY_AREF
#define RARRAY_AREF(a, i) (RARRAY_PTR(a)[i])
#endif

#ifndef RHASH_SET_IFNONE
#define RHASH_SET_IFNONE(h, v) (RHASH(h)->ifnone = (v))
#endif

VALUE RBTree;
VALUE MultiRBTree;

static ID id_cmp;
static ID id_call;
static ID id_default;
static ID id_flatten_bang;

typedef struct {
    dict_t* dict;
    VALUE ifnone;
    VALUE cmp_proc;
    int iter_lev;
} rbtree_t;

#define RBTREE(rbtree) DATA_PTR(rbtree)
#define DICT(rbtree) ((rbtree_t*)RBTREE(rbtree))->dict
#define IFNONE(rbtree) ((rbtree_t*)RBTREE(rbtree))->ifnone
#define CMP_PROC(rbtree) ((rbtree_t*)RBTREE(rbtree))->cmp_proc
#define ITER_LEV(rbtree) ((rbtree_t*)RBTREE(rbtree))->iter_lev

#define TO_KEY(arg) ((const void*)arg)
#define TO_VAL(arg) ((void*)arg)
#define GET_KEY(dnode) ((VALUE)dnode_getkey(dnode))
#define GET_VAL(dnode) ((VALUE)dnode_get(dnode))
#define ASSOC(dnode) rb_assoc_new(GET_KEY(dnode), GET_VAL(dnode))

/*********************************************************************/

static void
rbtree_free(rbtree_t* rbtree)
{
    dict_free_nodes(rbtree->dict);
    xfree(rbtree->dict);
    xfree(rbtree);
}

static void
rbtree_mark(rbtree_t* rbtree)
{
    if (rbtree == NULL) return;

    if (rbtree->dict != NULL) {
        dict_t* dict = rbtree->dict;
        dnode_t* node;
        for (node = dict_first(dict);
             node != NULL;
             node = dict_next(dict, node)) {

            rb_gc_mark(GET_KEY(node));
            rb_gc_mark(GET_VAL(node));
        }
    }
    rb_gc_mark(rbtree->ifnone);
    rb_gc_mark(rbtree->cmp_proc);
}

static dnode_t*
rbtree_alloc_node(void* context)
{
    return ALLOC(dnode_t);
}

static void
rbtree_free_node(dnode_t* node, void* context)
{
    xfree(node);
}

static void
rbtree_check_argument_count(const int argc, const int min, const int max)
{
    if (argc < min || argc > max) {
        static const char* const  message = "wrong number of arguments";
        if (min == max) {
            rb_raise(rb_eArgError, "%s (%d for %d)", message, argc, min);
        } else if (max == INT_MAX) {
            rb_raise(rb_eArgError, "%s (%d for %d+)", message, argc, -min - 1);
        } else {
            rb_raise(rb_eArgError, "%s (%d for %d..%d)", message, argc, min, max);
        }
    }
}

static void
rbtree_check_proc_arity(VALUE proc, const int expected)
{
#ifdef HAVE_RB_PROC_LAMBDA_P
    if (rb_proc_lambda_p(proc)) {
        const int arity = rb_proc_arity(proc);
        const int min = arity < 0 ? -arity - 1 : arity;
        const int max = arity < 0 ? INT_MAX : arity;
        if (expected < min || expected > max) {
            rb_raise(rb_eTypeError, "proc takes %d arguments", expected);
        }
    }
#endif
}

static int
rbtree_cmp(const void* key1, const void* key2, void* context)
{
    VALUE result;
    if (TYPE(key1) == T_STRING && TYPE(key2) == T_STRING)
        return rb_str_cmp((VALUE)key1, (VALUE)key2);
    result = rb_funcall2((VALUE)key1, id_cmp, 1, (VALUE*)&key2);
    return rb_cmpint(result, (VALUE)key1, (VALUE)key2);
}

static VALUE
rbtree_user_cmp_ensure(rbtree_t* rbtree)
{
    rbtree->iter_lev--;
    return Qnil;
}

static VALUE
rbtree_user_cmp_body(VALUE* args)
{
    rbtree_t* rbtree = (rbtree_t*)args[2];
    rbtree->iter_lev++;
    return rb_funcall2(rbtree->cmp_proc, id_call, 2, args);
}

static int
rbtree_user_cmp(const void* key1, const void* key2, void* context)
{
    rbtree_t* rbtree = (rbtree_t*)context;
    VALUE args[3];
    VALUE result;

    args[0] = (VALUE)key1;
    args[1] = (VALUE)key2;
    args[2] = (VALUE)rbtree;
    result = rb_ensure(rbtree_user_cmp_body, (VALUE)&args,
                       rbtree_user_cmp_ensure, (VALUE)rbtree);
    return rb_cmpint(result, (VALUE)key1, (VALUE)key2);
}

static void
rbtree_modify(VALUE self)
{
    if (ITER_LEV(self) > 0)
        rb_raise(rb_eTypeError, "can't modify rbtree during iteration");
    rb_check_frozen(self);
    if (!OBJ_TAINTED(self) && rb_safe_level() >= 4)
        rb_raise(rb_eSecurityError, "Insecure: can't modify rbtree");
}

static VALUE
rbtree_alloc(VALUE klass)
{
    dict_t* dict;
    VALUE rbtree = Data_Wrap_Struct(klass, rbtree_mark, rbtree_free, NULL);
    RBTREE(rbtree) = ALLOC(rbtree_t);
    MEMZERO(RBTREE(rbtree), rbtree_t, 1);
    
    dict = ALLOC(dict_t);
    dict_init(dict, rbtree_cmp);
    dict_set_allocator(dict, rbtree_alloc_node, rbtree_free_node,
                       RBTREE(rbtree));
    if (!RTEST(rb_class_inherited_p(klass, RBTree)))
        dict_allow_dupes(dict);
    
    DICT(rbtree) = dict;
    IFNONE(rbtree) = Qnil;
    CMP_PROC(rbtree) = Qnil;
    return rbtree;
}

VALUE rbtree_aset(VALUE, VALUE, VALUE);
VALUE rbtree_has_key(VALUE, VALUE);
VALUE rbtree_update(VALUE, VALUE);
VALUE rbtree_to_a(VALUE);

/*********************************************************************/

static int
hash_to_rbtree_i(VALUE key, VALUE value, VALUE rbtree)
{
    if (key != Qundef)
        rbtree_aset(rbtree, key, value);
    return ST_CONTINUE;
}

/*
 *
 */
VALUE
rbtree_s_create(int argc, VALUE* argv, VALUE klass)
{
    long i;
    VALUE rbtree;
    
    if (argc == 1) {
        VALUE temp;
        
        if (rb_obj_is_kind_of(argv[0], klass)) {
            rbtree = rbtree_alloc(klass);
            rbtree_update(rbtree, argv[0]);
            return rbtree;
        }
        
        if (RTEST(rb_class_inherited_p(klass, RBTree)) &&
            (rb_obj_is_kind_of(argv[0], MultiRBTree) && !rb_obj_is_kind_of(argv[0], RBTree))) {
            
            rb_raise(rb_eTypeError, "wrong argument type MultiRBTree (expected RBTree)");
        }
        
        temp = rb_check_convert_type(argv[0], T_HASH, "Hash", "to_hash");
        if (!NIL_P(temp)) {
            rbtree = rbtree_alloc(klass);
            rb_hash_foreach(temp, hash_to_rbtree_i, rbtree);
            return rbtree;
        }
        
        temp = rb_check_array_type(argv[0]);
        if (!NIL_P(temp)) {
            rbtree = rbtree_alloc(klass);
            for (i = 0; i < RARRAY_LEN(temp); i++) {
                VALUE v = rb_check_array_type(RARRAY_AREF(temp, i));
                if (NIL_P(v)) {
                    rb_warn("wrong element type %s at %ld (expected Array)",
                            rb_obj_classname(RARRAY_AREF(temp, i)), i);
                    continue;
                }
                switch(RARRAY_LEN(v)) {
                case 1:
                    rbtree_aset(rbtree, RARRAY_AREF(v, 0), Qnil);
                    break;
                case 2:
                    rbtree_aset(rbtree, RARRAY_AREF(v, 0), RARRAY_AREF(v, 1));
                    break;
                default:
                    rb_warn("invalid number of elements (%ld for 1..2)",
                            RARRAY_LEN(v));
                }
            }
            return rbtree;
        }
    }
    
    if (argc % 2 != 0)
        rb_raise(rb_eArgError, "odd number of arguments for %s", rb_class2name(klass));

    rbtree = rbtree_alloc(klass);
    for (i = 0; i < argc; i += 2)
        rbtree_aset(rbtree, argv[i], argv[i + 1]);
    return rbtree;
}

/*
 *
 */
VALUE
rbtree_initialize(int argc, VALUE* argv, VALUE self)
{
    rbtree_modify(self);

    if (rb_block_given_p()) {
        VALUE proc;
        rbtree_check_argument_count(argc, 0, 0);
        proc = rb_block_proc();
        rbtree_check_proc_arity(proc, 2);
        IFNONE(self) = proc;
        FL_SET(self, RBTREE_PROC_DEFAULT);
    } else {
        rbtree_check_argument_count(argc, 0, 1);
        if (argc == 1) {
            IFNONE(self) = argv[0];
        }
    }
    return self;
}

/*********************************************************************/

typedef enum {
    NoNodeInserted,
    KeyAllocationFailed,
    InsertionSucceeded
} insert_result_t;

typedef struct {
    dict_t* dict;
    dnode_t* node;
    insert_result_t result;
} rbtree_insert_arg_t;

static VALUE
insert_node_body(rbtree_insert_arg_t* arg)
{
    dict_t* dict = arg->dict;
    dnode_t* node = arg->node;
    
    if (dict_insert(dict, node, dnode_getkey(node))) {
        if (TYPE(GET_KEY(node)) == T_STRING) {
            arg->result = KeyAllocationFailed;
            node->dict_key = TO_KEY(rb_str_new4(GET_KEY(node)));
        }
    } else {
        dict->dict_freenode(node, dict->dict_context);
    }
    arg->result = InsertionSucceeded;
    return Qnil;
}

static VALUE
insert_node_ensure(rbtree_insert_arg_t* arg)
{
    dict_t* dict = arg->dict;
    dnode_t* node = arg->node;
    
    switch (arg->result) {
    case InsertionSucceeded:
        break;
    case NoNodeInserted:
        dict->dict_freenode(node, dict->dict_context);
        break;
    case KeyAllocationFailed:
        dict_delete_free(dict, node);
        break;
    }
    return Qnil;
}

static void
rbtree_insert(VALUE self, VALUE key, VALUE value)
{
    rbtree_insert_arg_t arg;
    dict_t* dict = DICT(self);
    dnode_t* node = dict->dict_allocnode(dict->dict_context);

    dnode_init(node, TO_VAL(value));
    node->dict_key = TO_KEY(key);
    
    arg.dict = dict;
    arg.node = node;
    arg.result = NoNodeInserted;

    rb_ensure(insert_node_body, (VALUE)&arg,
              insert_node_ensure, (VALUE)&arg);
}

/*********************************************************************/

/*
 *
 */
VALUE
rbtree_aset(VALUE self, VALUE key, VALUE value)
{
    rbtree_modify(self);

    if (dict_isfull(DICT(self))) {
        dnode_t* node = dict_lookup(DICT(self), TO_KEY(key));
        if (node == NULL)
            rb_raise(rb_eIndexError, "rbtree full");
        else
            dnode_put(node, TO_VAL(value));
        return value;
    }
    rbtree_insert(self, key, value);
    return value;
}

/*
 *
 */
VALUE
rbtree_aref(VALUE self, VALUE key)
{
    dnode_t* node = dict_lookup(DICT(self), TO_KEY(key));
    if (node == NULL)
        return rb_funcall2(self, id_default, 1, &key);
    else
        return GET_VAL(node);
}

/*
 *
 */
VALUE
rbtree_fetch(int argc, VALUE* argv, VALUE self)
{
    dnode_t* node;

    rbtree_check_argument_count(argc, 1, 2);
    if (argc == 2 && rb_block_given_p()) {
        rb_warn("block supersedes default value argument");
    }

    node = dict_lookup(DICT(self), TO_KEY(argv[0]));
    if (node != NULL) {
        return GET_VAL(node);
    }

    if (rb_block_given_p()) {
        return rb_yield(argv[0]);
    }
    if (argc == 1) {
        rb_raise(rb_eIndexError, "key not found");
    }
    return argv[1];
}

/*
 *
 */
VALUE
rbtree_size(VALUE self)
{
    return ULONG2NUM(dict_count(DICT(self)));
}

/*
 *
 */
VALUE
rbtree_empty_p(VALUE self)
{
    return dict_isempty(DICT(self)) ? Qtrue : Qfalse;
}

/*
 *
 */
VALUE
rbtree_default(int argc, VALUE* argv, VALUE self)
{
    rbtree_check_argument_count(argc, 0, 1);
    if (FL_TEST(self, RBTREE_PROC_DEFAULT)) {
        if (argc == 0) {
            return Qnil;
        }
        return rb_funcall(IFNONE(self), id_call, 2, self, argv[0]);
    }
    return IFNONE(self);
}

/*
 *
 */
VALUE
rbtree_set_default(VALUE self, VALUE ifnone)
{
    rbtree_modify(self);
    IFNONE(self) = ifnone;
    FL_UNSET(self, RBTREE_PROC_DEFAULT);
    return ifnone;
}

/*
 *
 */
VALUE
rbtree_default_proc(VALUE self)
{
    if (FL_TEST(self, RBTREE_PROC_DEFAULT))
        return IFNONE(self);
    return Qnil;
}

/*
 *
 */
VALUE
rbtree_set_default_proc(VALUE self, VALUE proc)
{
    VALUE temp;
    
    rbtree_modify(self);
    if (NIL_P(proc)) {
        IFNONE(self) = Qnil;
        FL_UNSET(self, RBTREE_PROC_DEFAULT);
        return Qnil;
    }
    
    temp = rb_check_convert_type(proc, T_DATA, "Proc", "to_proc");
    if (NIL_P(temp)) {
        rb_raise(rb_eTypeError,
                 "wrong default_proc type %s (expected Proc)",
                 rb_obj_classname(proc));
    }
    rbtree_check_proc_arity(temp, 2);
    IFNONE(self) = temp;
    FL_SET(self, RBTREE_PROC_DEFAULT);
    return proc;
}

static VALUE
rbtree_recursive_equal(VALUE self, VALUE other, int recursive)
{
    dict_t* dict1 = DICT(self);
    dict_t* dict2 = DICT(other);
    dnode_t* node1;
    dnode_t* node2;
    
    if (recursive)
        return Qtrue;
    for (node1 = dict_first(dict1), node2 = dict_first(dict2);
         node1 != NULL && node2 != NULL;
         node1 = dict_next(dict1, node1), node2 = dict_next(dict2, node2)) {
        
        if (!rb_equal(GET_KEY(node1), GET_KEY(node2)) ||
            !rb_equal(GET_VAL(node1), GET_VAL(node2))) {
            
            return Qfalse;
        }
    }
    return Qtrue;
}

/*
 *
 */
VALUE
rbtree_equal(VALUE self, VALUE other)
{
    if (self == other)
        return Qtrue;
    if (!rb_obj_is_kind_of(other, MultiRBTree))
        return Qfalse;
    if (dict_count(DICT(self)) != dict_count(DICT(other)) ||
        DICT(self)->dict_compare != DICT(other)->dict_compare ||
        CMP_PROC(self) != CMP_PROC(other)) {
        
        return Qfalse;
    }
#if defined(HAVE_RB_EXEC_RECURSIVE_PAIRED)
    return rb_exec_recursive_paired(rbtree_recursive_equal, self, other, other);
#elif defined(HAVE_RB_EXEC_RECURSIVE)
    return rb_exec_recursive(rbtree_recursive_equal, self, other);
#else
    return rbtree_recursive_equal(self, other, 0);
#endif
}

/*********************************************************************/

typedef enum {
    EACH_NEXT, EACH_STOP
} each_return_t;

typedef each_return_t (*each_callback_func)(dnode_t*, void*);

typedef struct {
    VALUE self;
    each_callback_func func;
    void* arg;
    int reverse;
} rbtree_each_arg_t;

static VALUE
rbtree_each_ensure(VALUE self)
{
    ITER_LEV(self)--;
    return Qnil;
}

static VALUE
rbtree_each_body(rbtree_each_arg_t* arg)
{
    VALUE self = arg->self;
    dict_t* dict = DICT(self);
    dnode_t* node;
    dnode_t* first_node;
    dnode_t* (*next_func)(dict_t*, dnode_t*);
    
    if (arg->reverse) {
        first_node = dict_last(dict);
        next_func = dict_prev;
    } else {
        first_node = dict_first(dict);
        next_func = dict_next;
    }
    
    ITER_LEV(self)++;
    for (node = first_node;
         node != NULL;
         node = next_func(dict, node)) {
        
        if (arg->func(node, arg->arg) == EACH_STOP)
            break;
    }
    return self;
}

static VALUE
rbtree_for_each(VALUE self, each_callback_func func, void* arg)
{
    rbtree_each_arg_t each_arg;
    each_arg.self = self;
    each_arg.func = func;
    each_arg.arg = arg;
    each_arg.reverse = 0;
    return rb_ensure(rbtree_each_body, (VALUE)&each_arg,
                     rbtree_each_ensure, self);
}

static VALUE
rbtree_reverse_for_each(VALUE self, each_callback_func func, void* arg)
{
    rbtree_each_arg_t each_arg;
    each_arg.self = self;
    each_arg.func = func;
    each_arg.arg = arg;
    each_arg.reverse = 1;
    return rb_ensure(rbtree_each_body, (VALUE)&each_arg,
                     rbtree_each_ensure, self);
}

/*********************************************************************/

static each_return_t
each_pair_i(dnode_t* node, void* arg)
{
    rb_yield(ASSOC(node));
    return EACH_NEXT;
}

/*
 * call-seq:
 *   rbtree.each      {|key, value| block} => rbtree
 *   rbtree.each_pair {|key, value| block} => rbtree
 *   rbtree.each                           => enumerator
 *   rbtree.each_pair                      => enumerator
 *
 * Calls block once for each key in order, passing the key-value pair
 * as parameters.
 *
 * Returns an enumerator if no block is given.
 */
VALUE
rbtree_each_pair(VALUE self)
{
    RETURN_SIZED_ENUMERATOR(self, 0, NULL, rbtree_size);
    return rbtree_for_each(self, each_pair_i, NULL);
}

static each_return_t
each_key_i(dnode_t* node, void* arg)
{
    rb_yield(GET_KEY(node));
    return EACH_NEXT;
}

/*
 * call-seq:
 *   rbtree.each_key {|key| block} => rbtree
 *   rbtree.each_key               => enumerator
 *
 * Calls block once for each key in order, passing the key as a
 * parameter.
 *
 * Returns an enumerator if no block is given.
 */
VALUE
rbtree_each_key(VALUE self)
{
    RETURN_SIZED_ENUMERATOR(self, 0, NULL, rbtree_size);
    return rbtree_for_each(self, each_key_i, NULL);
}

static each_return_t
each_value_i(dnode_t* node, void* arg)
{
    rb_yield(GET_VAL(node));
    return EACH_NEXT;
}

/*
 * call-seq:
 *   rbtree.each_value {|value| block} => rbtree
 *   rbtree.each_value                 => enumerator
 *
 * Calls block once for each key in order, passing the value as a
 * parameter.
 *
 * Returns an enumerator if no block is given.
 */
VALUE
rbtree_each_value(VALUE self)
{
    RETURN_SIZED_ENUMERATOR(self, 0, NULL, rbtree_size);
    return rbtree_for_each(self, each_value_i, NULL);
}

/*
 * call-seq:
 *   rbtree.reverse_each {|key, value| block} => rbtree
 *   rbtree.reverse_each                      => enumerator
 *
 * Calls block once for each key in reverse order, passing the
 * key-value pair as parameters.
 *
 * Returns an enumerator if no block is given.
 */
VALUE
rbtree_reverse_each(VALUE self)
{
    RETURN_SIZED_ENUMERATOR(self, 0, NULL, rbtree_size);
    return rbtree_reverse_for_each(self, each_pair_i, NULL);
}

static each_return_t
aset_i(dnode_t* node, void* self)
{
    rbtree_aset((VALUE)self, GET_KEY(node), GET_VAL(node));
    return EACH_NEXT;
}

static void
copy_dict(VALUE src, VALUE dest, dict_comp_t cmp_func, VALUE cmp_proc)
{
    VALUE temp = rbtree_alloc(CLASS_OF(dest));
#ifdef HAVE_RB_OBJ_HIDE
    rb_obj_hide(temp);
#else
    RBASIC(temp)->klass = 0;
#endif
    DICT(temp)->dict_compare = cmp_func;
    CMP_PROC(temp) = cmp_proc;

    rbtree_for_each(src, aset_i, (void*)temp);
    {
        dict_t* t = DICT(temp);
        DICT(temp) = DICT(dest);
        DICT(dest) = t;
    }
    rbtree_free(RBTREE(temp));
    RBTREE(temp) = NULL;
    rb_gc_force_recycle(temp);

    DICT(dest)->dict_context = RBTREE(dest);
    CMP_PROC(dest) = cmp_proc;
}

/*
 *
 */
VALUE
rbtree_initialize_copy(VALUE self, VALUE other)
{
    rbtree_modify(self);
    
    if (self == other)
        return self;
    if (!rb_obj_is_kind_of(other, CLASS_OF(self))) {
        rb_raise(rb_eTypeError, "wrong argument type %s (expected %s)",
                 rb_obj_classname(other),
                 rb_obj_classname(self));
    }
    
    copy_dict(other, self, DICT(other)->dict_compare, CMP_PROC(other));
    
    IFNONE(self) = IFNONE(other);
    if (FL_TEST(other, RBTREE_PROC_DEFAULT))
        FL_SET(self, RBTREE_PROC_DEFAULT);
    else
        FL_UNSET(self, RBTREE_PROC_DEFAULT);
    return self;
}

/*
 *
 */
VALUE
rbtree_values_at(int argc, VALUE* argv, VALUE self)
{
    long i;
    VALUE ary = rb_ary_new2(argc);
    
    for (i = 0; i < argc; i++)
        rb_ary_push(ary, rbtree_aref(self, argv[i]));
    return ary;
}

static each_return_t
key_i(dnode_t* node, void* args_)
{
    VALUE* args = (VALUE*)args_;
    if (rb_equal(GET_VAL(node), args[1])) {
        args[0] = GET_KEY(node);
        return EACH_STOP;
    }
    return EACH_NEXT;
}

/*
 *
 */
VALUE
rbtree_key(VALUE self, VALUE value)
{
    VALUE args[2];
    args[0] = Qnil;
    args[1] = value;
    rbtree_for_each(self, key_i, &args);
    return args[0];
}

/*
 *
 */
VALUE
rbtree_index(VALUE self, VALUE value)
{
    VALUE klass = rb_obj_is_kind_of(self, RBTree) ? RBTree : MultiRBTree;
    const char* classname = rb_class2name(klass);
    rb_warn("%s#index is deprecated; use %s#key", classname, classname);
    return rbtree_key(self, value);
}

/*
 *
 */
VALUE
rbtree_clear(VALUE self)
{
    rbtree_modify(self);
    dict_free_nodes(DICT(self));
    return self;
}

/*
 *
 */
VALUE
rbtree_delete(VALUE self, VALUE key)
{
    dict_t* dict = DICT(self);
    dnode_t* node;
    VALUE value;

    rbtree_modify(self);
    node = dict_lookup(dict, TO_KEY(key));
    if (node == NULL)
        return rb_block_given_p() ? rb_yield(key) : Qnil;
    value = GET_VAL(node);
    dict_delete_free(dict, node);
    return value;
}

/*********************************************************************/

typedef struct dnode_list_t_ {
    struct dnode_list_t_* prev;
    dnode_t* node;
} dnode_list_t;

typedef struct {
    VALUE self;
    dnode_list_t* list;
    int raised;
    int if_true;
} rbtree_remove_if_arg_t;

static VALUE
rbtree_remove_if_ensure(rbtree_remove_if_arg_t* arg)
{
    dict_t* dict = DICT(arg->self);
    dnode_list_t* list = arg->list;

    if (--ITER_LEV(arg->self) == 0) {
        while (list != NULL) {
            dnode_list_t* l = list;
            if (!arg->raised)
                dict_delete_free(dict, l->node);
            list = l->prev;
            xfree(l);
        }
    }
    return Qnil;
}

static VALUE
rbtree_remove_if_body(rbtree_remove_if_arg_t* arg)
{
    VALUE self = arg->self;
    dict_t* dict = DICT(self);
    dnode_t* node;

    arg->raised = 1;
    ITER_LEV(self)++;
    for (node = dict_first(dict);
         node != NULL;
         node = dict_next(dict, node)) {

        VALUE key = GET_KEY(node);
        VALUE value = GET_VAL(node);
        if (RTEST(rb_yield_values(2, key, value)) == arg->if_true) {
            dnode_list_t* l = ALLOC(dnode_list_t);
            l->node = node;
            l->prev = arg->list;
            arg->list = l;
        }
    }
    arg->raised = 0;
    return self;
}

static VALUE
rbtree_remove_if(VALUE self, const int if_true)
{
    rbtree_remove_if_arg_t arg;
    
    RETURN_SIZED_ENUMERATOR(self, 0, NULL, rbtree_size);
    rbtree_modify(self);
    arg.self = self;
    arg.list = NULL;
    arg.if_true = if_true;
    return rb_ensure(rbtree_remove_if_body, (VALUE)&arg,
                     rbtree_remove_if_ensure, (VALUE)&arg);
}

/*********************************************************************/

/*
 *
 */
VALUE
rbtree_delete_if(VALUE self)
{
    return rbtree_remove_if(self, 1);
}

/*
 *
 */
VALUE
rbtree_keep_if(VALUE self)
{
    return rbtree_remove_if(self, 0);
}

/*
 *
 */
VALUE
rbtree_reject_bang(VALUE self)
{
    dictcount_t count;
    
    RETURN_SIZED_ENUMERATOR(self, 0, NULL, rbtree_size);
    count = dict_count(DICT(self));
    rbtree_delete_if(self);
    if (count == dict_count(DICT(self)))
        return Qnil;
    return self;
}

/*
 *
 */
VALUE
rbtree_select_bang(VALUE self)
{
    dictcount_t count;
    
    RETURN_SIZED_ENUMERATOR(self, 0, NULL, rbtree_size);
    count = dict_count(DICT(self));
    rbtree_keep_if(self);
    if (count == dict_count(DICT(self)))
        return Qnil;
    return self;
    
}

/*********************************************************************/

typedef struct {
    VALUE result;
    int if_true;
} rbtree_select_if_arg_t;

static each_return_t
select_i(dnode_t* node, void* arg_)
{
    VALUE key = GET_KEY(node);
    VALUE value = GET_VAL(node);
    rbtree_select_if_arg_t* arg = arg_;
    
    if (RTEST(rb_yield_values(2, key, value)) == arg->if_true) {
        rbtree_aset(arg->result, key, value);
    }
    return EACH_NEXT;
}

static VALUE
rbtree_select_if(VALUE self, const int if_true)
{
    rbtree_select_if_arg_t arg;
    
    RETURN_SIZED_ENUMERATOR(self, 0, NULL, rbtree_size);
    arg.result = rbtree_alloc(CLASS_OF(self));
    arg.if_true = if_true;
    rbtree_for_each(self, select_i, &arg);
    return arg.result;
}

/*********************************************************************/

/*
 *
 */
VALUE
rbtree_reject(VALUE self)
{
    return rbtree_select_if(self, 0);
}

/*
 *
 */
VALUE
rbtree_select(VALUE self)
{
    return rbtree_select_if(self, 1);
}

static VALUE
rbtree_shift_pop(VALUE self, const int shift)
{
    dict_t* dict = DICT(self);
    dnode_t* node;
    VALUE assoc;

    rbtree_modify(self);

    if (dict_isempty(dict))
        return rb_funcall(self, id_default, 1, Qnil);
    
    if (shift)
        node = dict_last(dict);
    else
        node = dict_first(dict);
    assoc = ASSOC(node);
    dict_delete_free(dict, node);
    return assoc;
}

/*
 * call-seq:
 *   rbtree.shift => array or object or nil
 *
 * Removes the first (that is, the smallest) key-value pair and
 * returns it.
 */
VALUE
rbtree_shift(VALUE self)
{
    return rbtree_shift_pop(self, 0);
}

/*
 * call-seq:
 *   rbtree.pop => array or object or nil
 *
 * Removes the last (that is, the greatest) key-value pair and returns
 * it.
 */
VALUE
rbtree_pop(VALUE self)
{
    return rbtree_shift_pop(self, 1);
}

static each_return_t
invert_i(dnode_t* node, void* rbtree)
{
    rbtree_aset((VALUE)rbtree, GET_VAL(node), GET_KEY(node));
    return EACH_NEXT;
}

/*
 *
 */
VALUE
rbtree_invert(VALUE self)
{
    VALUE rbtree = rbtree_alloc(CLASS_OF(self));
    rbtree_for_each(self, invert_i, (void*)rbtree);
    return rbtree;
}

static each_return_t
update_block_i(dnode_t* node, void* self_)
{
    VALUE self = (VALUE)self_;
    VALUE key = GET_KEY(node);
    VALUE value = GET_VAL(node);

    if (rbtree_has_key(self, key))
        value = rb_yield_values(3, key, rbtree_aref(self, key), value);
    rbtree_aset(self, key, value);
    return EACH_NEXT;
}

/*
 *
 */
VALUE
rbtree_update(VALUE self, VALUE other)
{
    rbtree_modify(self);

    if (self == other)
        return self;
    if (!rb_obj_is_kind_of(other, CLASS_OF(self))) {
        rb_raise(rb_eTypeError, "wrong argument type %s (expected %s)",
                 rb_obj_classname(other),
                 rb_obj_classname(self));
    }
    
    if (rb_block_given_p())
        rbtree_for_each(other, update_block_i, (void*)self);
    else
        rbtree_for_each(other, aset_i, (void*)self);
    return self;
}

/*
 *
 */
VALUE
rbtree_merge(VALUE self, VALUE other)
{
    return rbtree_update(rb_obj_dup(self), other);
}

static each_return_t
to_flat_ary_i(dnode_t* node, void* ary)
{
    rb_ary_push((VALUE)ary, GET_KEY(node));
    rb_ary_push((VALUE)ary, GET_VAL(node));
    return EACH_NEXT;
}

/*
 *
 */
VALUE
rbtree_flatten(int argc, VALUE* argv, VALUE self)
{
    VALUE ary;

    rbtree_check_argument_count(argc, 0, 1);
    ary = rb_ary_new2(dict_count(DICT(self)) * 2);
    rbtree_for_each(self, to_flat_ary_i, (void*)ary);
    if (argc == 1) {
        const int level = NUM2INT(argv[0]) - 1;
        if (level > 0) {
            argv[0] = INT2FIX(level);
            rb_funcall2(ary, id_flatten_bang, argc, argv);
        }
    }
    return ary;
}

/*
 *
 */
VALUE
rbtree_has_key(VALUE self, VALUE key)
{
    return dict_lookup(DICT(self), TO_KEY(key)) == NULL ? Qfalse : Qtrue;
}

static each_return_t
has_value_i(dnode_t* node, void* args_)
{
    VALUE* args = (VALUE*)args_;
    if (rb_equal(GET_VAL(node), args[1])) {
        args[0] = Qtrue;
        return EACH_STOP;
    }
    return EACH_NEXT;
}

/*
 *
 */
VALUE
rbtree_has_value(VALUE self, VALUE value)
{
    VALUE args[2];
    args[0] = Qfalse;
    args[1] = value;
    rbtree_for_each(self, has_value_i, &args);
    return args[0];
}

static each_return_t
keys_i(dnode_t* node, void* ary)
{
    rb_ary_push((VALUE)ary, GET_KEY(node));
    return EACH_NEXT;
}

/*
 *
 */
VALUE
rbtree_keys(VALUE self)
{
    VALUE ary = rb_ary_new2(dict_count(DICT(self)));
    rbtree_for_each(self, keys_i, (void*)ary);
    return ary;
}

static each_return_t
values_i(dnode_t* node, void* ary)
{
    rb_ary_push((VALUE)ary, GET_VAL(node));
    return EACH_NEXT;
}

/*
 *
 */
VALUE
rbtree_values(VALUE self)
{
    VALUE ary = rb_ary_new2(dict_count(DICT(self)));
    rbtree_for_each(self, values_i, (void*)ary);
    return ary;
}

static each_return_t
to_a_i(dnode_t* node, void* ary)
{
    rb_ary_push((VALUE)ary, ASSOC(node));
    return EACH_NEXT;
}

/*
 *
 */
VALUE
rbtree_to_a(VALUE self)
{
    VALUE ary = rb_ary_new2(dict_count(DICT(self)));
    rbtree_for_each(self, to_a_i, (void*)ary);
    OBJ_INFECT(ary, self);
    return ary;
}

static each_return_t
to_hash_i(dnode_t* node, void* hash)
{
    rb_hash_aset((VALUE)hash, GET_KEY(node), GET_VAL(node));
    return EACH_NEXT;
}

/*
 *
 */
VALUE
rbtree_to_hash(VALUE self)
{
    VALUE hash;
    if (!rb_obj_is_kind_of(self, RBTree))
        rb_raise(rb_eTypeError, "can't convert MultiRBTree to Hash");
    
    hash = rb_hash_new();
    rbtree_for_each(self, to_hash_i, (void*)hash);
    RHASH_SET_IFNONE(hash, IFNONE(self));
    if (FL_TEST(self, RBTREE_PROC_DEFAULT))
        FL_SET(hash, HASH_PROC_DEFAULT);
    OBJ_INFECT(hash, self);
    return hash;
}

/*
 *
 */
VALUE
rbtree_to_rbtree(VALUE self)
{
    return self;
}

static VALUE
rbtree_begin_inspect(VALUE self)
{
    VALUE result = rb_str_new2("#<");
    rb_str_cat2(result, rb_obj_classname(self));
    rb_str_cat2(result, ": ");
    return result;
}

static each_return_t
inspect_i(dnode_t* node, void* result_)
{
    VALUE result = (VALUE)result_;
    VALUE str;

    if (RSTRING_PTR(result)[0] == '-')
        RSTRING_PTR(result)[0] = '#';
    else
        rb_str_cat2(result, ", ");

    str = rb_inspect(GET_KEY(node));
    rb_str_append(result, str);
    OBJ_INFECT(result, str);

    rb_str_cat2(result, "=>");

    str = rb_inspect(GET_VAL(node));
    rb_str_append(result, str);
    OBJ_INFECT(result, str);

    return EACH_NEXT;
}

static VALUE
inspect_rbtree(VALUE self, VALUE result)
{
    VALUE str;
    
    rb_str_cat2(result, "{");
    RSTRING_PTR(result)[0] = '-';
    rbtree_for_each(self, inspect_i, (void*)result);
    RSTRING_PTR(result)[0] = '#';
    rb_str_cat2(result, "}");

    str = rb_inspect(IFNONE(self));
    rb_str_cat2(result, ", default=");
    rb_str_append(result, str);
    OBJ_INFECT(result, str);
    
    str = rb_inspect(CMP_PROC(self));
    rb_str_cat2(result, ", cmp_proc=");
    rb_str_append(result, str);
    OBJ_INFECT(result, str);

    rb_str_cat2(result, ">");
    OBJ_INFECT(result, self);
    return result;
}

static VALUE
rbtree_inspect_recursive(VALUE self, VALUE arg, int recursive)
{
    VALUE str = rbtree_begin_inspect(self);
    if (recursive)
        return rb_str_cat2(str, "...>");
    return inspect_rbtree(self, str);
}

/*
 *
 */
VALUE
rbtree_inspect(VALUE self)
{
#ifdef HAVE_RB_EXEC_RECURSIVE
    return rb_exec_recursive(rbtree_inspect_recursive, self, Qnil);
#else
    VALUE str = rbtree_begin_inspect(self);
    if (rb_inspecting_p(self))
        return rb_str_cat2(str, "...>");
    return rb_protect_inspect(inspect_rbtree, self, str);
#endif
}

/*
 * call-seq:
 *   rbtree.lower_bound(key) => array or nil
 *
 * Retruns the key-value pair corresponding to the lowest key that is
 * equal to or greater than the given key (inside the lower
 * boundary). If there is no such key, returns nil.
 *
 *   rbtree = RBTree["az", 10, "ba", 20]
 *   rbtree.lower_bound("ba") # => ["ba", 20]
 *
 *   # "ba" is the lowest key that is greater than "b"
 *   rbtree.lower_bound("b") # => ["ba", 20]
 *
 *   # no key that is equal to or greater than "c"
 *   rbtree.lower_bound("c") # => nil
 */
VALUE
rbtree_lower_bound(VALUE self, VALUE key)
{
    dnode_t* node = dict_lower_bound(DICT(self), TO_KEY(key));
    if (node == NULL)
        return Qnil;
    return ASSOC(node);
}

/*
 * call-seq:
 *   rbtree.upper_bound(key) => array or nil
 *
 * Retruns the key-value pair corresponding to the greatest key that
 * is equal to or lower than the given key (inside the upper
 * boundary). If there is no such key, returns nil.
 *
 *   rbtree = RBTree["az", 10, "ba", 20]
 *   rbtree.upper_bound("ba") # => ["ba", 20]
 *
 *   # "az" is the greatest key that is lower than "b"
 *   rbtree.upper_bound("b") # => ["az", 10]
 *
 *   # no key that is equal to or lower than "a"
 *   rbtree.upper_bound("a") # => nil
 */
VALUE
rbtree_upper_bound(VALUE self, VALUE key)
{
    dnode_t* node = dict_upper_bound(DICT(self), TO_KEY(key));
    if (node == NULL)
        return Qnil;
    return ASSOC(node);
}

/*********************************************************************/

typedef struct {
    VALUE self;
    dnode_t* lower_node;
    dnode_t* upper_node;
    VALUE result;
} rbtree_bound_arg_t;

static VALUE
rbtree_bound_body(rbtree_bound_arg_t* arg)
{
    VALUE self = arg->self;
    dict_t* dict = DICT(self);
    dnode_t* lower_node = arg->lower_node;
    dnode_t* upper_node = arg->upper_node;
    const int block_given = rb_block_given_p();
    VALUE result = arg->result;
    dnode_t* node;

    ITER_LEV(self)++;
    for (node = lower_node;
         node != NULL;
         node = dict_next(dict, node)) {

        if (block_given)
            rb_yield_values(2, GET_KEY(node), GET_VAL(node));
        else
            rb_ary_push(result, ASSOC(node));
        if (node == upper_node)
            break;
    }
    return result;
}

#ifdef HAVE_SIZED_ENUMERATOR
static VALUE
rbtree_bound_size(VALUE self, VALUE args)
{
    VALUE key1 = RARRAY_AREF(args, 0);
    VALUE key2 = RARRAY_AREF(args, RARRAY_LEN(args) - 1);
    dnode_t* lower_node = dict_lower_bound(DICT(self), TO_KEY(key1));
    dnode_t* upper_node = dict_upper_bound(DICT(self), TO_KEY(key2));
    dictcount_t count = 0;
    dnode_t* node;
    
    if (lower_node == NULL || upper_node == NULL ||
        DICT(self)->dict_compare(dnode_getkey(lower_node),
                                 dnode_getkey(upper_node),
                                 DICT(self)->dict_context) > 0) {
        return INT2FIX(0);
    }
    
    for (node = lower_node;
         node != NULL;
         node = dict_next(DICT(self), node)) {
        
        count++;
        if (node == upper_node) {
            break;
        }
    }
    return ULONG2NUM(count);
}
#endif

/*********************************************************************/

/*
 * call-seq:
 *   rbtree.bound(key1, key2 = key1) {|key, value| block} => rbtree
 *   rbtree.bound(key1, key2 = key1)                      => enumerator
 *
 * Calls block once for each key between the result of
 * rbtree.lower_bound(key1) and rbtree.upper_bound(key2) in order,
 * passing the key-value pair as parameters. If the lower bound
 * exceeds the upper bound, block is not called.
 *
 * Returns an enumerator if no block is given.
 *
 *   mrbtree = MultiRBTree["az", 10, "ba", 20, "ba", 30, "bz", 40]
 *   mrbtree.bound("ba").to_a # => [["ba", 20], ["ba", 30]]
 *   mrbtree.bound("b", "c").to_a # => [["ba", 20], ["ba", 30], ["bz", 40]]
 *   
 *   # the lower bound ("ba") exceeds the upper bound ("az")
 *   mrbtree.bound("b").to_a # => []
 */
VALUE
rbtree_bound(int argc, VALUE* argv, VALUE self)
{
    dict_t* dict = DICT(self);
    dnode_t* lower_node;
    dnode_t* upper_node;
    VALUE result;
    
    rbtree_check_argument_count(argc, 1, 2);
    
    RETURN_SIZED_ENUMERATOR(self, argc, argv, rbtree_bound_size);
    
    lower_node = dict_lower_bound(dict, TO_KEY(argv[0]));
    upper_node = dict_upper_bound(dict, TO_KEY(argv[argc - 1]));
    result = rb_block_given_p() ? self : rb_ary_new();
    
    if (lower_node == NULL || upper_node == NULL ||
        DICT(self)->dict_compare(dnode_getkey(lower_node),
                                 dnode_getkey(upper_node),
                                 DICT(self)->dict_context) > 0) {
        return result;
    } else {
        rbtree_bound_arg_t arg;
        arg.self = self;
        arg.lower_node = lower_node;
        arg.upper_node = upper_node;
        arg.result = result;
        return rb_ensure(rbtree_bound_body, (VALUE)&arg,
                         rbtree_each_ensure, self);
    }
}

static VALUE
rbtree_first_last(VALUE self, const int first)
{
    dict_t* dict = DICT(self);
    dnode_t* node;

    if (dict_isempty(dict))
        return rb_funcall(self, id_default, 1, Qnil);
    
    if (first)
        node = dict_first(dict);
    else
        node = dict_last(dict);
    return ASSOC(node);
}

/*
 * call-seq:
 *   rbtree.first => array or object or nil
 *
 * Returns the first (that is, the smallest) key-value pair.
 */
VALUE
rbtree_first(VALUE self)
{
    return rbtree_first_last(self, 1);
}

/*
 * call-seq:
 *   rbtree.last => array or object or nil
 *
 * Returns the last (that is, the greatest) key-value pair.
 */
VALUE
rbtree_last(VALUE self)
{
    return rbtree_first_last(self, 0);
}

/*
 * call-seq:
 *   rbtree.readjust                      => rbtree
 *   rbtree.readjust(nil)                 => rbtree
 *   rbtree.readjust(proc)                => rbtree
 *   rbtree.readjust {|key1, key2| block} => rbtree
 *
 * Sets a proc to compare keys and readjusts elements using the given
 * block or a Proc object given as an argument. The block takes two
 * keys and returns a negative integer, 0, or a positive integer as
 * the first argument is less than, equal to, or greater than the
 * second one. If no block is given, just readjusts elements using the
 * current comparison block. If nil is given as an argument the
 * default comparison block that uses the <=> method is set.
 *
 *   rbtree = RBTree["a", 10, "b", 20]
 *   rbtree.readjust {|a, b| b <=> a }
 *   rbtree.first # => ["b", 20]
 *   
 *   rbtree.readjust(nil)
 *   rbtree.first # => ["a", 10]
 */
VALUE
rbtree_readjust(int argc, VALUE* argv, VALUE self)
{
    dict_comp_t cmp_func = NULL;
    VALUE cmp_proc = Qnil;
    
    rbtree_modify(self);

    if (rb_block_given_p()) {
        rbtree_check_argument_count(argc, 0, 0);
        cmp_func = rbtree_user_cmp;
        cmp_proc = rb_block_proc();
        rbtree_check_proc_arity(cmp_proc, 2);
    } else {
        rbtree_check_argument_count(argc, 0, 1);
        if (argc == 0) {
            cmp_func = DICT(self)->dict_compare;
            cmp_proc = CMP_PROC(self);
        } else {
            if (NIL_P(argv[0])) {
                cmp_func = rbtree_cmp;
                cmp_proc = Qnil;
            } else {
                VALUE proc = rb_check_convert_type(argv[0], T_DATA, "Proc", "to_proc");
                if (NIL_P(proc)) {
                    rb_raise(rb_eTypeError,
                             "wrong cmp_proc type %s (expected Proc)",
                             rb_obj_classname(argv[0]));
                }
                cmp_func = rbtree_user_cmp;
                cmp_proc = proc;
                rbtree_check_proc_arity(cmp_proc, 2);
            }
        }
    }

    if (dict_isempty(DICT(self))) {
        DICT(self)->dict_compare = cmp_func;
        CMP_PROC(self) = cmp_proc;
        return self;
    }
    copy_dict(self, self, cmp_func, cmp_proc);
    return self;
}

/*
 * call-seq:
 *   rbtree.cmp_proc => proc or nil
 *
 * Returns the comparison block that is set by
 * MultiRBTree#readjust. If the default comparison block is set,
 * returns nil.
 */
VALUE
rbtree_cmp_proc(VALUE self)
{
    return CMP_PROC(self);
}

/*********************************************************************/

static ID id_breakable;
static ID id_comma_breakable;
static ID id_group;
static ID id_object_group;
static ID id_pp;
static ID id_text;

static VALUE
pp_group(VALUE args_)
{
    VALUE* args = (VALUE*)args_;
    return rb_funcall(args[0], id_group, 3, args[1], args[2], args[3]);
}

typedef struct {
    VALUE pp;
    dnode_t* node;
} pp_pair_arg_t;

static VALUE
pp_value(VALUE nil, pp_pair_arg_t* pair_arg)
{
    VALUE pp = pair_arg->pp;
    rb_funcall(pp, id_breakable, 1, rb_str_new(NULL, 0));
    return rb_funcall(pp, id_pp, 1, GET_VAL(pair_arg->node));
}

static VALUE
pp_pair(VALUE nil, pp_pair_arg_t* pair_arg)
{
    VALUE pp = pair_arg->pp;
    VALUE group_args[4];
    group_args[0] = pp;
    group_args[1] = INT2FIX(1);
    group_args[2] = rb_str_new(NULL, 0);
    group_args[3] = rb_str_new(NULL, 0);
    
    rb_funcall(pp, id_pp, 1, GET_KEY(pair_arg->node));
    rb_funcall(pp, id_text, 1, rb_str_new2("=>"));
    return rb_iterate(pp_group, (VALUE)&group_args, pp_value, (VALUE)pair_arg);
}

typedef struct {
    VALUE pp;
    int first;
} pp_each_pair_arg_t;

static each_return_t
pp_each_pair_i(dnode_t* node, void* each_pair_arg_)
{
    pp_each_pair_arg_t* each_pair_arg = (pp_each_pair_arg_t*)each_pair_arg_;
    VALUE group_args[4];
    pp_pair_arg_t pair_arg;
    
    if (each_pair_arg->first) {
        each_pair_arg->first = 0;
    } else {
        rb_funcall(each_pair_arg->pp, id_comma_breakable, 0);
    }
    
    group_args[0] = each_pair_arg->pp;
    group_args[1] = INT2FIX(0);
    group_args[2] = rb_str_new(NULL, 0);
    group_args[3] = rb_str_new(NULL, 0);
    
    pair_arg.pp = each_pair_arg->pp;
    pair_arg.node = node;
    
    rb_iterate(pp_group, (VALUE)&group_args, pp_pair, (VALUE)&pair_arg);
    return EACH_NEXT;
}

typedef struct {
    VALUE pp;
    VALUE rbtree;
} pp_rbtree_arg_t;

static VALUE
pp_each_pair(VALUE nil, pp_rbtree_arg_t* rbtree_arg)
{
    pp_each_pair_arg_t each_pair_arg;
    each_pair_arg.pp = rbtree_arg->pp;
    each_pair_arg.first = 1;
    return rbtree_for_each(rbtree_arg->rbtree, pp_each_pair_i, &each_pair_arg);
}

static VALUE
pp_rbtree(VALUE nil, pp_rbtree_arg_t* rbtree_arg)
{
    VALUE pp = rbtree_arg->pp;
    VALUE rbtree = rbtree_arg->rbtree;
    
    VALUE group_args[4];
    group_args[0] = pp;
    group_args[1] = INT2FIX(1);
    group_args[2] = rb_str_new2("{");
    group_args[3] = rb_str_new2("}");
    
    rb_funcall(pp, id_text, 1, rb_str_new2(": "));
    rb_iterate(pp_group, (VALUE)&group_args, pp_each_pair, (VALUE)rbtree_arg);
    rb_funcall(pp, id_comma_breakable, 0);
    rb_funcall(pp, id_text, 1, rb_str_new2("default="));
    rb_funcall(pp, id_pp, 1, IFNONE(rbtree));
    rb_funcall(pp, id_comma_breakable, 0);
    rb_funcall(pp, id_text, 1, rb_str_new2("cmp_proc="));
    return rb_funcall(pp, id_pp, 1, CMP_PROC(rbtree));
}

static VALUE
pp_rbtree_group(VALUE arg_)
{
    pp_rbtree_arg_t* arg = (pp_rbtree_arg_t*)arg_;
    return rb_funcall(arg->pp, id_object_group, 1, arg->rbtree);
}

/*********************************************************************/

/* :nodoc:
 *
 */
VALUE
rbtree_pretty_print(VALUE self, VALUE pp)
{
    pp_rbtree_arg_t arg;
    arg.rbtree = self;
    arg.pp = pp;
    return rb_iterate(pp_rbtree_group, (VALUE)&arg, pp_rbtree, (VALUE)&arg);
}

/* :nodoc:
 *
 */
VALUE
rbtree_pretty_print_cycle(VALUE self, VALUE pp)
{
    return rb_funcall(pp, id_pp, 1, rbtree_inspect_recursive(self, Qnil, 1));
}

/*********************************************************************/

/* :nodoc:
 *
 */
VALUE
rbtree_dump(VALUE self, VALUE limit)
{
    VALUE ary;
    VALUE result;
    
    if (FL_TEST(self, RBTREE_PROC_DEFAULT))
        rb_raise(rb_eTypeError, "can't dump rbtree with default proc");
    if (CMP_PROC(self) != Qnil)
        rb_raise(rb_eTypeError, "can't dump rbtree with comparison proc");
    
    ary = rb_ary_new2(dict_count(DICT(self)) * 2 + 1);
    rbtree_for_each(self, to_flat_ary_i, (void*)ary);
    rb_ary_push(ary, IFNONE(self));

    result = rb_marshal_dump(ary, limit);
#ifdef HAVE_RB_ARY_RESIZE
    rb_ary_resize(ary, 0);
#else
    rb_ary_clear(ary);
#endif
    return result;
}

/* :nodoc:
 *
 */
VALUE
rbtree_s_load(VALUE klass, VALUE str)
{
    VALUE rbtree = rbtree_alloc(klass);
    VALUE ary = rb_marshal_load(str);
    long len = RARRAY_LEN(ary) - 1;
    long i;
    
    for (i = 0; i < len; i += 2)
        rbtree_aset(rbtree, RARRAY_AREF(ary, i), RARRAY_AREF(ary, i + 1));
    IFNONE(rbtree) = RARRAY_AREF(ary, len);
    
#ifdef HAVE_RB_ARY_RESIZE
    rb_ary_resize(ary, 0);
#else
    rb_ary_clear(ary);
#endif
    return rbtree;
}

/*********************************************************************/

/*
 * Document-class: MultiRBTree
 *
 * A sorted associative collection that can contain duplicate keys.
 */
/*
 * A sorted associative collection that cannot contain duplicate
 * keys. RBTree is a subclass of MultiRBTree.
 */
void Init_rbtree()
{
    MultiRBTree = rb_define_class("MultiRBTree", rb_cData);
    RBTree = rb_define_class("RBTree", MultiRBTree);

    rb_include_module(MultiRBTree, rb_mEnumerable);

    rb_define_alloc_func(MultiRBTree, rbtree_alloc);

    rb_define_singleton_method(MultiRBTree, "[]", rbtree_s_create, -1);

    rb_define_method(MultiRBTree, "initialize", rbtree_initialize, -1);
    rb_define_method(MultiRBTree, "initialize_copy", rbtree_initialize_copy, 1);

    rb_define_method(MultiRBTree, "to_a", rbtree_to_a, 0);
    rb_define_method(MultiRBTree, "to_h", rbtree_to_hash, 0);
    rb_define_method(MultiRBTree, "to_hash", rbtree_to_hash, 0);
    rb_define_method(MultiRBTree, "to_rbtree", rbtree_to_rbtree, 0);
    rb_define_method(MultiRBTree, "inspect", rbtree_inspect, 0);
    rb_define_alias(MultiRBTree, "to_s", "inspect");

    rb_define_method(MultiRBTree, "==", rbtree_equal, 1);
    rb_define_method(MultiRBTree, "[]", rbtree_aref, 1);
    rb_define_method(MultiRBTree, "fetch", rbtree_fetch, -1);
    rb_define_method(MultiRBTree, "lower_bound", rbtree_lower_bound, 1);
    rb_define_method(MultiRBTree, "upper_bound", rbtree_upper_bound, 1);
    rb_define_method(MultiRBTree, "bound", rbtree_bound, -1);
    rb_define_method(MultiRBTree, "first", rbtree_first, 0);
    rb_define_method(MultiRBTree, "last", rbtree_last, 0);
    rb_define_method(MultiRBTree, "[]=", rbtree_aset, 2);
    rb_define_method(MultiRBTree, "store", rbtree_aset, 2);
    rb_define_method(MultiRBTree, "default", rbtree_default, -1);
    rb_define_method(MultiRBTree, "default=", rbtree_set_default, 1);
    rb_define_method(MultiRBTree, "default_proc", rbtree_default_proc, 0);
    rb_define_method(MultiRBTree, "default_proc=", rbtree_set_default_proc, 1);
    rb_define_method(MultiRBTree, "key", rbtree_key, 1);
    rb_define_method(MultiRBTree, "index", rbtree_index, 1);
    rb_define_method(MultiRBTree, "empty?", rbtree_empty_p, 0);
    rb_define_method(MultiRBTree, "size", rbtree_size, 0);
    rb_define_method(MultiRBTree, "length", rbtree_size, 0);

    rb_define_method(MultiRBTree, "each", rbtree_each_pair, 0);
    rb_define_method(MultiRBTree, "each_value", rbtree_each_value, 0);
    rb_define_method(MultiRBTree, "each_key", rbtree_each_key, 0);
    rb_define_method(MultiRBTree, "each_pair", rbtree_each_pair, 0);
    rb_define_method(MultiRBTree, "reverse_each", rbtree_reverse_each, 0);

    rb_define_method(MultiRBTree, "keys", rbtree_keys, 0);
    rb_define_method(MultiRBTree, "values", rbtree_values, 0);
    rb_define_method(MultiRBTree, "values_at", rbtree_values_at, -1);

    rb_define_method(MultiRBTree, "shift", rbtree_shift, 0);
    rb_define_method(MultiRBTree, "pop", rbtree_pop, 0);
    rb_define_method(MultiRBTree, "delete", rbtree_delete, 1);
    rb_define_method(MultiRBTree, "delete_if", rbtree_delete_if, 0);
    rb_define_method(MultiRBTree, "keep_if", rbtree_keep_if, 0);
    rb_define_method(MultiRBTree, "reject", rbtree_reject, 0);
    rb_define_method(MultiRBTree, "reject!", rbtree_reject_bang, 0);
    rb_define_method(MultiRBTree, "select", rbtree_select, 0);
    rb_define_method(MultiRBTree, "select!", rbtree_select_bang, 0);
    rb_define_method(MultiRBTree, "clear", rbtree_clear, 0);
    rb_define_method(MultiRBTree, "invert", rbtree_invert, 0);
    rb_define_method(MultiRBTree, "update", rbtree_update, 1);
    rb_define_method(MultiRBTree, "merge!", rbtree_update, 1);
    rb_define_method(MultiRBTree, "merge", rbtree_merge, 1);
    rb_define_method(MultiRBTree, "replace", rbtree_initialize_copy, 1);
#ifdef HAVE_HASH_FLATTEN
    rb_define_method(MultiRBTree, "flatten", rbtree_flatten, -1);
#endif

    rb_define_method(MultiRBTree, "include?", rbtree_has_key, 1);
    rb_define_method(MultiRBTree, "member?", rbtree_has_key, 1);
    rb_define_method(MultiRBTree, "has_key?", rbtree_has_key, 1);
    rb_define_method(MultiRBTree, "has_value?", rbtree_has_value, 1);
    rb_define_method(MultiRBTree, "key?", rbtree_has_key, 1);
    rb_define_method(MultiRBTree, "value?", rbtree_has_value, 1);

    rb_define_method(MultiRBTree, "readjust", rbtree_readjust, -1);
    rb_define_method(MultiRBTree, "cmp_proc", rbtree_cmp_proc, 0);

    rb_define_method(MultiRBTree, "_dump", rbtree_dump, 1);
    rb_define_singleton_method(MultiRBTree, "_load", rbtree_s_load, 1);
    
    id_cmp = rb_intern("<=>");
    id_call = rb_intern("call");
    id_default = rb_intern("default");
    id_flatten_bang = rb_intern("flatten!");

    rb_define_method(MultiRBTree, "pretty_print", rbtree_pretty_print, 1);
    rb_define_method(MultiRBTree,
                     "pretty_print_cycle", rbtree_pretty_print_cycle, 1);

    id_breakable = rb_intern("breakable");
    id_comma_breakable = rb_intern("comma_breakable");
    id_group = rb_intern("group");
    id_object_group = rb_intern("object_group");
    id_pp = rb_intern("pp");
    id_text = rb_intern("text");
}
