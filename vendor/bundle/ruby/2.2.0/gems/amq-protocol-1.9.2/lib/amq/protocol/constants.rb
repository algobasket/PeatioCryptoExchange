module AMQ
  module Protocol
    TLS_PORT         = 5671
    SSL_PORT         = 5671

    # caching
    EMPTY_STRING = "".freeze

    PACK_INT8               = 'c'.freeze
    PACK_CHAR               = 'C'.freeze
    PACK_UINT16             = 'n'.freeze
    PACK_UINT16_X2          = 'n2'.freeze
    PACK_UINT32             = 'N'.freeze
    PACK_UINT32_X2          = 'N2'.freeze
    PACK_INT64              = 'q'.freeze
    PACK_UCHAR_UINT32       = 'CN'.freeze
    PACK_CHAR_UINT16_UINT32 = 'cnN'.freeze

    PACK_32BIT_FLOAT        = 'f'.freeze
    PACK_64BIT_FLOAT        = 'G'.freeze
  end
end
