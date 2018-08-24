require 'rack/mount/utils'

module Rack::Mount
  module Analysis
    class Splitting
      NULL = "\0"

      class Key < Struct.new(:method, :index, :separators)
        def self.split(value, separator_pattern)
          keys = value.split(separator_pattern)
          keys.shift if keys[0] == ''
          keys << NULL
          keys
        end

        def call(cache, obj)
          (cache[method] ||= self.class.split(obj.send(method), separators))[index]
        end

        def call_source(cache, obj)
          "(#{cache}[:#{method}] ||= Analysis::Splitting::Key.split(#{obj}.#{method}, #{separators.inspect}))[#{index}]"
        end

        def inspect
          "#{method}[#{index}].split(#{separators.inspect})"
        end
      end

      def initialize(*keys)
        clear
        keys.each { |key| self << key }
      end

      def clear
        @raw_keys = []
        @key_frequency = Analysis::Histogram.new
        self
      end

      def <<(key)
        raise ArgumentError unless key.is_a?(Hash)
        @raw_keys << key
        nil
      end

      def possible_keys
        @possible_keys ||= begin
          @raw_keys.map do |key|
            key.inject({}) { |requirements, (method, requirement)|
              process_key(requirements, method, requirement)
              requirements
            }
          end
        end
      end

      def report
        @report ||= begin
          possible_keys.each { |keys| keys.each_pair { |key, _| @key_frequency << key } }
          return [] if @key_frequency.count <= 1
          @key_frequency.keys_in_upper_quartile
        end
      end

      def expire!
        @possible_keys = @report = nil
      end

      def process_key(requirements, method, requirement)
        separators = separators(method)
        if requirement.is_a?(Regexp) && separators.any?
          generate_split_keys(requirement, separators).each_with_index do |value, index|
            requirements[Key.new(method, index, Regexp.union(*separators))] = value
          end
        else
          if requirement.is_a?(Regexp)
            expression = Utils.parse_regexp(requirement)

            if expression.is_a?(Regin::Expression) && expression.anchored_to_line?
              expression = Regin::Expression.new(expression.reject { |e| e.is_a?(Regin::Anchor) })
              return requirements[method] = expression.to_s if expression.literal?
            end
          end

          requirements[method] = requirement
        end
      end

      private
        def separators(key)
          key == :path_info ? ["/", "."] : []
        end

        def generate_split_keys(regexp, separators) #:nodoc:
          segments = []
          buf = nil
          parts = Utils.parse_regexp(regexp)
          parts.each_with_index do |part, index|
            case part
            when Regin::Anchor
              if part.value == '$' || part.value == '\Z'
                segments << join_buffer(buf, regexp) if buf
                segments << NULL
                buf = nil
                break
              end
            when Regin::CharacterClass
              break if separators.any? { |s| part.include?(s) }
              buf = nil
              segments << part.to_regexp(true)
            when Regin::Character
              if separators.any? { |s| part.include?(s) }
                segments << join_buffer(buf, regexp) if buf
                peek = parts[index+1]
                if peek.is_a?(Regin::Character) && separators.include?(peek.value)
                  segments << ''
                end
                buf = nil
              else
                buf ||= Regin::Expression.new([])
                buf += [part]
              end
            when Regin::Group
              if part.quantifier == '?'
                value = part.expression.first
                if separators.any? { |s| value.include?(s) }
                  segments << join_buffer(buf, regexp) if buf
                  buf = nil
                end
                break
              elsif part.quantifier == nil
                break if separators.any? { |s| part.include?(s) }
                buf = nil
                segments << part.to_regexp(true)
              else
                break
              end
            else
              break
            end
          end

          while segments.length > 0 && (segments.last.nil? || segments.last == '')
            segments.pop
          end

          segments
        end

        def join_buffer(parts, regexp)
          if parts.literal?
            parts.to_s
          else
            parts.to_regexp(true)
          end
        end
    end
  end
end
