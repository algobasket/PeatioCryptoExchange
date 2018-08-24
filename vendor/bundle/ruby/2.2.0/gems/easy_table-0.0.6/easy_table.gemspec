# -*- encoding: utf-8 -*-
require File.expand_path('../lib/easy_table/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jakub Głuszecki"]
  gem.email         = ["jakub.gluszecki@gmail.com"]
  gem.description   = "HTML tables made easy (in Rails 4)"
  gem.summary       = "HTML tables made easy (in Rails 4)"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "easy_table"
  gem.require_paths = ["lib"]
  gem.version       = EasyTable::VERSION

  gem.add_dependency 'activemodel', '~> 4.0'
  gem.add_dependency 'actionpack', '~> 4.0'
  gem.add_dependency 'rubytree', '~> 0.8.3'
end
