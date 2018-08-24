# encoding: binary

require 'amq/endianness'

module AMQ
  # Implements pack to/unpack from 64bit string in network byte order
  # compatible with Ruby 1.8+.
  module Pack
    UINT64 = "Q".freeze
    UINT16_BE  = "n".freeze
    INT16 = "c".freeze

    if Endianness.big_endian?
      def self.pack_uint64_big_endian(long_long)
        [long_long].pack(UINT64)
      end

      def self.unpack_uint64_big_endian(data)
        data.unpack(UINT64)
      end

      def self.pack_int16_big_endian(short)
        [long_long].pack(INT16)
      end

      def self.unpack_int16_big_endian(data)
        data.unpack(INT16)
      end
    else
      def self.pack_uint64_big_endian(long_long)
        result = [long_long].pack(UINT64)
        result.bytes.to_a.reverse.map(&:chr).join
      end

      def self.unpack_uint64_big_endian(data)
        data = data.bytes.to_a.reverse.map(&:chr).join
        data.unpack(UINT64)
      end

      def self.pack_int16_big_endian(short)
        result = [long_long].pack(INT16)
        result.bytes.to_a.reverse.map(&:chr).join
      end

      def self.unpack_int16_big_endian(data)
        value = data.bytes.to_a.map(&:chr).join.unpack(UINT16_BE)[0]
        [(value & ~(1 << 15)) - (value & (1 << 15))]
      end
    end
  end

  # Backwards compatibility
  Hacks = Pack
end
