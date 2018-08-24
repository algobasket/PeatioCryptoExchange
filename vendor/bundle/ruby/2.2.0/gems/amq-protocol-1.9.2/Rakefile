require "bundler"
Bundler.setup

require "rake"
require "rspec/core/rake_task"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "amq/protocol/version"

task :gem => :build
task :build do
  system "gem build amq-protocol.gemspec"
end

task :install => :build do
  system "gem install amq-protocol-#{AMQ::Protocol::VERSION}.gem"
end

def extension
  RUBY_PLATFORM =~ /darwin/ ? "bundle" : "so"
end

def compile!
  puts "Compiling native extensions..."
  Dir.chdir(Pathname(__FILE__).dirname + "ext/") do
    `bundle exec ruby extconf.rb`
    `make`
    `cp client.#{extension} ../lib/amq/protocol/native/`
  end
end

RSpec::Core::RakeTask.new("spec") do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

RSpec::Core::RakeTask.new("clean_spec") do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :compile do
  compile!
end

task :clean do
  puts "Cleaning out native extensions..."
  begin
    Dir.chdir(Pathname(__FILE__).dirname + "lib/amq-protocol/native") do
      `rm client.#{extension}`
    end
  rescue Exception => e
    puts e.message
  end
end

task :default => [:compile, :spec, :clean, :clean_spec]
