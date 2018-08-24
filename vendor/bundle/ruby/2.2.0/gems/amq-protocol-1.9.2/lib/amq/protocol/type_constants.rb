# encoding: binary

module AMQ
  module Protocol
    module TypeConstants
      TYPE_STRING       = 'S'.freeze
      TYPE_INTEGER      = 'I'.freeze
      TYPE_TIME         = 'T'.freeze
      TYPE_DECIMAL      = 'D'.freeze
      TYPE_HASH         = 'F'.freeze
      TYPE_ARRAY        = 'A'.freeze
      TYPE_BYTE         = 'b'.freeze
      TYPE_64BIT_FLOAT  = 'd'.freeze
      TYPE_32BIT_FLOAT  = 'f'.freeze
      TYPE_SIGNED_64BIT = 'l'.freeze
      TYPE_SIGNED_16BIT = 's'.freeze
      TYPE_BOOLEAN      = 't'.freeze
      TYPE_BYTE_ARRAY   = 'x'.freeze
      TYPE_VOID         = 'V'.freeze
      TEN               = '10'.freeze

      BOOLEAN_TRUE  = "\x01".freeze
      BOOLEAN_FALSE = "\x00".freeze
    end # TypeConstants
  end # Protocol
end # AMQ
