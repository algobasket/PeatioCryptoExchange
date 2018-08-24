module EasyTable
  module Components
    module Columns
      def column(title, label_or_opts = nil, opts = {}, &block)
        if label_or_opts.is_a?(Hash) && label_or_opts.extractable_options?
          label, opts = nil, label_or_opts
        else
          label, opts = label_or_opts, opts
        end
        child = node << Tree::TreeNode.new(title)
        column = Column.new(child, title, label, opts, @template, block)
        child.content = column
      end

      private

      def node
        @node
      end
    end
  end
end