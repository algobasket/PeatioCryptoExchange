# -*- encoding: utf-8 -*-
# stub: rack-accept 0.4.5 ruby lib

Gem::Specification.new do |s|
  s.name = "rack-accept"
  s.version = "0.4.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Michael Jackson"]
  s.date = "2012-06-15"
  s.description = "HTTP Accept, Accept-Charset, Accept-Encoding, and Accept-Language for Ruby/Rack"
  s.email = "mjijackson@gmail.com"
  s.extra_rdoc_files = ["CHANGES", "README.md"]
  s.files = ["CHANGES", "README.md"]
  s.homepage = "http://mjijackson.github.com/rack-accept"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Rack::Accept", "--main", "Rack::Accept"]
  s.rubygems_version = "2.4.5"
  s.summary = "HTTP Accept* for Ruby/Rack"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0.4"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0.4"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0.4"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
