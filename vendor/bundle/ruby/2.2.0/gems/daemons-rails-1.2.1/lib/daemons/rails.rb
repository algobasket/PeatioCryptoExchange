require 'daemons'
require 'daemons/rails/configuration'

module Daemons
  module Rails
    # @return [Daemons::Rails::Configuration]
    def self.configuration
      @configuration ||= Daemons::Rails::Configuration.new
    end

    def self.configure
      yield configuration
    end

    def self.run(*args)
      Daemons.run(*args)
    end
  end
end