# -*- encoding: utf-8 -*-
# stub: currencies 0.4.2 ruby lib

Gem::Specification.new do |s|
  s.name = "currencies"
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["hexorx", "pr0d1r2"]
  s.date = "2013-06-07"
  s.description = "If you are tracking any kind of assets the currencies gem is for you. It contains every currency in the ISO 4217 standard and allows you to add your own as well. So if you decide to take sparkly buttons as a form of payment you can use currencies to display the shiny button unicode symbol \u{263c} (disclaimer: \u{263c} may not look like a shiny button to everyone.) when used with something like the money gem. Speaking of the money gem, currencies gives you an ExchangeBank that the money gem can use to convert from one currency to another. There are plans to have ExchangeRate provider plugin system. Right now the rates are either set manually or pulled from Yahoo Finance."
  s.email = ["hexorx@gmail.com", "pr0d1r2@gmail.com"]
  s.homepage = "http://github.com/hexorx/currencies"
  s.rubygems_version = "2.4.5"
  s.summary = "Simple gem for working with currencies. It is extracted from the countries gem and contains all the currency information in the ISO 4217 standard."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
