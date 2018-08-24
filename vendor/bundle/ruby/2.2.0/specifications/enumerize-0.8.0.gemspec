# -*- encoding: utf-8 -*-
# stub: enumerize 0.8.0 ruby lib

Gem::Specification.new do |s|
  s.name = "enumerize"
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Sergey Nartimov"]
  s.date = "2014-03-04"
  s.description = "Enumerated attributes with I18n and ActiveRecord/Mongoid/MongoMapper support"
  s.email = "team@brainspec.com"
  s.homepage = "https://github.com/brainspec/enumerize"
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.4.5"
  s.summary = "Enumerated attributes with I18n and ActiveRecord/Mongoid/MongoMapper support"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 3.2"])
    else
      s.add_dependency(%q<activesupport>, [">= 3.2"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 3.2"])
  end
end
