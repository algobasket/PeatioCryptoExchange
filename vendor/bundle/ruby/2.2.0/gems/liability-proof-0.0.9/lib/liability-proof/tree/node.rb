module LiabilityProof
  class Tree

    module Node

      def as_json
        { 'sum' => sum_string, 'hash' => hash }
      end

      def as_user_json
        { 'sum' => sum_string, 'nonce' => nonce, 'user' => user }
      end

      def sum_string
        decimal_to_digits sum
      end

      def decimal_to_digits(d)
        _, significant_digits, _, exponent = d.split
        if d.zero?
          '0'
        elsif exponent >= significant_digits.size
          d.to_i.to_s
        else
          d.to_s('F')
        end
      end

    end

  end
end
