# -*- encoding: utf-8 -*-
# stub: redis-rails 4.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "redis-rails"
  s.version = "4.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Luca Guidi"]
  s.date = "2013-08-20"
  s.description = "Redis for Ruby on Rails"
  s.email = ["me@lucaguidi.com"]
  s.homepage = "http://redis-store.org/redis-rails"
  s.rubyforge_project = "redis-rails"
  s.rubygems_version = "2.4.5"
  s.summary = "Redis for Ruby on Rails"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<redis-store>, ["~> 1.1.0"])
      s.add_runtime_dependency(%q<redis-activesupport>, ["~> 4"])
      s.add_runtime_dependency(%q<redis-actionpack>, ["~> 4"])
      s.add_development_dependency(%q<rake>, ["~> 10"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<mocha>, ["~> 0.14.0"])
      s.add_development_dependency(%q<minitest>, ["~> 4.2"])
    else
      s.add_dependency(%q<redis-store>, ["~> 1.1.0"])
      s.add_dependency(%q<redis-activesupport>, ["~> 4"])
      s.add_dependency(%q<redis-actionpack>, ["~> 4"])
      s.add_dependency(%q<rake>, ["~> 10"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<mocha>, ["~> 0.14.0"])
      s.add_dependency(%q<minitest>, ["~> 4.2"])
    end
  else
    s.add_dependency(%q<redis-store>, ["~> 1.1.0"])
    s.add_dependency(%q<redis-activesupport>, ["~> 4"])
    s.add_dependency(%q<redis-actionpack>, ["~> 4"])
    s.add_dependency(%q<rake>, ["~> 10"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<mocha>, ["~> 0.14.0"])
    s.add_dependency(%q<minitest>, ["~> 4.2"])
  end
end
