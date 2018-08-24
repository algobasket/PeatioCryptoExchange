# -*- encoding: utf-8 -*-
# stub: temple 0.6.7 ruby lib

Gem::Specification.new do |s|
  s.name = "temple"
  s.version = "0.6.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Magnus Holm", "Daniel Mendler"]
  s.date = "2013-09-30"
  s.email = ["judofyr@gmail.com", "mail@daniel-mendler.de"]
  s.homepage = "https://github.com/judofyr/temple"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Template compilation framework in Ruby"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<tilt>, [">= 0"])
      s.add_development_dependency(%q<bacon>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<tilt>, [">= 0"])
      s.add_dependency(%q<bacon>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<tilt>, [">= 0"])
    s.add_dependency(%q<bacon>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
