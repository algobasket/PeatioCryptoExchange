module LiabilityProof
  class PrettyPrinter

    def initialize(options)
      @json_path = options.delete(:file)
      raise ArgumentError, "file to print unspecified" unless @json_path

      @json = JSON.parse File.read(@json_path)
    end

    def print
      if Hash === @json && @json.keys.first == 'partial_tree'
        print_tree @json['partial_tree']
      else
        ap @json
      end
    end

    private

    def print_tree(node, depth=0)
      print_node node, depth

      if node.has_key?('left') && node.has_key?('right')
        print_tree node['left'],  depth+1
        print_tree node['right'], depth+1
      else # leaf
      end
    end

    def print_node(node, depth)
      tab = " |"*depth + "_ "
      text = lable node
      puts "#{tab}#{text}"
    end

    def lable(node)
      if data = node['data']
        if data['user']
          "#{data['user']}, #{data['nonce']}, #{data['sum']}"
        else
          "#{data['sum']}, #{data['hash']}"
        end
      else
        ''
      end
    end
  end
end
