# -*- encoding: utf-8 -*-
# stub: redis-rack 1.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "redis-rack"
  s.version = "1.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Luca Guidi"]
  s.date = "2013-08-20"
  s.description = "Redis Store for Rack"
  s.email = ["me@lucaguidi.com"]
  s.homepage = "http://redis-store.org/redis-rack"
  s.rubyforge_project = "redis-rack"
  s.rubygems_version = "2.4.5"
  s.summary = "Redis Store for Rack"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<redis-store>, ["~> 1.1.0"])
      s.add_runtime_dependency(%q<rack>, ["~> 1.5"])
      s.add_development_dependency(%q<rake>, ["~> 10"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<mocha>, ["~> 0.14.0"])
      s.add_development_dependency(%q<minitest>, ["~> 5"])
    else
      s.add_dependency(%q<redis-store>, ["~> 1.1.0"])
      s.add_dependency(%q<rack>, ["~> 1.5"])
      s.add_dependency(%q<rake>, ["~> 10"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<mocha>, ["~> 0.14.0"])
      s.add_dependency(%q<minitest>, ["~> 5"])
    end
  else
    s.add_dependency(%q<redis-store>, ["~> 1.1.0"])
    s.add_dependency(%q<rack>, ["~> 1.5"])
    s.add_dependency(%q<rake>, ["~> 10"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<mocha>, ["~> 0.14.0"])
    s.add_dependency(%q<minitest>, ["~> 5"])
  end
end
