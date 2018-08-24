begin
  require "./rbtree"
rescue LoadError
  require "rubygems"
  require "rbtree"
end
require "test/unit.rb"

class RBTreeTest < Test::Unit::TestCase
  def setup
    @rbtree = RBTree[*%w(b B d D a A c C)]
  end
  
  def have_enumerator?
    defined?(Enumerable::Enumerator) or defined?(Enumerator)
  end
  
  def test_new
    assert_nothing_raised {
      RBTree.new
      RBTree.new("a")
      RBTree.new { "a" }
    }
    assert_raises(ArgumentError) { RBTree.new("a") {} }
    assert_raises(ArgumentError) { RBTree.new("a", "a") }

    if RUBY_VERSION >= "1.9.2"
      assert_nothing_raised {
        RBTree.new(&lambda {|a, b|})
        RBTree.new(&lambda {|*a|})
        RBTree.new(&lambda {|a, *b|})
        RBTree.new(&lambda {|a, b, *c|})
      }
      assert_raises(TypeError) { RBTree.new(&lambda {|a|}) }
      assert_raises(TypeError) { RBTree.new(&lambda {|a, b, c|}) }
      assert_raises(TypeError) { RBTree.new(&lambda {|a, b, c, *d|}) }
    end
  end
  
  def test_aref
    assert_equal("A", @rbtree["a"])
    assert_equal("B", @rbtree["b"])
    assert_equal("C", @rbtree["c"])
    assert_equal("D", @rbtree["d"])
    
    assert_equal(nil, @rbtree["e"])
    @rbtree.default = "E"
    assert_equal("E", @rbtree["e"])
  end
  
  def test_size
    assert_equal(4, @rbtree.size)
  end
  
  def test_create
    rbtree = RBTree[]
    assert_equal(0, rbtree.size)
    
    rbtree = RBTree[@rbtree]
    assert_equal(4, rbtree.size)
    assert_equal("A", @rbtree["a"])
    assert_equal("B", @rbtree["b"])
    assert_equal("C", @rbtree["c"])
    assert_equal("D", @rbtree["d"])
    
    rbtree = RBTree[RBTree.new("e")]
    assert_equal(nil, rbtree.default)
    rbtree = RBTree[RBTree.new { "e" }]
    assert_equal(nil, rbtree.default_proc)
    @rbtree.readjust {|a,b| b <=> a }
    assert_equal(nil, RBTree[@rbtree].cmp_proc)
    
    assert_raises(ArgumentError) { RBTree["e"] }
    
    rbtree = RBTree[Hash[*%w(b B d D a A c C)]]
    assert_equal(4, rbtree.size)
    assert_equal("A", rbtree["a"])
    assert_equal("B", rbtree["b"])
    assert_equal("C", rbtree["c"])
    assert_equal("D", rbtree["d"])
    
    rbtree = RBTree[[%w(a A), %w(b B), %w(c C), %w(d D)]];
    assert_equal(4, rbtree.size)
    assert_equal("A", rbtree["a"])
    assert_equal("B", rbtree["b"])
    assert_equal("C", rbtree["c"])
    assert_equal("D", rbtree["d"])
    
    # assert_raises(ArgumentError) { RBTree[["a"]] }
    
    rbtree = RBTree[[["a"]]]
    assert_equal(1, rbtree.size)
    assert_equal(nil, rbtree["a"])
    
    # assert_raises(ArgumentError) { RBTree[[["a", "A", "b", "B"]]] }
  end
  
  def test_clear
    @rbtree.clear
    assert_equal(0, @rbtree.size)
  end
  
  def test_aset
    @rbtree["e"] = "E"
    assert_equal(5, @rbtree.size)
    assert_equal("E", @rbtree["e"])
    
    @rbtree["c"] = "E"
    assert_equal(5, @rbtree.size)
    assert_equal("E", @rbtree["c"])
    
    assert_raises(ArgumentError) { @rbtree[100] = 100 }
    assert_equal(5, @rbtree.size)
    
    
    key = "f"
    @rbtree[key] = "F"
    cloned_key = @rbtree.last[0]
    assert_equal("f", cloned_key)
    assert_not_same(key, cloned_key)
    assert_equal(true, cloned_key.frozen?)
    
    @rbtree["f"] = "F"
    assert_same(cloned_key, @rbtree.last[0])

    rbtree = RBTree.new
    key = ["g"]
    rbtree[key] = "G"
    assert_same(key, rbtree.first[0])
    assert_equal(false, key.frozen?)
  end
  
  def test_clone
    clone = @rbtree.clone
    assert_equal(4, @rbtree.size)
    assert_equal("A", @rbtree["a"])
    assert_equal("B", @rbtree["b"])
    assert_equal("C", @rbtree["c"])
    assert_equal("D", @rbtree["d"])
    
    rbtree = RBTree.new("e")
    clone = rbtree.clone
    assert_equal("e", clone.default)
    
    rbtree = RBTree.new { "e" }
    clone = rbtree.clone
    assert_equal("e", clone.default(nil))
    
    rbtree = RBTree.new
    rbtree.readjust {|a, b| a <=> b }
    clone = rbtree.clone
    assert_equal(rbtree.cmp_proc, clone.cmp_proc)
  end
  
  def test_default
    rbtree = RBTree.new("e")
    assert_equal("e", rbtree.default)
    assert_equal("e", rbtree.default("f"))
    assert_raises(ArgumentError) { rbtree.default("e", "f") }
    
    rbtree = RBTree.new {|tree, key| @rbtree[key || "c"] }
    assert_equal(nil, rbtree.default)
    assert_equal("C", rbtree.default(nil))
    assert_equal("B", rbtree.default("b"))
  end
  
  def test_set_default
    rbtree = RBTree.new { "e" }
    rbtree.default = "f"
    assert_equal("f", rbtree.default)
    assert_equal(nil, rbtree.default_proc)
    
    rbtree = RBTree.new { "e" }
    rbtree.default = nil
    assert_equal(nil, rbtree.default)
    assert_equal(nil, rbtree.default_proc)
  end
  
  def test_default_proc
    rbtree = RBTree.new("e")
    assert_equal(nil, rbtree.default_proc)
    
    rbtree = RBTree.new { "f" }
    assert_equal("f", rbtree.default_proc.call)
  end
  
  def test_set_default_proc
    rbtree = RBTree.new("e")
    rbtree.default_proc = Proc.new { "f" }
    assert_equal(nil, rbtree.default)
    assert_equal("f", rbtree.default_proc.call)
    
    rbtree = RBTree.new("e")
    rbtree.default_proc = nil
    assert_equal(nil, rbtree.default)
    assert_equal(nil, rbtree.default_proc)
    
    if Symbol.method_defined?(:to_proc)
      @rbtree.default_proc = :upper_bound
      assert_equal(%w(d D), @rbtree["e"])
    end
    
    assert_raises(TypeError) { rbtree.default_proc = "f" }
    
    if RUBY_VERSION >= "1.9.2"
      assert_nothing_raised {
        @rbtree.default_proc = lambda {|a, b|}
        @rbtree.default_proc = lambda {|*a|}
        @rbtree.default_proc = lambda {|a, *b|}
        @rbtree.default_proc = lambda {|a, b, *c|}
      }
      assert_raises(TypeError) { @rbtree.default_proc = lambda {|a|} }
      assert_raises(TypeError) { @rbtree.default_proc = lambda {|a, b, c|} }
      assert_raises(TypeError) { @rbtree.default_proc = lambda {|a, b, c, *d|} }
    end
  end
  
  def test_equal
    assert_equal(RBTree.new, RBTree.new)
    assert_equal(@rbtree, @rbtree)
    assert_not_equal(@rbtree, RBTree.new)
    
    rbtree = RBTree[*%w(b B d D a A c C)]
    assert_equal(@rbtree, rbtree)
    rbtree["d"] = "A"
    assert_not_equal(@rbtree, rbtree)
    rbtree["d"] = "D"
    rbtree["e"] = "E"
    assert_not_equal(@rbtree, rbtree)
    @rbtree["e"] = "E"
    assert_equal(@rbtree, rbtree)
    
    rbtree.default = "e"
    assert_equal(@rbtree, rbtree)
    @rbtree.default = "f"
    assert_equal(@rbtree, rbtree)
    
    a = RBTree.new("e")
    b = RBTree.new { "f" }
    assert_equal(a, b)
    assert_equal(b, b.clone)
    
    a = RBTree.new
    b = RBTree.new
    a.readjust {|x, y| x <=> y }
    assert_not_equal(a, b)
    b.readjust(a.cmp_proc)
    assert_equal(a, b)
    
    if RUBY_VERSION >= "1.8.7"
      a = RBTree.new
      a[1] = a
      b = RBTree.new
      b[1] = b
      assert_equal(a, b)
    end
  end
  
  def test_fetch
    assert_equal("A", @rbtree.fetch("a"))
    assert_equal("B", @rbtree.fetch("b"))
    assert_equal("C", @rbtree.fetch("c"))
    assert_equal("D", @rbtree.fetch("d"))
    
    assert_raises(IndexError) { @rbtree.fetch("e") }
    
    assert_equal("E", @rbtree.fetch("e", "E"))
    assert_equal("E", @rbtree.fetch("e") { "E" })
    # assert_equal("E", @rbtree.fetch("e", "F") { "E" })
    
    assert_raises(ArgumentError) { @rbtree.fetch }
    assert_raises(ArgumentError) { @rbtree.fetch("e", "E", "E") }
  end

  def test_key
    assert_equal("a", @rbtree.key("A"))
    assert_equal(nil, @rbtree.key("E"))
  end

  def test_empty_p
    assert_equal(false, @rbtree.empty?)
    @rbtree.clear
    assert_equal(true, @rbtree.empty?)
  end
  
  def test_each
    result = []
    @rbtree.each {|key, val| result << key << val }
    assert_equal(%w(a A b B c C d D), result)
    
    assert_raises(TypeError) {
      @rbtree.each { @rbtree["e"] = "E" }
    }
    assert_equal(4, @rbtree.size)
    
    @rbtree.each {
      @rbtree.each {}
      assert_raises(TypeError) {
        @rbtree["e"] = "E"
      }
      break
    }
    assert_equal(4, @rbtree.size)
    
    if have_enumerator?
      enumerator = @rbtree.each
      assert_equal(%w(a A b B c C d D), enumerator.to_a.flatten)
    end
  end
  
  def test_each_key
    result = []
    @rbtree.each_key {|key| result.push(key) }
    assert_equal(%w(a b c d), result)

    assert_raises(TypeError) {
      @rbtree.each_key { @rbtree["e"] = "E" }
    }
    assert_equal(4, @rbtree.size)

    @rbtree.each_key {
      @rbtree.each_key {}
      assert_raises(TypeError) {
        @rbtree["e"] = "E"
      }
      break
    }
    assert_equal(4, @rbtree.size)
    
    if have_enumerator?
      enumerator = @rbtree.each_key
      assert_equal(%w(a b c d), enumerator.to_a.flatten)
    end
  end
  
  def test_each_value
    result = []
    @rbtree.each_value {|val| result.push(val) }
    assert_equal(%w(A B C D), result)

    assert_raises(TypeError) {
      @rbtree.each_value { @rbtree["e"] = "E" }
    }
    assert_equal(4, @rbtree.size)

    @rbtree.each_value {
      @rbtree.each_value {}
      assert_raises(TypeError) {
        @rbtree["e"] = "E"
      }
      break
    }
    assert_equal(4, @rbtree.size)
    
    if have_enumerator?
      enumerator = @rbtree.each_value
      assert_equal(%w(A B C D), enumerator.to_a.flatten)
    end
  end

  def test_shift
    result = @rbtree.shift
    assert_equal(3, @rbtree.size)
    assert_equal(%w(a A), result)
    assert_equal(nil, @rbtree["a"])
    
    3.times { @rbtree.shift }
    assert_equal(0, @rbtree.size)
    assert_equal(nil, @rbtree.shift)
    @rbtree.default = "e"
    assert_equal("e", @rbtree.shift)
    
    rbtree = RBTree.new { "e" }
    assert_equal("e", rbtree.shift)
  end
  
  def test_pop
    result = @rbtree.pop
    assert_equal(3, @rbtree.size)
    assert_equal(%w(d D), result)
    assert_equal(nil, @rbtree["d"])
    
    3.times { @rbtree.pop }
    assert_equal(0, @rbtree.size)
    assert_equal(nil, @rbtree.pop)
    @rbtree.default = "e"
    assert_equal("e", @rbtree.pop)
    
    rbtree = RBTree.new { "e" }
    assert_equal("e", rbtree.pop)
  end
  
  def test_delete
    result = @rbtree.delete("c")
    assert_equal("C", result)
    assert_equal(3, @rbtree.size)
    assert_equal(nil, @rbtree["c"])
    
    assert_equal(nil, @rbtree.delete("e"))
    assert_equal("E", @rbtree.delete("e") { "E" })
  end
  
  def test_delete_if
    result = @rbtree.delete_if {|key, val| val == "A" || val == "B" }
    assert_same(@rbtree, result)
    assert_equal(RBTree[*%w(c C d D)], @rbtree)
    
    assert_raises(ArgumentError) {
      @rbtree.delete_if {|key, val| key == "c" or raise ArgumentError }
    }
    assert_equal(2, @rbtree.size)
    
    assert_raises(TypeError) {
      @rbtree.delete_if { @rbtree["e"] = "E" }
    }
    assert_equal(2, @rbtree.size)

    @rbtree.delete_if {
      @rbtree.each {
        assert_equal(2, @rbtree.size)
      }
      assert_raises(TypeError) {
        @rbtree["e"] = "E"
      }
      true
    }
    assert_equal(0, @rbtree.size)
    
    if have_enumerator?
      rbtree = RBTree[*%w(b B d D a A c C)]
      rbtree.delete_if.with_index {|(key, val), i| i < 2 }
      assert_equal(RBTree[*%w(c C d D)], rbtree)
    end
  end

  def test_keep_if
    result = @rbtree.keep_if {|key, val| val == "A" || val == "B" }
    assert_same(@rbtree, result)
    assert_equal(RBTree[*%w(a A b B)], @rbtree)
    
    if have_enumerator?
      rbtree = RBTree[*%w(b B d D a A c C)]
      rbtree.keep_if.with_index {|(key, val), i| i < 2 }
      assert_equal(RBTree[*%w(a A b B)], rbtree)
    end
  end

  def test_reject_bang
    result = @rbtree.reject! { false }
    assert_equal(nil, result)
    assert_equal(4, @rbtree.size)
    
    result = @rbtree.reject! {|key, val| val == "A" || val == "B" }
    assert_same(@rbtree, result)
    assert_equal(RBTree[*%w(c C d D)], result)
    
    if have_enumerator?
      rbtree = RBTree[*%w(b B d D a A c C)]
      rbtree.reject!.with_index {|(key, val), i| i < 2 }
      assert_equal(RBTree[*%w(c C d D)], rbtree)
    end
  end
  
  def test_reject
    result = @rbtree.reject { false }
    assert_equal(RBTree[*%w(a A b B c C d D)], result)
    assert_equal(4, @rbtree.size)
    
    result = @rbtree.reject {|key, val| val == "A" || val == "B" }
    assert_equal(RBTree[*%w(c C d D)], result)
    assert_equal(4, @rbtree.size)
    
    if have_enumerator?
      result = @rbtree.reject.with_index {|(key, val), i| i < 2 }
      assert_equal(RBTree[*%w(c C d D)], result)
    end
  end

  def test_select_bang
    result = @rbtree.select! { true }
    assert_equal(nil, result)
    assert_equal(4, @rbtree.size)
    
    result = @rbtree.select! {|key, val| val == "A" || val == "B" }
    assert_same(@rbtree, result)
    assert_equal(RBTree[*%w(a A b B)], result)
    
    if have_enumerator?
      rbtree = RBTree[*%w(b B d D a A c C)]
      rbtree.select!.with_index {|(key, val), i| i < 2 }
      assert_equal(RBTree[*%w(a A b B)], rbtree)
    end
  end

  def test_select
    result = @rbtree.select { true }
    assert_equal(RBTree[*%w(a A b B c C d D)], result)
    assert_equal(4, @rbtree.size)
    
    result = @rbtree.select {|key, val| val == "A" || val == "B" }
    assert_equal(RBTree[*%w(a A b B)], result)
    assert_raises(ArgumentError) { @rbtree.select("c") }
    
    if have_enumerator?
      result = @rbtree.select.with_index {|(key, val), i| i < 2 }
      assert_equal(RBTree[*%w(a A b B)], result)
    end
  end

  def test_values_at
    result = @rbtree.values_at("d", "a", "e")
    assert_equal(["D", "A", nil], result)
  end
  
  def test_invert
    assert_equal(RBTree[*%w(A a B b C c D d)], @rbtree.invert)
  end
  
  def test_update
    rbtree = RBTree.new
    rbtree["e"] = "E"
    @rbtree.update(rbtree)
    assert_equal(RBTree[*%w(a A b B c C d D e E)], @rbtree)
    
    @rbtree.clear
    @rbtree["d"] = "A"
    rbtree.clear
    rbtree["d"] = "B"
    
    @rbtree.update(rbtree) {|key, val1, val2|
      val1 + val2 if key == "d"
    }
    assert_equal(RBTree[*%w(d AB)], @rbtree)
    
    assert_raises(TypeError) { @rbtree.update("e") }
  end
  
  def test_merge
    rbtree = RBTree.new
    rbtree["e"] = "E"
    
    result = @rbtree.merge(rbtree)
    assert_equal(RBTree[*%w(a A b B c C d D e E)], result)
    
    assert_equal(4, @rbtree.size)
  end

  if MultiRBTree.method_defined?(:flatten)
    def test_flatten
      rbtree = RBTree.new
      rbtree.readjust {|a, b| a.flatten <=> b.flatten }
      rbtree[["a"]] = ["A"]
      rbtree[[["b"]]] = [["B"]]
      assert_equal([["a"], ["A"], [["b"]], [["B"]]], rbtree.flatten)
      assert_equal([["a"], ["A"], [["b"]], [["B"]]], rbtree.flatten(0))
      assert_equal([["a"], ["A"], [["b"]], [["B"]]], rbtree.flatten(1))
      assert_equal(["a", "A", ["b"], ["B"]], rbtree.flatten(2))
      assert_equal(["a", "A", "b", "B"], rbtree.flatten(3))
      
      assert_raises(TypeError) { @rbtree.flatten("e") }
      assert_raises(ArgumentError) { @rbtree.flatten(1, 2) } 
    end
  end

  def test_has_key
    assert_equal(true,  @rbtree.has_key?("a"))
    assert_equal(true,  @rbtree.has_key?("b"))
    assert_equal(true,  @rbtree.has_key?("c"))
    assert_equal(true,  @rbtree.has_key?("d"))
    assert_equal(false, @rbtree.has_key?("e"))
  end
  
  def test_has_value
    assert_equal(true,  @rbtree.has_value?("A"))
    assert_equal(true,  @rbtree.has_value?("B"))
    assert_equal(true,  @rbtree.has_value?("C"))
    assert_equal(true,  @rbtree.has_value?("D"))
    assert_equal(false, @rbtree.has_value?("E"))
  end

  def test_keys
    assert_equal(%w(a b c d), @rbtree.keys)
  end

  def test_values
    assert_equal(%w(A B C D), @rbtree.values)
  end

  def test_to_a
    assert_equal([%w(a A), %w(b B), %w(c C), %w(d D)], @rbtree.to_a)
  end

  def test_to_hash
    @rbtree.default = "e"
    hash = @rbtree.to_hash
    assert_equal(@rbtree.to_a.flatten, hash.sort_by {|key, val| key}.flatten)
    assert_equal("e", hash.default)

    rbtree = RBTree.new { "e" }
    hash = rbtree.to_hash
    if (hash.respond_to?(:default_proc))
      assert_equal(rbtree.default_proc, hash.default_proc)
    else
      assert_equal(rbtree.default_proc, hash.default)
    end
  end

  def test_to_rbtree
    assert_same(@rbtree, @rbtree.to_rbtree)
  end
  
  def test_inspect
    [:to_s, :inspect].each do |method|
      @rbtree.default = "e"
      @rbtree.readjust {|a, b| a <=> b}
      re = /#<RBTree: (\{.*\}), default=(.*), cmp_proc=(.*)>/
      
      assert_match(re, @rbtree.send(method))
      match = re.match(@rbtree.send(method))
      tree, default, cmp_proc = match.to_a[1..-1]
      assert_equal(%({"a"=>"A", "b"=>"B", "c"=>"C", "d"=>"D"}), tree)
      assert_equal(%("e"), default)
      assert_match(/#<Proc:\w+(@#{__FILE__}:\d+)?>/o, cmp_proc)
      
      rbtree = RBTree.new
      assert_match(re, rbtree.send(method))
      match = re.match(rbtree.send(method))
      tree, default, cmp_proc = match.to_a[1..-1]
      assert_equal("{}", tree)
      assert_equal("nil", default)
      assert_equal("nil", cmp_proc)
      
      next if method == :to_s and RUBY_VERSION < "1.9"
      
      rbtree = RBTree.new
      rbtree[rbtree] = rbtree
      rbtree.default = rbtree
      match = re.match(rbtree.send(method))
      tree, default, cmp_proc =  match.to_a[1..-1]
      assert_equal("{#<RBTree: ...>=>#<RBTree: ...>}", tree)
      assert_equal("#<RBTree: ...>", default)
      assert_equal("nil", cmp_proc)
    end
  end
  
  def test_lower_bound
    rbtree = RBTree[*%w(a A c C e E)]
    assert_equal(%w(c C), rbtree.lower_bound("c"))
    assert_equal(%w(c C), rbtree.lower_bound("b"))
    assert_equal(nil, rbtree.lower_bound("f"))
  end
  
  def test_upper_bound
    rbtree = RBTree[*%w(a A c C e E)]
    assert_equal(%w(c C), rbtree.upper_bound("c"))
    assert_equal(%w(c C), rbtree.upper_bound("d"))
    assert_equal(nil, rbtree.upper_bound("Z"))
  end
  
  def test_bound
    rbtree = RBTree[*%w(a A c C e E)]
    assert_equal(%w(a A c C), rbtree.bound("a", "c").to_a.flatten)
    assert_equal(%w(a A),     rbtree.bound("a").to_a.flatten)
    assert_equal(%w(c C e E), rbtree.bound("b", "f").to_a.flatten)

    assert_equal([], rbtree.bound("b", "b").to_a)
    assert_equal([], rbtree.bound("Y", "Z").to_a)
    assert_equal([], rbtree.bound("f", "g").to_a)
    assert_equal([], rbtree.bound("f", "Z").to_a)
    
    if defined?(Enumerator) and Enumerator.method_defined?(:size)
      assert_equal(2, rbtree.bound("a", "c").size)
      assert_equal(1, rbtree.bound("a").size)
      assert_equal(2, rbtree.bound("b", "f").size)
      
      assert_equal(0, rbtree.bound("b", "b").size)
      assert_equal(0, rbtree.bound("Y", "Z").size)
      assert_equal(0, rbtree.bound("f", "g").size)
      assert_equal(0, rbtree.bound("f", "Z").size)
    end
  end
  
  def test_bound_block
    result = []
    @rbtree.bound("b", "c") {|key, val|
      result.push(key)
    }
    assert_equal(%w(b c), result)
    
    assert_raises(TypeError) {
      @rbtree.bound("a", "d") {
        @rbtree["e"] = "E"
      }
    }
    assert_equal(4, @rbtree.size)
    
    @rbtree.bound("b", "c") {
      @rbtree.bound("b", "c") {}
      assert_raises(TypeError) {
        @rbtree["e"] = "E"
      }
      break
    }
    assert_equal(4, @rbtree.size)
  end
  
  def test_first
    assert_equal(%w(a A), @rbtree.first)
    
    rbtree = RBTree.new("e")
    assert_equal("e", rbtree.first)

    rbtree = RBTree.new { "e" }
    assert_equal("e", rbtree.first)
  end

  def test_last
    assert_equal(%w(d D), @rbtree.last)
    
    rbtree = RBTree.new("e")
    assert_equal("e", rbtree.last)

    rbtree = RBTree.new { "e" }
    assert_equal("e", rbtree.last)
  end

  def test_readjust
    assert_equal(nil, @rbtree.cmp_proc)
    
    @rbtree.readjust {|a, b| b <=> a }
    assert_equal(%w(d c b a), @rbtree.keys)
    assert_not_equal(nil, @rbtree.cmp_proc)
    
    proc = Proc.new {|a,b| a.to_s <=> b.to_s }
    @rbtree.readjust(proc)
    assert_equal(%w(a b c d), @rbtree.keys)
    assert_equal(proc, @rbtree.cmp_proc)
    
    @rbtree[0] = nil
    assert_raises(ArgumentError) { @rbtree.readjust(nil) }
    assert_equal(5, @rbtree.size)
    assert_equal(proc, @rbtree.cmp_proc)
    
    @rbtree.delete(0)
    @rbtree.readjust(nil)
    assert_raises(ArgumentError) { @rbtree[0] = nil }
    
    if Symbol.method_defined?(:to_proc)
      rbtree = RBTree[*%w(a A B b)]
      assert_equal(%w(B b a A), rbtree.to_a.flatten)
      rbtree.readjust(:casecmp)
      assert_equal(%w(a A B b), rbtree.to_a.flatten)
    end
    
    if RUBY_VERSION >= "1.9.2"
      assert_nothing_raised {
        @rbtree.readjust(lambda {|a, b| a <=> b })
        @rbtree.readjust(lambda {|*a| a[0] <=> a[1] })
        @rbtree.readjust(lambda {|a, *b| a <=> b[0] })
        @rbtree.readjust(lambda {|a, b, *c| a <=> b })
        @rbtree.readjust(&lambda {|a, b| a <=> b })
        @rbtree.readjust(&lambda {|*a| a[0] <=> a[1] })
        @rbtree.readjust(&lambda {|a, *b| a <=> b[0] })
        @rbtree.readjust(&lambda {|a, b, *c| a <=> b })
      }
      assert_raises(TypeError) { @rbtree.readjust(lambda {|a| 1 }) }
      assert_raises(TypeError) { @rbtree.readjust(lambda {|a, b, c| 1 }) }
      assert_raises(TypeError) { @rbtree.readjust(lambda {|a, b, c, *d| 1 }) }
      assert_raises(TypeError) { @rbtree.readjust(&lambda {|a| 1 }) }
      assert_raises(TypeError) { @rbtree.readjust(&lambda {|a, b, c| 1 }) }
      assert_raises(TypeError) { @rbtree.readjust(&lambda {|a, b, c, *d| 1 }) }
    end


    rbtree = RBTree.new
    key = ["a"]
    rbtree[key] = nil
    rbtree[["e"]] = nil
    key[0] = "f"

    assert_equal([["f"], ["e"]], rbtree.keys)
    rbtree.readjust
    assert_equal([["e"], ["f"]], rbtree.keys)

    assert_raises(TypeError) { @rbtree.readjust("e") }
    assert_raises(ArgumentError) {
      @rbtree.readjust(proc) {|a,b| a <=> b }
    }
    assert_raises(ArgumentError) { @rbtree.readjust(proc, proc) }


    rbtree = RBTree[("a".."z").to_a.zip(("A".."Z").to_a)]
    assert_nothing_raised do
      rbtree.readjust do |a, b|
        ObjectSpace.each_object(RBTree) do |temp|
          temp.clear if temp.size == rbtree.size - 1
        end
        a <=> b
      end
    end
  end
  
  def test_replace
    rbtree = RBTree.new { "e" }
    rbtree.readjust {|a, b| a <=> b}
    rbtree["a"] = "A"
    rbtree["e"] = "E"
    
    @rbtree.replace(rbtree)
    assert_equal(%w(a A e E), @rbtree.to_a.flatten)
    assert_equal(rbtree.default, @rbtree.default)    
    assert_equal(rbtree.cmp_proc, @rbtree.cmp_proc)

    assert_raises(TypeError) { @rbtree.replace("e") }
  end
  
  def test_reverse_each
    result = []
    @rbtree.reverse_each { |key, val| result.push([key, val]) }
    assert_equal(%w(d D c C b B a A), result.flatten)
    
    if have_enumerator?
      enumerator = @rbtree.reverse_each
      assert_equal(%w(d D c C b B a A), enumerator.to_a.flatten)
    end
  end
  
  def test_marshal
    assert_equal(@rbtree, Marshal.load(Marshal.dump(@rbtree)))
    
    @rbtree.default = "e"
    assert_equal(@rbtree, Marshal.load(Marshal.dump(@rbtree)))
    
    assert_raises(TypeError) {
      Marshal.dump(RBTree.new { "e" })
    }
    
    assert_raises(TypeError) {
      @rbtree.readjust {|a, b| a <=> b}
      Marshal.dump(@rbtree)
    }
  end

  def test_modify_in_cmp_proc
    can_clear = false
    @rbtree.readjust do |a, b|
      @rbtree.clear if can_clear
      a <=> b
    end
    can_clear = true
    assert_raises(TypeError) { @rbtree["e"] }
  end
  
  begin
    require "pp"
    
    def test_pp
      assert_equal(%(#<RBTree: {}, default=nil, cmp_proc=nil>\n),
                   PP.pp(RBTree.new, ""))
      assert_equal(%(#<RBTree: {"a"=>"A", "b"=>"B"}, default=nil, cmp_proc=nil>\n),
                   PP.pp(RBTree[*%w(a A b B)], ""))
      
      rbtree = RBTree[*("a".."z").to_a]
      rbtree.default = "a"
      rbtree.readjust {|a, b| a <=> b }
      expected = <<EOS
#<RBTree: {"a"=>"b",
  "c"=>"d",
  "e"=>"f",
  "g"=>"h",
  "i"=>"j",
  "k"=>"l",
  "m"=>"n",
  "o"=>"p",
  "q"=>"r",
  "s"=>"t",
  "u"=>"v",
  "w"=>"x",
  "y"=>"z"},
 default="a",
 cmp_proc=#{rbtree.cmp_proc}>
EOS
      assert_equal(expected, PP.pp(rbtree, ""))

      rbtree = RBTree.new
      rbtree[rbtree] = rbtree
      rbtree.default = rbtree
      expected = <<EOS
#<RBTree: {"#<RBTree: ...>"=>"#<RBTree: ...>"},
 default="#<RBTree: ...>",
 cmp_proc=nil>
EOS
      assert_equal(expected, PP.pp(rbtree, ""))
    end
  rescue LoadError
  end
end


class MultiRBTreeTest < Test::Unit::TestCase
  def setup
    @rbtree = MultiRBTree[*%w(a A b B b C b D c C)]
  end

  def test_create
    assert_equal(%w(a A b B b C b D c C), @rbtree.to_a.flatten)
    
    assert_equal(MultiRBTree[*%w(a A)], MultiRBTree[RBTree[*%w(a A)]])
    assert_raises(TypeError) {
      RBTree[MultiRBTree[*%w(a A)]]
    }
  end

  def test_size
    assert_equal(5, @rbtree.size)
  end

  def test_clear
    @rbtree.clear
    assert_equal(0, @rbtree.size)
  end

  def test_empty
    assert_equal(false, @rbtree.empty?)
    @rbtree.clear
    assert_equal(true, @rbtree.empty?)
  end
  
  def test_to_a
    assert_equal([%w(a A), %w(b B), %w(b C), %w(b D), %w(c C)],
                 @rbtree.to_a)
  end
  
  def test_to_hash
    assert_raises(TypeError) {
      @rbtree.to_hash
    }
  end

  def test_to_rbtree
    assert_equal(@rbtree, @rbtree.to_rbtree)
  end

  def test_aref
    assert_equal("B", @rbtree["b"])
  end

  def test_aset
    @rbtree["b"] = "A"
    assert_equal("B", @rbtree["b"])
    assert_equal(%w(a A b B b C b D b A c C), @rbtree.to_a.flatten)
  end

  def test_equal
    assert_equal(true, MultiRBTree[*%w(a A b B b C b D c C)] == @rbtree)
    assert_equal(true, RBTree[*%w(a A)] == MultiRBTree[*%w(a A)])
    assert_equal(true, MultiRBTree[*%w(a A)] == RBTree[*%w(a A)])
  end
  
  def test_replace
    assert_equal(RBTree[*%w(a A)],
                 MultiRBTree[*%w(a A)].replace(RBTree[*%w(a A)]))
    assert_raises(TypeError) {
      RBTree[*%w(a A)].replace(MultiRBTree[*%w(a A)])
    }
  end

  def test_update
    assert_equal(MultiRBTree[*%w(a A b B)],
                 MultiRBTree[*%w(a A)].update(RBTree[*%w(b B)]))
    assert_raises(TypeError) {
      RBTree[*%w(a A)].update(MultiRBTree[*%w(b B)])
    }
  end

  def test_clone
    assert_equal(@rbtree, @rbtree.clone)
  end
  
  def test_each
    result = []
    @rbtree.each {|k, v|
      result << k << v
    }
    assert_equal(%w(a A b B b C b D c C), result)
  end

  def test_delete
    @rbtree.delete("b")
    assert_equal(4, @rbtree.size)
    assert_equal(%w(a A b C b D c C), @rbtree.to_a.flatten)

    @rbtree.delete("b")
    assert_equal(3, @rbtree.size)
    assert_equal(%w(a A b D c C), @rbtree.to_a.flatten)

    @rbtree.delete("b")
    assert_equal(2, @rbtree.size)
    assert_equal(%w(a A c C), @rbtree.to_a.flatten)
  end

  def test_delete_if
    @rbtree.delete_if {|k, v| k == "b" }
    assert_equal(%w(a A c C), @rbtree.to_a.flatten)
  end

  def test_keep_if
    @rbtree.keep_if {|k, v| k != "b" }
    assert_equal(%w(a A c C), @rbtree.to_a.flatten)
  end

  if MultiRBTree.method_defined?(:flatten)
    def test_flatten
      assert_equal(%w(a A b B b C b D c C), @rbtree.flatten)
    end
  end

  def test_inspect
    assert_equal(%(#<MultiRBTree: {"a"=>"A", "b"=>"B", "b"=>"C", "b"=>"D", "c"=>"C"}, default=nil, cmp_proc=nil>),
                 @rbtree.inspect)
  end

  def test_readjust
    @rbtree.readjust {|a, b| b <=> a }
    assert_equal(%w(c C b B b C b D a A), @rbtree.to_a.flatten)
  end
  
  def test_marshal
    assert_equal(@rbtree, Marshal.load(Marshal.dump(@rbtree)))
  end

  def test_lower_bound
    assert_equal(%w(b B), @rbtree.lower_bound("b"))
  end

  def test_upper_bound
    assert_equal(%w(b D), @rbtree.upper_bound("b"))
  end

  def test_bound
    assert_equal(%w(b B b C b D), @rbtree.bound("b").to_a.flatten)
  end
  
  def test_first
    assert_equal(%w(a A), @rbtree.first)
  end

  def test_last
    assert_equal(%w(c C), @rbtree.last)
  end

  def test_shift
    assert_equal(%w(a A), @rbtree.shift)
    assert_equal(4, @rbtree.size)
    assert_equal(nil, @rbtree["a"])
  end

  def test_pop
    assert_equal(%w(c C), @rbtree.pop)
    assert_equal(4, @rbtree.size)
    assert_equal(nil, @rbtree["c"])
  end

  def test_has_key
    assert_equal(true,  @rbtree.has_key?("b"))
  end

  def test_has_value
    assert_equal(true, @rbtree.has_value?("B"))
    assert_equal(true, @rbtree.has_value?("C"))
    assert_equal(true, @rbtree.has_value?("D"))
  end

  def test_values_at
    assert_equal(%w(A B), @rbtree.values_at("a", "b"))
  end

  def test_invert
    assert_equal(MultiRBTree[*%w(A a B b C b C c D b)], @rbtree.invert)
  end

  def test_keys
    assert_equal(%w(a b b b c), @rbtree.keys)
  end

  def test_values
    assert_equal(%w(A B C D C), @rbtree.values)
  end

  def test_key
    assert_equal("b", @rbtree.key("B"))
    assert_equal("b", @rbtree.key("C"))
    assert_equal("b", @rbtree.key("D"))
  end
end
