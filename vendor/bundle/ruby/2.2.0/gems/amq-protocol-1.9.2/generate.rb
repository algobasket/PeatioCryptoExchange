#!/usr/bin/env ruby
# encoding: utf-8

def sh(*args)
  system(*args)
end

extensions = []

spec = "codegen/rabbitmq-codegen/amqp-rabbitmq-0.9.1.json"
unless File.exist?(spec)
  sh "git submodule update --init"
end

path = "lib/amq/protocol/client.rb"
puts "Running ./codegen/codegen.py client #{spec} #{path}"
sh "./codegen/codegen.py client #{spec} #{extensions.join(' ')} #{path}"
if File.file?(path)
  sh "ruby -c #{path}"
end
