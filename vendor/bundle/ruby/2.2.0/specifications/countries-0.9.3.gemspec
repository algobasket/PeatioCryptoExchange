# -*- encoding: utf-8 -*-
# stub: countries 0.9.3 ruby lib

Gem::Specification.new do |s|
  s.name = "countries"
  s.version = "0.9.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Josh Robinson", "Joe Corcoran"]
  s.date = "2013-10-28"
  s.description = "All sorts of useful information about every country packaged as pretty little country objects. It includes data from ISO 3166"
  s.email = ["hexorx@gmail.com"]
  s.homepage = "http://github.com/hexorx/countries"
  s.rubygems_version = "2.4.5"
  s.summary = "Gives you a country object full of all sorts of useful information."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<currencies>, ["~> 0.4.2"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<currencies>, ["~> 0.4.2"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<currencies>, ["~> 0.4.2"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
