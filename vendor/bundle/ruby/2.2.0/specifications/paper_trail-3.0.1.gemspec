# -*- encoding: utf-8 -*-
# stub: paper_trail 3.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "paper_trail"
  s.version = "3.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Andy Stewart", "Ben Atkins"]
  s.date = "2014-03-14"
  s.description = "Track changes to your models' data. Good for auditing or versioning."
  s.email = "batkinz@gmail.com"
  s.homepage = "https://github.com/airblade/paper_trail"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Track changes to your models' data. Good for auditing or versioning."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["< 5.0", ">= 3.0"])
      s.add_runtime_dependency(%q<activesupport>, ["< 5.0", ">= 3.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, ["~> 3.5"])
      s.add_development_dependency(%q<ffaker>, [">= 1.15"])
      s.add_development_dependency(%q<railties>, ["< 5.0", ">= 3.0"])
      s.add_development_dependency(%q<sinatra>, ["~> 1.0"])
      s.add_development_dependency(%q<rack-test>, [">= 0.6"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.14"])
      s.add_development_dependency(%q<generator_spec>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, ["~> 1.2"])
    else
      s.add_dependency(%q<activerecord>, ["< 5.0", ">= 3.0"])
      s.add_dependency(%q<activesupport>, ["< 5.0", ">= 3.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<shoulda>, ["~> 3.5"])
      s.add_dependency(%q<ffaker>, [">= 1.15"])
      s.add_dependency(%q<railties>, ["< 5.0", ">= 3.0"])
      s.add_dependency(%q<sinatra>, ["~> 1.0"])
      s.add_dependency(%q<rack-test>, [">= 0.6"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.14"])
      s.add_dependency(%q<generator_spec>, [">= 0"])
      s.add_dependency(%q<sqlite3>, ["~> 1.2"])
    end
  else
    s.add_dependency(%q<activerecord>, ["< 5.0", ">= 3.0"])
    s.add_dependency(%q<activesupport>, ["< 5.0", ">= 3.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<shoulda>, ["~> 3.5"])
    s.add_dependency(%q<ffaker>, [">= 1.15"])
    s.add_dependency(%q<railties>, ["< 5.0", ">= 3.0"])
    s.add_dependency(%q<sinatra>, ["~> 1.0"])
    s.add_dependency(%q<rack-test>, [">= 0.6"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.14"])
    s.add_dependency(%q<generator_spec>, [">= 0"])
    s.add_dependency(%q<sqlite3>, ["~> 1.2"])
  end
end
