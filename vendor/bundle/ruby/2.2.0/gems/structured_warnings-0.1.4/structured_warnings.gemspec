require 'rubygems'

Gem::Specification.new do |s|
  s.name       = 'structured_warnings'
  s.version    = '0.1.4'
  s.author     = 'Gregor Schmidt'
  s.email      = 'ruby@schmidtwisser.de'
  s.homepage   = 'http://github.com/schmidt/structured_warnings'
  s.summary    = 'Provides structured warnings for Ruby, using an exception-like interface and hierarchy'
  s.files      = Dir['**/*'].reject{ |f| f.include?('git') }
  s.test_files = Dir['test/*.rb']

  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = ['README.rdoc']

  s.description = %Q{
    This is an implementation of Daniel Berger's proposal of structured
    warnings for Ruby.
  }
end
