# -*- encoding: utf-8 -*-
# stub: slim-rails 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "slim-rails"
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Leonardo Almeida"]
  s.date = "2014-01-27"
  s.description = "Provides the generator settings required for Rails 3 to use Slim"
  s.email = ["lalmeida08@gmail.com"]
  s.homepage = "https://github.com/slim-template/slim-rails"
  s.rubygems_version = "2.4.5"
  s.summary = "Provides the generator settings required for Rails 3 to use Slim"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 0.9"])
      s.add_development_dependency(%q<rocco>, ["~> 0.8"])
      s.add_development_dependency(%q<redcarpet>, ["~> 1.0"])
      s.add_development_dependency(%q<awesome_print>, ["~> 1.0"])
      s.add_development_dependency(%q<guard>, ["~> 0.10"])
      s.add_development_dependency(%q<guard-minitest>, ["~> 0.4"])
      s.add_development_dependency(%q<guard-rocco>, ["~> 0.0.3"])
      s.add_runtime_dependency(%q<activesupport>, ["< 4.1", ">= 3.0"])
      s.add_runtime_dependency(%q<actionpack>, ["< 4.1", ">= 3.0"])
      s.add_runtime_dependency(%q<railties>, ["< 4.1", ">= 3.0"])
      s.add_runtime_dependency(%q<slim>, ["~> 2.0"])
    else
      s.add_dependency(%q<rake>, ["~> 0.9"])
      s.add_dependency(%q<rocco>, ["~> 0.8"])
      s.add_dependency(%q<redcarpet>, ["~> 1.0"])
      s.add_dependency(%q<awesome_print>, ["~> 1.0"])
      s.add_dependency(%q<guard>, ["~> 0.10"])
      s.add_dependency(%q<guard-minitest>, ["~> 0.4"])
      s.add_dependency(%q<guard-rocco>, ["~> 0.0.3"])
      s.add_dependency(%q<activesupport>, ["< 4.1", ">= 3.0"])
      s.add_dependency(%q<actionpack>, ["< 4.1", ">= 3.0"])
      s.add_dependency(%q<railties>, ["< 4.1", ">= 3.0"])
      s.add_dependency(%q<slim>, ["~> 2.0"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 0.9"])
    s.add_dependency(%q<rocco>, ["~> 0.8"])
    s.add_dependency(%q<redcarpet>, ["~> 1.0"])
    s.add_dependency(%q<awesome_print>, ["~> 1.0"])
    s.add_dependency(%q<guard>, ["~> 0.10"])
    s.add_dependency(%q<guard-minitest>, ["~> 0.4"])
    s.add_dependency(%q<guard-rocco>, ["~> 0.0.3"])
    s.add_dependency(%q<activesupport>, ["< 4.1", ">= 3.0"])
    s.add_dependency(%q<actionpack>, ["< 4.1", ">= 3.0"])
    s.add_dependency(%q<railties>, ["< 4.1", ">= 3.0"])
    s.add_dependency(%q<slim>, ["~> 2.0"])
  end
end
