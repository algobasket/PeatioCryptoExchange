#!/usr/bin/env gem build
# encoding: utf-8

require "base64"

require File.expand_path("../lib/amq/protocol/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "amq-protocol"
  s.version = AMQ::Protocol::VERSION
  s.authors = ["Jakub Stastny", "Michael S. Klishin", "Theo Hultberg", "Mark Abramov"]
  s.homepage = "http://github.com/ruby-amqp/amq-protocol"
  s.summary = "AMQP 0.9.1 encoder & decoder."
  s.description = <<-DESC
  amq-protocol is an AMQP 0.9.1 serialization library for Ruby. It is not an
  AMQP client: amq-protocol only handles serialization and deserialization.
  If you want to write your own AMQP client, this gem can help you with that.
  DESC
  s.email = ["bWljaGFlbEBub3ZlbWJlcmFpbi5jb20=\n", "c3Rhc3RueUAxMDFpZGVhcy5jeg==\n"].map { |i| Base64.decode64(i) }
  s.licenses    = ["MIT"]

  # files
  s.files = `git ls-files`.split("\n").reject { |file| file =~ /^vendor\// }
  s.require_paths = ["lib"]

  s.extra_rdoc_files = ["README.md"] + Dir.glob("doc/*")


  # RubyForge
  s.rubyforge_project = "amq-protocol"
end
