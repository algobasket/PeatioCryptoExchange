module LiabilityProof
  class Tree

    class InternalNode < Struct.new(:left, :right, :sum, :hash)
      include ::LiabilityProof::Tree::Node

      def initialize(left, right)
        super(left, right)

        self.sum = left.sum + right.sum
        self.hash  = generate_hash
      end

      private

      def generate_hash
        LiabilityProof.sha256_base64 "#{sum_string}|#{left.hash}|#{right.hash}"
      end

    end

  end
end
