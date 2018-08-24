# -*- encoding: utf-8 -*-
# stub: redis-actionpack 4.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "redis-actionpack"
  s.version = "4.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Luca Guidi"]
  s.date = "2013-08-20"
  s.description = "Redis session store for ActionPack"
  s.email = ["me@lucaguidi.com"]
  s.homepage = "http://redis-store.org/redis-actionpack"
  s.rubyforge_project = "redis-actionpack"
  s.rubygems_version = "2.4.5"
  s.summary = "Redis session store for ActionPack"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<redis-store>, ["~> 1.1.0"])
      s.add_runtime_dependency(%q<redis-rack>, ["~> 1.5.0"])
      s.add_runtime_dependency(%q<actionpack>, ["~> 4"])
      s.add_development_dependency(%q<rake>, ["~> 10"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<mocha>, ["~> 0.14.0"])
      s.add_development_dependency(%q<minitest>, ["~> 4.2"])
      s.add_development_dependency(%q<tzinfo>, [">= 0"])
      s.add_development_dependency(%q<mini_specunit>, [">= 0"])
      s.add_development_dependency(%q<mini_backtrace>, [">= 0"])
    else
      s.add_dependency(%q<redis-store>, ["~> 1.1.0"])
      s.add_dependency(%q<redis-rack>, ["~> 1.5.0"])
      s.add_dependency(%q<actionpack>, ["~> 4"])
      s.add_dependency(%q<rake>, ["~> 10"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<mocha>, ["~> 0.14.0"])
      s.add_dependency(%q<minitest>, ["~> 4.2"])
      s.add_dependency(%q<tzinfo>, [">= 0"])
      s.add_dependency(%q<mini_specunit>, [">= 0"])
      s.add_dependency(%q<mini_backtrace>, [">= 0"])
    end
  else
    s.add_dependency(%q<redis-store>, ["~> 1.1.0"])
    s.add_dependency(%q<redis-rack>, ["~> 1.5.0"])
    s.add_dependency(%q<actionpack>, ["~> 4"])
    s.add_dependency(%q<rake>, ["~> 10"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<mocha>, ["~> 0.14.0"])
    s.add_dependency(%q<minitest>, ["~> 4.2"])
    s.add_dependency(%q<tzinfo>, [">= 0"])
    s.add_dependency(%q<mini_specunit>, [">= 0"])
    s.add_dependency(%q<mini_backtrace>, [">= 0"])
  end
end
