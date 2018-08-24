#!/usr/bin/env ruby
# encoding: utf-8

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib"))

require "amq/protocol/client"

FRAME_SIZE = 128 * 1024

puts
puts "-" * 80
puts "Profiling on #{RUBY_DESCRIPTION}"

n = 250_000

# warm up the JIT, etc
puts "Doing a warmup run..."
15_000.times { AMQ::Protocol::Method.encode_body("ab" * 1024, 1, FRAME_SIZE) }

require 'stackprof'

# preallocate
ary = Array.new(n) { "ab" * 1024 }

puts "Doing main run..."
result = StackProf.run(mode: :wall) do
  n.times { |i| AMQ::Protocol::Method.encode_body(ary[i], 1, FRAME_SIZE) }
end

File.open('./profiling/dumps/body_framing_with_2k_payload.dump', "w+") do |f|
  f.write Marshal.dump(result)
end

