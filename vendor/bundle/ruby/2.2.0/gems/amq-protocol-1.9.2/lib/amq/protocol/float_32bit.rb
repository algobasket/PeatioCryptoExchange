module AMQ
  module Protocol
    # Allows distinguishing between 32-bit and 64-bit floats in Ruby.
    # Useful in cases when RabbitMQ plugins encode
    # values as 32 bit numbers.
    class Float32Bit
      attr_reader :value

      def initialize(value)
        @value = value
      end
    end
  end
end
