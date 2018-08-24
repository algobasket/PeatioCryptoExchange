# -*- encoding: utf-8 -*-
require File.expand_path('../lib/currencies/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["hexorx", "pr0d1r2"]
  gem.email         = ["hexorx@gmail.com", "pr0d1r2@gmail.com"]
  gem.description   = %q{If you are tracking any kind of assets the currencies gem is for you. It contains every currency in the ISO 4217 standard and allows you to add your own as well. So if you decide to take sparkly buttons as a form of payment you can use currencies to display the shiny button unicode symbol ☼ (disclaimer: ☼ may not look like a shiny button to everyone.) when used with something like the money gem. Speaking of the money gem, currencies gives you an ExchangeBank that the money gem can use to convert from one currency to another. There are plans to have ExchangeRate provider plugin system. Right now the rates are either set manually or pulled from Yahoo Finance.}
  gem.summary       = %q{Simple gem for working with currencies. It is extracted from the countries gem and contains all the currency information in the ISO 4217 standard.}
  gem.homepage      = "http://github.com/hexorx/currencies"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "currencies"
  gem.require_paths = ["lib"]
  gem.version       = Currencies::VERSION

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "yard"
end
