# -*- encoding: utf-8 -*-
# stub: omniauth-identity 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "omniauth-identity"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Michael Bleigh"]
  s.date = "2013-07-04"
  s.description = "Internal authentication handlers for OmniAuth."
  s.email = ["michael@intridea.com"]
  s.homepage = "http://github.com/intridea/omniauth-identity"
  s.rubygems_version = "2.4.5"
  s.summary = "Internal authentication handlers for OmniAuth."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<omniauth>, ["~> 1.0"])
      s.add_runtime_dependency(%q<bcrypt-ruby>, ["~> 3.0"])
      s.add_development_dependency(%q<maruku>, ["~> 0.6"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.4"])
      s.add_development_dependency(%q<rack-test>, ["~> 0.5"])
      s.add_development_dependency(%q<rake>, ["~> 0.8"])
      s.add_development_dependency(%q<rspec>, ["~> 2.7"])
      s.add_development_dependency(%q<activerecord>, ["~> 3.1"])
      s.add_development_dependency(%q<mongoid>, [">= 0"])
      s.add_development_dependency(%q<mongo_mapper>, [">= 0"])
      s.add_development_dependency(%q<datamapper>, [">= 0"])
      s.add_development_dependency(%q<bson_ext>, [">= 0"])
      s.add_development_dependency(%q<couch_potato>, [">= 0"])
    else
      s.add_dependency(%q<omniauth>, ["~> 1.0"])
      s.add_dependency(%q<bcrypt-ruby>, ["~> 3.0"])
      s.add_dependency(%q<maruku>, ["~> 0.6"])
      s.add_dependency(%q<simplecov>, ["~> 0.4"])
      s.add_dependency(%q<rack-test>, ["~> 0.5"])
      s.add_dependency(%q<rake>, ["~> 0.8"])
      s.add_dependency(%q<rspec>, ["~> 2.7"])
      s.add_dependency(%q<activerecord>, ["~> 3.1"])
      s.add_dependency(%q<mongoid>, [">= 0"])
      s.add_dependency(%q<mongo_mapper>, [">= 0"])
      s.add_dependency(%q<datamapper>, [">= 0"])
      s.add_dependency(%q<bson_ext>, [">= 0"])
      s.add_dependency(%q<couch_potato>, [">= 0"])
    end
  else
    s.add_dependency(%q<omniauth>, ["~> 1.0"])
    s.add_dependency(%q<bcrypt-ruby>, ["~> 3.0"])
    s.add_dependency(%q<maruku>, ["~> 0.6"])
    s.add_dependency(%q<simplecov>, ["~> 0.4"])
    s.add_dependency(%q<rack-test>, ["~> 0.5"])
    s.add_dependency(%q<rake>, ["~> 0.8"])
    s.add_dependency(%q<rspec>, ["~> 2.7"])
    s.add_dependency(%q<activerecord>, ["~> 3.1"])
    s.add_dependency(%q<mongoid>, [">= 0"])
    s.add_dependency(%q<mongo_mapper>, [">= 0"])
    s.add_dependency(%q<datamapper>, [">= 0"])
    s.add_dependency(%q<bson_ext>, [">= 0"])
    s.add_dependency(%q<couch_potato>, [">= 0"])
  end
end
