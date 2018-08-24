require 'mkmf'

if enable_config('debug')
  $CFLAGS << ' -g -std=c99 -pedantic -Wall'
else
  $defs << '-DNDEBUG'
end
have_func('rb_exec_recursive', 'ruby.h')
have_func('rb_exec_recursive_paired', 'ruby.h')
have_func('rb_proc_lambda_p', 'ruby.h')
have_func('rb_ary_resize', 'ruby.h')
have_func('rb_obj_hide', 'ruby.h')
if Hash.method_defined?(:flatten)
  $defs << '-DHAVE_HASH_FLATTEN'
end
create_makefile('rbtree')
