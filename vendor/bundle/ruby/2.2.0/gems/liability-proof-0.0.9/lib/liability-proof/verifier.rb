module LiabilityProof
  class Verifier

    def initialize(options)
      @root_path = options.delete(:root) || 'root.json'
      @partial_tree_path = options.delete(:file)
    end

    def root_json
      @root_json ||= JSON.parse File.read(@root_path)
    end

    def partial_tree_json
      @partial_tree_json ||= JSON.parse File.read(@partial_tree_path)
    end

    def expect_root
      root_json['root']
    end

    def match?
      partial_tree = partial_tree_json['partial_tree']

      @reduced_root = reduce(partial_tree).as_json
      @reduced_root == expect_root
    end

    def verify!
      if match?
        puts "Partial tree verified successfully!\n\n"
        puts "User: #{@user_node.user}"
        puts "Balance: #{@user_node.sum_string}"
      else
        raise "Mismatch! Expected root: #{expect_root.inspect}, calculated root: #{@reduced_root.inspect}"
      end
    rescue
      puts "INVALID partial tree!"
      puts "ERROR: #{$!}"
      puts "Expected root:"
      ap expect_root
      if @reduced_root
        puts "Calculated root:"
        ap @reduced_root
      end
    end

    private

    def reduce(node)
      if node['data']
        user  = node['data']['user']
        sum   = ::BigDecimal.new node['data']['sum'].to_s
        nonce = node['data']['nonce']
        hash  = node['data']['hash']
        leaf = Tree::LeafNode.new user, sum, nonce, hash
        @user_node = leaf if leaf.user
        leaf
      else
        left  = reduce node['left']
        right = reduce node['right']
        Tree::InternalNode.new(left, right)
      end
    end

  end
end
