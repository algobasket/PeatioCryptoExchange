module LiabilityProof
  class Tree

    class LeafNode < Struct.new(:user, :sum, :nonce, :hash)
      include ::LiabilityProof::Tree::Node

      def initialize(user, sum, nonce, hash=nil)
        raise ArgumentError, "sum must be BigDecimal" unless sum.is_a?(BigDecimal)

        super(user, sum, nonce)
        self.hash  = hash || generate_hash

        if user && hash && nonce
          raise ArgumentError, "Hash doesn't match" if generate_hash != hash
        end
      end

      private

      # a sha256 hash encoded in 64 hex digits
      def generate_hash
        LiabilityProof.sha256_base64 "#{user}|#{sum_string}|#{nonce}"
      end

    end

  end
end
