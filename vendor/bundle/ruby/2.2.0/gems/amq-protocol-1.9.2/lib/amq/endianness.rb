module AMQ
  module Endianness
    BIG_ENDIAN = ([1].pack("s") == "\x00\x01")

    def big_endian?
      BIG_ENDIAN
    end

    def little_endian?
      !BIG_ENDIAN
    end

    extend self
  end
end
