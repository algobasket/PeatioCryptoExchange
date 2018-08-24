module AMQ
  module Protocol
    class Error < StandardError
      DEFAULT_MESSAGE = "AMQP error".freeze

      def self.inherited(subclass)
        @_subclasses ||= []
        @_subclasses << subclass
      end # self.inherited(subclazz)

      def self.subclasses_with_values
        @_subclasses.select{ |k| defined?(k::VALUE) }
      end # self.subclasses_with_values

      def self.[](code)
        if result = subclasses_with_values.detect { |klass| klass::VALUE == code }
          result
        else
          raise "No such exception class for code #{code}" unless result
        end # if
      end # self.[]

      def initialize(message = self.class::DEFAULT_MESSAGE)
        super(message)
      end
    end

    class FrameTypeError < Protocol::Error
      def initialize(types)
        super("Must be one of #{types.inspect}")
      end
    end

    class EmptyResponseError < Protocol::Error
      DEFAULT_MESSAGE = "Empty response received from the server."

      def initialize(message = self.class::DEFAULT_MESSAGE)
        super(message)
      end
    end

    class BadResponseError < Protocol::Error
      def initialize(argument, expected, actual)
        super("Argument #{argument} has to be #{expected.inspect}, was #{data.inspect}")
      end
    end

    class SoftError < Protocol::Error
      def self.inherited(subclass)
        Error.inherited(subclass)
      end # self.inherited(subclass)
    end

    class HardError < Protocol::Error
      def self.inherited(subclass)
        Error.inherited(subclass)
      end # self.inherited(subclass)
    end
  end
end
