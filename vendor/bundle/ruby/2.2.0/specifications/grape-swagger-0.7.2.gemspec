# -*- encoding: utf-8 -*-
# stub: grape-swagger 0.7.2 ruby lib

Gem::Specification.new do |s|
  s.name = "grape-swagger"
  s.version = "0.7.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Tim Vandecasteele"]
  s.date = "2014-02-06"
  s.description = "A simple way to add proper auto generated documentation - that can be displayed with swagger - to your inline described grape API"
  s.email = "tim.vandecasteele@gmail.com"
  s.extra_rdoc_files = ["LICENSE.txt", "README.markdown"]
  s.files = ["LICENSE.txt", "README.markdown"]
  s.homepage = "http://github.com/tim-vandecasteele/grape-swagger"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Add swagger compliant documentation to your grape API"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<grape>, [">= 0.2.0"])
      s.add_runtime_dependency(%q<grape-entity>, [">= 0.3.0"])
      s.add_runtime_dependency(%q<kramdown>, [">= 1.3.1"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<grape>, [">= 0.2.0"])
      s.add_dependency(%q<grape-entity>, [">= 0.3.0"])
      s.add_dependency(%q<kramdown>, [">= 1.3.1"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<grape>, [">= 0.2.0"])
    s.add_dependency(%q<grape-entity>, [">= 0.3.0"])
    s.add_dependency(%q<kramdown>, [">= 1.3.1"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
