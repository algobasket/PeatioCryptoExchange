# -*- encoding: utf-8 -*-
# stub: daemons-rails 1.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "daemons-rails"
  s.version = "1.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["mirasrael"]
  s.date = "2013-08-23"
  s.description = "daemonization support for Rails 3+"
  s.email = []
  s.homepage = ""
  s.licenses = ["MIT", "GPL-2"]
  s.rubygems_version = "2.4.5"
  s.summary = "daemonization support for Rails 3+"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<daemons>, [">= 0"])
      s.add_runtime_dependency(%q<multi_json>, ["~> 1.0"])
      s.add_development_dependency(%q<rails>, [">= 3.0.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.12"])
    else
      s.add_dependency(%q<daemons>, [">= 0"])
      s.add_dependency(%q<multi_json>, ["~> 1.0"])
      s.add_dependency(%q<rails>, [">= 3.0.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.12"])
    end
  else
    s.add_dependency(%q<daemons>, [">= 0"])
    s.add_dependency(%q<multi_json>, ["~> 1.0"])
    s.add_dependency(%q<rails>, [">= 3.0.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.12"])
  end
end
