# -*- encoding: utf-8 -*-
# stub: http_accept_language 2.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "http_accept_language"
  s.version = "2.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["iain"]
  s.date = "2014-01-23"
  s.description = "Find out which locale the user preferes by reading the languages they specified in their browser"
  s.email = ["iain@iain.nl"]
  s.homepage = "https://github.com/iain/http_accept_language"
  s.licenses = ["MIT"]
  s.rubyforge_project = "http_accept_language"
  s.rubygems_version = "2.4.5"
  s.summary = "Find out which locale the user preferes by reading the languages they specified in their browser"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
      s.add_development_dependency(%q<rails>, [">= 3.2.6"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<aruba>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 3.2.6"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<aruba>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 3.2.6"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<aruba>, [">= 0"])
  end
end
