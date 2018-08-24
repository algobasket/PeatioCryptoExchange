# encoding: binary

require 'bundler/setup'
require 'rspec'

require "effin_utf8"

begin
  require 'simplecov'

  SimpleCov.start do
    add_filter '/spec/'
  end
rescue LoadError
end

$: << File.expand_path('../../lib', __FILE__)

require "amq/protocol"

puts "Running on #{RUBY_VERSION}"

module RubyVersionsSupport
  def one_point_eight?
    RUBY_VERSION =~ /^1.8/
  end
end # RubyVersionsSUpport


RSpec.configure do |config|
  config.include AMQ::Protocol

  config.include(RubyVersionsSupport)
  config.extend(RubyVersionsSupport)
end
