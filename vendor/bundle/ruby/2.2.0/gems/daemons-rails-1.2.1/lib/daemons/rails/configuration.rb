require 'pathname'
require 'fileutils'

module Daemons
  module Rails
    class Configuration
      def detect_root
        if ENV["DAEMONS_ROOT"]
          Pathname.new(ENV["DAEMONS_ROOT"])
        elsif defined?(::Rails)
          ::Rails.root
        else
          root = Pathname.new(FileUtils.pwd)
          root = root.parent unless root.directory?
          root = root.parent until File.exists?(root.join('config.ru')) || root.root?
          raise "Can't detect Rails application root" if root.root?
          root
        end
      end

      def daemons_path=(path)
        @daemons_path = path && (path.is_a?(Pathname) ? path : Pathname.new(File.expand_path(path)))
      end

      def root=(path)
        @root = path && (path.is_a?(Pathname) ? path : Pathname.new(File.expand_path(path)))
      end

      def root
        @root ||= detect_root
      end

      def daemons_path
        @daemons_path || root.join('lib', 'daemons')
      end

      def daemons_directory
        daemons_path.relative_path_from(root)
      end
    end
  end
end
