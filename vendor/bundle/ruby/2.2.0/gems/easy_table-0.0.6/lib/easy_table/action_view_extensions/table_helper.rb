module EasyTable
  module ActionViewExtensions
    module TableHelper
      def table_for(collection, options = {}, &block)
        t = EasyTable::TableBuilder.new(collection, self, options)
        block.yield(t) if block_given?
        t.build
      end
    end

  end
end

ActionView::Base.send :include, EasyTable::ActionViewExtensions::TableHelper