module Paranoid2
  module Scoping
    extend ActiveSupport::Concern

    included do
      default_scope { paranoid_scope }
    end

    module ClassMethods

      def paranoid_scope
        where(deleted_at: nil)
      end

      def only_deleted
        with_deleted.where.not(deleted_at: nil)
      end

      def with_deleted
        all.tap { |s| s.default_scoped = false }
      end
    end    
  end
end