module Rack::Mount
  class Multimap #:nodoc:
    def initialize(default = [])
      @hash = Hash.new(default)
    end

    def initialize_copy(original)
      @hash = Hash.new(original.default.dup)
      original.hash.each_pair do |key, container|
        @hash[key] = container.dup
      end
    end

    def store(*args)
      keys  = args.dup
      value = keys.pop
      key   = keys.shift

      raise ArgumentError, 'wrong number of arguments (1 for 2)' unless value

      unless key.respond_to?(:=~)
        raise ArgumentError, "unsupported key: #{args.first.inspect}"
      end

      if key.is_a?(Regexp)
        if keys.empty?
          @hash.each_pair { |k, l| l << value if k =~ key }
          self.default << value
        else
          @hash.each_pair { |k, _|
            if k =~ key
              args[0] = k
              _store(*args)
            end
          }

          self.default = self.class.new(default) unless default.is_a?(self.class)
          default[*keys.dup] = value
        end
      else
        _store(*args)
      end
    end
    alias_method :[]=, :store

    def [](*keys)
      i, l, r, k = 0, keys.length, self, self.class
      while r.is_a?(k)
        r = i < l ? r.hash[keys[i]] : r.default
        i += 1
      end
      r
    end

    def height
      containers_with_default.max { |a, b| a.length <=> b.length }.length
    end

    def average_height
      lengths = containers_with_default.map { |e| e.length }
      lengths.inject(0) { |sum, len| sum += len }.to_f / lengths.size
    end

    def containers_with_default
      containers = []
      each_container_with_default { |container| containers << container }
      containers
    end

    protected
      def _store(*args)
        keys  = args
        value = args.pop

        raise ArgumentError, 'wrong number of arguments (1 for 2)' unless value

        if keys.length > 1
          update_container(keys.shift) do |container|
            container = self.class.new(container) unless container.is_a?(self.class)
            container[*keys] = value
            container
          end
        elsif keys.length == 1
          update_container(keys.first) do |container|
            container << value
            container
          end
        else
          self << value
        end
      end

      def <<(value)
        @hash.each_value { |container| container << value }
        self.default << value
        self
      end

      def each_container_with_default(&block)
        @hash.each_value do |container|
          iterate_over_container(container, &block)
        end
        iterate_over_container(default, &block)
        self
      end

      def default
        @hash.default
      end

      def default=(value)
        @hash.default = value
      end

      def hash
        @hash
      end

    private
      def update_container(key)
        container = @hash[key]
        container = container.dup if container.equal?(default)
        container = yield(container)
        @hash[key] = container
      end

      def iterate_over_container(container)
        if container.respond_to?(:each_container_with_default)
          container.each_container_with_default do |value|
            yield value
          end
        else
          yield container
        end
      end
  end
end
