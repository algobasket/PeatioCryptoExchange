if __FILE__== $0
  require '../test_helper'
else
  require 'test_helper'
end

class SpansTest < ActionView::TestCase
  include EasyTable::Components::Spans

  setup do
    @node = Tree::TreeNode.new('root')
  end

  should "create a Span given title, a hash and a block" do
    span('title', class: 'klazz') { |s| }
    s =  node.children.first.content
    assert_equal 'title', s.instance_variable_get(:@title)
  end

  should "create a Span given title, label, a hash and a block" do
    span('title', 'label', class: 'klazz') { |s| }
    s =  node.children.first.content
    assert_equal 'title', s.instance_variable_get(:@title)
  end

  should "create a Span given a hash and a block" do
    span(class: 'klazz') { |s| }
    s =  node.children.first.content
    assert_nil s.instance_variable_get(:@title)
  end

  should "create a Span fiven only a block" do
    span { |s| }
    s =  node.children.first.content
    assert_nil s.instance_variable_get(:@title)
  end


end