module Paranoid2
  module Persistence
    extend ActiveSupport::Concern

    def destroy(opts = {})
      with_paranoid(opts) { super() }
    end

    def destroy!(opts = {})
      with_paranoid(opts) { super() }
    end

    def delete(opts = {})
      with_paranoid(opts) do
        touch(:deleted_at) if !deleted? && persisted?
        self.class.unscoped { super() } if paranoid_force
      end
    end

    def restore(opts={})
      return if !destroyed?

      attrs = timestamp_attributes_for_update_in_model
      current_time = current_time_from_proper_timezone
      changes = {}
      attrs.each do |column|
        changes[column.to_s] = write_attribute(column.to_s, current_time)
      end
      changes['deleted_at'] = write_attribute('deleted_at', nil)

      changes[self.class.locking_column] = increment_lock if locking_enabled?

      @changed_attributes.except!(*changes.keys)
      primary_key = self.class.primary_key
      self.class.unscoped.where({ primary_key => self[primary_key] }).update_all(changes)

      if opts.fetch(:associations) { true }
        restore_associations
      end
    end

    def restore_associations
      self.class.reflect_on_all_associations.each do |a|
        next unless a.klass.paranoid?

        if a.collection?
          send(a.name).restore_all
        else
          a.klass.unscoped { send(a.name).try(:restore) }
        end
      end
    end

    def destroyed?
      !deleted_at.nil?
    end

    def persisted?
      !new_record?
    end

    alias :deleted? :destroyed?

    def destroy_row
      if paranoid_force
        self.deleted_at = Time.now
        super
      else
        delete
        1
      end
    end

    module ClassMethods
      def paranoid? ; true ; end

      def destroy_all!(conditions = nil)
        with_paranoid(force: true) do
          destroy_all(conditions)
        end
      end

      def restore_all
        only_deleted.each &:restore
      end
    end
  end
end