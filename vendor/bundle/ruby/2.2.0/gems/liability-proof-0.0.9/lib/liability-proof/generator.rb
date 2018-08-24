require 'fileutils'

module LiabilityProof
  class Generator

    def initialize(options)
      @accounts_path     = options.delete(:file) || 'accounts.json'
      @root_path         = options.delete(:root) || 'root.json'

      @partial_trees_dir = options.delete(:partial_trees_dir) || 'partial_trees'
      FileUtils.mkdir @partial_trees_dir unless File.exists?(@partial_trees_dir)

      accounts = JSON.parse File.read(@accounts_path)
      @tree    = LiabilityProof::Tree.new accounts, options
    end

    def write!
      write_root_json
      @tree.indices.keys.each {|user| write_partial_tree(user) }
    end

    private

    def write_root_json
      File.open(@root_path, 'w') do |f|
        f.write JSON.dump(@tree.root_json)
      end
    end

    def write_partial_tree(user)
      File.open(File.join(@partial_trees_dir, "#{user}.json"), 'w') do |f|
        f.write JSON.dump(@tree.partial_json(user))
      end
    end

  end
end
