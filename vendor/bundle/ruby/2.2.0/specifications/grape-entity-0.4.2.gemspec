# -*- encoding: utf-8 -*-
# stub: grape-entity 0.4.2 ruby lib

Gem::Specification.new do |s|
  s.name = "grape-entity"
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Michael Bleigh"]
  s.date = "2014-04-03"
  s.description = "Extracted from Grape, A Ruby framework for rapid API development with great conventions."
  s.email = ["michael@intridea.com"]
  s.homepage = "https://github.com/intridea/grape-entity"
  s.licenses = ["MIT"]
  s.rubyforge_project = "grape-entity"
  s.rubygems_version = "2.4.5"
  s.summary = "A simple facade for managing the relationship between your model and API."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<multi_json>, [">= 1.3.2"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<maruku>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.9"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<multi_json>, [">= 1.3.2"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<maruku>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.9"])
      s.add_dependency(%q<bundler>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<multi_json>, [">= 1.3.2"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<maruku>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.9"])
    s.add_dependency(%q<bundler>, [">= 0"])
  end
end
