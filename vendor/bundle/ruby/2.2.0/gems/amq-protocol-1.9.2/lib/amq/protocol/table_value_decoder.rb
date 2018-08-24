# encoding: binary

require "amq/endianness"
require "amq/protocol/client"
require "amq/protocol/type_constants"
require "amq/protocol/table"
require "amq/protocol/float_32bit"

module AMQ
  module Protocol

    class TableValueDecoder

      #
      # Behaviors
      #

      include TypeConstants


      #
      # API
      #

      def self.decode_array(data, initial_offset)
        array_length = data.slice(initial_offset, 4).unpack(PACK_UINT32).first

        ary    = Array.new
        offset = initial_offset + 4

        while offset <= (initial_offset + array_length)
          type, offset = decode_value_type(data, offset)

          i = case type
              when TYPE_STRING
                v, offset = decode_string(data, offset)
                v
              when TYPE_INTEGER
                v, offset = decode_integer(data, offset)
                v
              when TYPE_DECIMAL
                v, offset = decode_big_decimal(data, offset)
                v
              when TYPE_TIME
                v, offset = decode_time(data, offset)
                v
              when TYPE_HASH
                v, offset = decode_hash(data, offset)
                v
              when TYPE_BOOLEAN
                v, offset = decode_boolean(data, offset)
                v
              when TYPE_BYTE then
                v, offset = decode_byte(data, offset)
                v
              when TYPE_SIGNED_16BIT then
                v, offset = decode_short(data, offset)
                v
              when TYPE_SIGNED_64BIT then
                v, offset = decode_long(data, offset)
                v
              when TYPE_32BIT_FLOAT then
                v, offset = decode_32bit_float(data, offset)
                v
              when TYPE_64BIT_FLOAT then
                v, offset = decode_64bit_float(data, offset)
                v
              when TYPE_VOID
                nil
              when TYPE_ARRAY
                v, offset = TableValueDecoder.decode_array(data, offset)
                v
              else
                raise ArgumentError.new("unsupported type in a table value: #{type.inspect}, do not know how to decode!")
              end

          ary << i
        end


        [ary, initial_offset + array_length + 4]
      end # self.decode_array(data, initial_offset)


      def self.decode_string(data, offset)
        length = data.slice(offset, 4).unpack(PACK_UINT32).first
        offset += 4
        v = data.slice(offset, length)
        offset += length

        [v, offset]
      end # self.decode_string(data, offset)


      def self.decode_integer(data, offset)
        v = data.slice(offset, 4).unpack(PACK_UINT32).first
        offset += 4

        [v, offset]
      end # self.decode_integer(data, offset)


      if AMQ::Endianness.big_endian?
        def self.decode_long(data, offset)
          v    = data.slice(offset, 8).unpack(PACK_INT64)

          offset += 8
          [v, offset]
        end
      else
        def self.decode_long(data, offset)
          slice = data.slice(offset, 8).bytes.to_a.reverse.map(&:chr).join
          v     = slice.unpack(PACK_INT64).first

          offset += 8
          [v, offset]
        end
      end


      def self.decode_big_decimal(data, offset)
        decimals, raw = data.slice(offset, 5).unpack(PACK_UCHAR_UINT32)
        offset += 5
        v = BigDecimal.new(raw.to_s) * (BigDecimal.new(TEN) ** -decimals)

        [v, offset]
      end # self.decode_big_decimal(data, offset)


      def self.decode_time(data, offset)
        timestamp = data.slice(offset, 8).unpack(PACK_UINT32_X2).last
        v = Time.at(timestamp)
        offset += 8

        [v, offset]
      end # self.decode_time(data, offset)


      def self.decode_boolean(data, offset)
        integer = data.slice(offset, 2).unpack(PACK_CHAR).first # 0 or 1
        offset += 1
        [(integer == 1), offset]
      end # self.decode_boolean(data, offset)


      def self.decode_32bit_float(data, offset)
        v = data.slice(offset, 4).unpack(PACK_32BIT_FLOAT).first
        offset += 4

        [v, offset]
      end # self.decode_32bit_float(data, offset)


      def self.decode_64bit_float(data, offset)
        v = data.slice(offset, 8).unpack(PACK_64BIT_FLOAT).first
        offset += 8

        [v, offset]
      end # self.decode_64bit_float(data, offset)


      def self.decode_value_type(data, offset)
        [data.slice(offset, 1), offset + 1]
      end # self.decode_value_type(data, offset)



      def self.decode_hash(data, offset)
        length = data.slice(offset, 4).unpack(PACK_UINT32).first
        v = Table.decode(data.slice(offset, length + 4))
        offset += 4 + length

        [v, offset]
      end # self.decode_hash(data, offset)


      # Decodes/Converts a byte value from the data at the provided offset.
      #
      # @param [Array] data - A big-endian ordered array of bytes.
      # @param [Fixnum] offset - The offset which bytes the byte is consumed.
      # @return [Array] - The Fixnum value and new offset pair.
      def self.decode_byte(data, offset)
        [data.slice(offset, 1).unpack(PACK_CHAR).first, offset += 1]
      end


      def self.decode_short(data, offset)
        v = AMQ::Hacks.unpack_int16_big_endian(data.slice(offset, 2)).first
        offset += 2
        [v, offset]
      end
    end # TableValueDecoder
  end # Protocol
end # AMQ
