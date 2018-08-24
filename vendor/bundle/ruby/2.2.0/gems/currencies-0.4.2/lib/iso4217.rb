$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'YAML' unless defined?(YAML)
require 'net/http' unless defined?(Net::HTTP)

require 'currencies/extentions'
require 'currencies/currency'
require 'currencies/exchange_bank'