# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paranoid2/version'

Gem::Specification.new do |gem|
  gem.name          = "paranoid2"
  gem.version       = Paranoid2::VERSION
  gem.authors       = ["yury"]
  gem.email         = ["yury.korolev@gmail.com"]
  gem.description   = %q{paranoid models for rails 4}
  gem.summary       = %q{paranoid models for rails 4}
  gem.homepage      = "https://github.com/anjlab/paranoid2"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activerecord', '>= 4.0.0.rc1'

  gem.add_development_dependency "rake"
  gem.add_development_dependency "sqlite3"
end
