# -*- encoding: utf-8 -*-
# stub: signature 0.1.7 ruby lib

Gem::Specification.new do |s|
  s.name = "signature"
  s.version = "0.1.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Martyn Loughran"]
  s.date = "2013-04-22"
  s.description = "Simple key/secret based authentication for apis"
  s.email = ["me@mloughran.com"]
  s.homepage = "http://github.com/mloughran/signature"
  s.rubygems_version = "2.4.5"
  s.summary = "Simple key/secret based authentication for apis"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<em-spec>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<em-spec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<em-spec>, [">= 0"])
  end
end
