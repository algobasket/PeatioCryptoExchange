#!/usr/bin/env ruby
# encoding: utf-8

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib"))

require "amq/protocol/client"
require "benchmark"

FRAME_SIZE = 128 * 1024

puts
puts "-" * 80
puts "Benchmarking on #{RUBY_DESCRIPTION}"

n = 250_000

# warm up the JIT, etc
puts "Doing a warmup run..."
15_000.times { AMQ::Protocol::Method.encode_body("ab" * 1024, 1, FRAME_SIZE) }

t  = Benchmark.realtime do
  n.times { AMQ::Protocol::Method.encode_body("ab" * 1024, 1, FRAME_SIZE) }
end
r  = (n.to_f/t.to_f)

puts "AMQ::Protocol::Method.encode_body rate: #{(r / 1000).round(2)} KGHz"
puts
puts "-" * 80
