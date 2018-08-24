# -*- encoding: utf-8 -*-
# stub: doorkeeper 1.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "doorkeeper"
  s.version = "1.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Felipe Elias Philipp", "Piotr Jakubowski"]
  s.date = "2014-12-17"
  s.description = "Doorkeeper is an OAuth 2 provider for Rails."
  s.email = ["felipe@applicake.com", "piotr.jakubowski@applicake.com"]
  s.homepage = "https://github.com/doorkeeper-gem/doorkeeper"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Doorkeeper is an OAuth 2 provider for Rails."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, [">= 3.1"])
      s.add_development_dependency(%q<sqlite3>, ["~> 1.3.5"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.99.0"])
      s.add_development_dependency(%q<capybara>, ["~> 2.3.0"])
      s.add_development_dependency(%q<generator_spec>, ["~> 0.9.0"])
      s.add_development_dependency(%q<factory_girl>, ["~> 4.4.0"])
      s.add_development_dependency(%q<timecop>, ["~> 0.7.0"])
      s.add_development_dependency(%q<database_cleaner>, ["~> 1.3.0"])
      s.add_development_dependency(%q<rspec-activemodel-mocks>, ["~> 1.0.0"])
      s.add_development_dependency(%q<bcrypt-ruby>, ["~> 3.0.1"])
      s.add_development_dependency(%q<pry>, ["~> 0.10.0"])
    else
      s.add_dependency(%q<railties>, [">= 3.1"])
      s.add_dependency(%q<sqlite3>, ["~> 1.3.5"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.99.0"])
      s.add_dependency(%q<capybara>, ["~> 2.3.0"])
      s.add_dependency(%q<generator_spec>, ["~> 0.9.0"])
      s.add_dependency(%q<factory_girl>, ["~> 4.4.0"])
      s.add_dependency(%q<timecop>, ["~> 0.7.0"])
      s.add_dependency(%q<database_cleaner>, ["~> 1.3.0"])
      s.add_dependency(%q<rspec-activemodel-mocks>, ["~> 1.0.0"])
      s.add_dependency(%q<bcrypt-ruby>, ["~> 3.0.1"])
      s.add_dependency(%q<pry>, ["~> 0.10.0"])
    end
  else
    s.add_dependency(%q<railties>, [">= 3.1"])
    s.add_dependency(%q<sqlite3>, ["~> 1.3.5"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.99.0"])
    s.add_dependency(%q<capybara>, ["~> 2.3.0"])
    s.add_dependency(%q<generator_spec>, ["~> 0.9.0"])
    s.add_dependency(%q<factory_girl>, ["~> 4.4.0"])
    s.add_dependency(%q<timecop>, ["~> 0.7.0"])
    s.add_dependency(%q<database_cleaner>, ["~> 1.3.0"])
    s.add_dependency(%q<rspec-activemodel-mocks>, ["~> 1.0.0"])
    s.add_dependency(%q<bcrypt-ruby>, ["~> 3.0.1"])
    s.add_dependency(%q<pry>, ["~> 0.10.0"])
  end
end
