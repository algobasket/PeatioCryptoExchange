# -*- encoding: utf-8 -*-
# stub: cancancan 1.7.1 ruby lib

Gem::Specification.new do |s|
  s.name = "cancancan"
  s.version = "1.7.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.4") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Bryan Rite", "Ryan Bates"]
  s.date = "2014-03-19"
  s.description = "Continuation of the simple authorization solution for Rails which is decoupled from user roles. All permissions are stored in a single location."
  s.email = "bryan@bryanrite.com"
  s.homepage = "https://github.com/CanCanCommunity/cancancan"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubyforge_project = "cancancan"
  s.rubygems_version = "2.4.5"
  s.summary = "Simple authorization solution for Rails."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.14"])
      s.add_development_dependency(%q<supermodel>, ["~> 0.1.6"])
      s.add_development_dependency(%q<appraisal>, [">= 1.0.0.beta3"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.14"])
      s.add_dependency(%q<supermodel>, ["~> 0.1.6"])
      s.add_dependency(%q<appraisal>, [">= 1.0.0.beta3"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.14"])
    s.add_dependency(%q<supermodel>, ["~> 0.1.6"])
    s.add_dependency(%q<appraisal>, [">= 1.0.0.beta3"])
  end
end
