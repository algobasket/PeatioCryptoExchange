# -*- encoding: utf-8 -*-
# stub: axiom-types 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "axiom-types"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Dan Kubb"]
  s.date = "2014-01-21"
  s.description = "Abstract types for logic programming"
  s.email = "dan.kubb@gmail.com"
  s.extra_rdoc_files = ["LICENSE", "README.md", "CONTRIBUTING.md", "TODO"]
  s.files = ["CONTRIBUTING.md", "LICENSE", "README.md", "TODO"]
  s.homepage = "https://github.com/dkubb/axiom-types"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.4.5"
  s.summary = "Define types with optional constraints for use within axiom and other libraries."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<descendants_tracker>, ["~> 0.0.3"])
      s.add_runtime_dependency(%q<ice_nine>, ["~> 0.11.0"])
      s.add_runtime_dependency(%q<thread_safe>, ["~> 0.1.3"])
      s.add_development_dependency(%q<bundler>, [">= 1.5.2", "~> 1.5"])
    else
      s.add_dependency(%q<descendants_tracker>, ["~> 0.0.3"])
      s.add_dependency(%q<ice_nine>, ["~> 0.11.0"])
      s.add_dependency(%q<thread_safe>, ["~> 0.1.3"])
      s.add_dependency(%q<bundler>, [">= 1.5.2", "~> 1.5"])
    end
  else
    s.add_dependency(%q<descendants_tracker>, ["~> 0.0.3"])
    s.add_dependency(%q<ice_nine>, ["~> 0.11.0"])
    s.add_dependency(%q<thread_safe>, ["~> 0.1.3"])
    s.add_dependency(%q<bundler>, [">= 1.5.2", "~> 1.5"])
  end
end
