module EasyTable
  module Components
    module Spans
      def span(*args, &block)
        opts = options_from_hash(args)
        title, label = *args
        child = node << Tree::TreeNode.new(title || generate_node_name)
        span = Span.new(child, title, label, opts, @template, block)
        child.content = span
      end

      private

      def node
        @node
      end

      def options_from_hash(args)
        args.last.is_a?(Hash) ? args.pop : {}
      end

      def generate_node_name
        "#{node.name}-span-#{node.size}"
      end
    end
  end
end