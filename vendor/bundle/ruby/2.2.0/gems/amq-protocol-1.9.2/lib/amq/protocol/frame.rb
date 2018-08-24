# encoding: binary

module AMQ
  module Protocol
    class Frame
      TYPES = {:method => 1, :headers => 2, :body => 3, :heartbeat => 8}.freeze
      TYPES_REVERSE = TYPES.invert.freeze
      TYPES_OPTIONS = TYPES.keys.freeze
      CHANNEL_RANGE = (0..65535).freeze
      FINAL_OCTET   = "\xCE".freeze # 206

      def self.encoded_payload(payload)
        if payload.respond_to?(:force_encoding) && payload.encoding.name != 'BINARY'
          # Only copy if we have to.
          payload = payload.dup.force_encoding('BINARY')
        end
        payload
      end

      # The channel number is 0 for all frames which are global to the connection and 1-65535 for frames that refer to specific channels.
      def self.encode_to_array(type, payload, channel)
        raise RuntimeError.new("Channel has to be 0 or an integer in range 1..65535 but was #{channel.inspect}") unless CHANNEL_RANGE.include?(channel)
        raise RuntimeError.new("Payload can't be nil") if payload.nil?
        components = []
        components << [find_type(type), channel, payload.bytesize].pack(PACK_CHAR_UINT16_UINT32)
        components << encoded_payload(payload)
        components << FINAL_OCTET
        components
      end

      def self.encode(type, payload, channel)
        encode_to_array(type, payload, channel).join
      end

      class << self
        alias_method :__new__, :new unless method_defined?(:__new__) # because of reloading
      end

      def self.new(original_type, *args)
        type_id = find_type(original_type)
        klass = CLASSES[type_id]
        klass.new(*args)
      end

      def self.find_type(type)
        type_id = if Symbol === type then TYPES[type] else type end
        raise FrameTypeError.new(TYPES_OPTIONS) if type == nil || !TYPES_REVERSE.has_key?(type_id)
        type_id
      end

      def self.decode(*)
        raise NotImplementedError.new <<-EOF
You are supposed to redefine this method, because it's dependent on used IO adapter.

This functionality is part of the https://github.com/ruby-amqp/amq-client library.
        EOF
      end

      def self.decode_header(header)
        raise EmptyResponseError if header == nil || header.empty?

        type_id, channel, size = header.unpack(PACK_CHAR_UINT16_UINT32)
        type = TYPES_REVERSE[type_id]
        raise FrameTypeError.new(TYPES_OPTIONS) unless type
        [type, channel, size]
      end

      def final?
        true
      end
    end

    class FrameSubclass < Frame
      # Restore original new
      class << self
        alias_method :new, :__new__
        undef_method :decode if method_defined?(:decode)
      end

      def self.id
        @id
      end

      def self.encode(payload, channel)
        super(@id, payload, channel)
      end

      attr_accessor :channel
      attr_reader :payload
      def initialize(payload, channel)
        @payload, @channel = payload, channel
      end

      def size
        @payload.bytesize
      end

      # TODO: remove once we are sure none of the clients
      #       uses this method directly
      # @api private
      def encode_to_array
        components = []
        components << [self.class.id, @channel, @payload.bytesize].pack(PACK_CHAR_UINT16_UINT32)
        components << self.class.encoded_payload(@payload)
        components << FINAL_OCTET
        components
      end

      def encode
        s = [self.class.id, @channel, @payload.bytesize].pack(PACK_CHAR_UINT16_UINT32)
        s << self.class.encoded_payload(@payload)
        s << FINAL_OCTET
        s
      end
    end

    class MethodFrame < FrameSubclass
      @id = 1

      def method_class
        @method_class ||= begin
                            klass_id, method_id = self.payload.unpack(PACK_UINT16_X2)
                            index               = klass_id << 16 | method_id
                            AMQ::Protocol::METHODS[index]
                          end
      end

      def final?
        !self.method_class.has_content?
      end # final?

      def decode_payload
        self.method_class.decode(@payload[4..-1])
      end
    end

    class HeaderFrame < FrameSubclass
      @id = 2

      def final?
        false
      end

      def body_size
        decode_payload
        @body_size
      end

      def weight
        decode_payload
        @weight
      end

      def klass_id
        decode_payload
        @klass_id
      end

      def properties
        decode_payload
        @properties
      end

      def decode_payload
        @decoded_payload ||= begin
                               @klass_id, @weight = @payload.unpack(PACK_UINT16_X2)
                               # the total size of the content body, that is, the sum of the body sizes for the
                               # following content body frames. Zero indicates that there are no content body frames.
                               # So this is NOT related to this very header frame!
                               @body_size         = AMQ::Hacks.unpack_uint64_big_endian(@payload[4..11]).first
                               @data              = @payload[12..-1]
                               @properties        = Basic.decode_properties(@data)
                             end
      end
    end

    class BodyFrame < FrameSubclass
      @id = 3

      def decode_payload
        @payload
      end

      def final?
        # we cannot know whether it is final or not so framing code in amq-client
        # checks this over the entire frameset. MK.
        false
      end
    end

    class HeartbeatFrame < FrameSubclass
      @id = 8

      def final?
        true
      end # final?

      def self.encode
        super(Protocol::EMPTY_STRING, 0)
      end
    end

    Frame::CLASSES = {
      Frame::TYPES[:method] => MethodFrame,
      Frame::TYPES[:headers] => HeaderFrame,
      Frame::TYPES[:body] => BodyFrame,
      Frame::TYPES[:heartbeat] => HeartbeatFrame
    }
  end
end
