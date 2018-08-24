# -*- encoding: utf-8 -*-
# stub: easy_table 0.0.6 ruby lib

Gem::Specification.new do |s|
  s.name = "easy_table"
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jakub G\u{142}uszecki"]
  s.date = "2014-01-11"
  s.description = "HTML tables made easy (in Rails 4)"
  s.email = ["jakub.gluszecki@gmail.com"]
  s.homepage = ""
  s.rubygems_version = "2.4.5"
  s.summary = "HTML tables made easy (in Rails 4)"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activemodel>, ["~> 4.0"])
      s.add_runtime_dependency(%q<actionpack>, ["~> 4.0"])
      s.add_runtime_dependency(%q<rubytree>, ["~> 0.8.3"])
    else
      s.add_dependency(%q<activemodel>, ["~> 4.0"])
      s.add_dependency(%q<actionpack>, ["~> 4.0"])
      s.add_dependency(%q<rubytree>, ["~> 0.8.3"])
    end
  else
    s.add_dependency(%q<activemodel>, ["~> 4.0"])
    s.add_dependency(%q<actionpack>, ["~> 4.0"])
    s.add_dependency(%q<rubytree>, ["~> 0.8.3"])
  end
end
