require 'json'
require 'bigdecimal'
require 'awesome_print'

module LiabilityProof

  autoload :Tree,          'liability-proof/tree'
  autoload :Generator,     'liability-proof/generator'
  autoload :Verifier,      'liability-proof/verifier'
  autoload :PrettyPrinter, 'liability-proof/pretty_printer'

  module_function

  def sha256_base64(message)
    OpenSSL::Digest::SHA256.new.digest(message).unpack('H*').first
  end

end
