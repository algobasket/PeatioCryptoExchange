$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

require 'amq/int_allocator'
require "benchmark"

allocator = AMQ::IntAllocator.new(1,65535)
mutex = Mutex.new

Benchmark.bm do |x|


  x.report("allocate") do
    allocator = AMQ::IntAllocator.new(1,65535)
    1.upto(65534) do |i|
      mutex.synchronize do
        n = allocator.allocate
        raise 'it be broke' unless n == i
      end
    end
  end

  x.report("allocate_with_release") do
    allocator = AMQ::IntAllocator.new(1,65535)
    1.upto(65534) do |i|
      mutex.synchronize do
        n = allocator.allocate
        if i % 5 == 0
          allocator.release(n)
        end
      end
    end
  end

end