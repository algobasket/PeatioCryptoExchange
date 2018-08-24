# -*- encoding: utf-8 -*-
# stub: rack-mount 0.8.3 ruby lib

Gem::Specification.new do |s|
  s.name = "rack-mount"
  s.version = "0.8.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Joshua Peek"]
  s.date = "2011-08-30"
  s.description = "    A stackable dynamic tree based Rack router.\n"
  s.email = "josh@joshpeek.com"
  s.homepage = "https://github.com/josh/rack-mount"
  s.rubygems_version = "2.4.5"
  s.summary = "Stackable dynamic tree based Rack router"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 1.0.0"])
      s.add_development_dependency(%q<racc>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rexical>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 1.0.0"])
      s.add_dependency(%q<racc>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rexical>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 1.0.0"])
    s.add_dependency(%q<racc>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rexical>, [">= 0"])
  end
end
