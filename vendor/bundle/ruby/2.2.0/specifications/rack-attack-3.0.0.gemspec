# -*- encoding: utf-8 -*-
# stub: rack-attack 3.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rack-attack"
  s.version = "3.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Aaron Suggs"]
  s.date = "2014-03-15"
  s.description = "A rack middleware for throttling and blocking abusive requests"
  s.email = "aaron@ktheory.com"
  s.homepage = "http://github.com/kickstarter/rack-attack"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "2.4.5"
  s.summary = "Block & throttle abusive requests"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_development_dependency(%q<redis-activesupport>, [">= 0"])
      s.add_development_dependency(%q<dalli>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_dependency(%q<redis-activesupport>, [">= 0"])
      s.add_dependency(%q<dalli>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 3.0.0"])
    s.add_dependency(%q<redis-activesupport>, [">= 0"])
    s.add_dependency(%q<dalli>, [">= 0"])
  end
end
