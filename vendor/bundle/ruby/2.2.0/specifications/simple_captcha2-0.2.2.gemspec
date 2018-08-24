# -*- encoding: utf-8 -*-
# stub: simple_captcha2 0.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "simple_captcha2"
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Pavlo Galeta", "Igor Galeta", "Stefan Wienert"]
  s.date = "2014-05-04"
  s.description = "SimpleCaptcha is available to be used with Rails 3 + 4 or above and also it provides the backward compatibility with previous versions of Rails."
  s.email = "stwienert@gmail.com"
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md"]
  s.homepage = "http://github.com/pludoni/simple-captcha"
  s.rubygems_version = "2.4.5"
  s.summary = "SimpleCaptcha is the simplest and a robust captcha plugin."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["< 4.1", ">= 3.1"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<capybara-mechanize>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
    else
      s.add_dependency(%q<rails>, ["< 4.1", ">= 3.1"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<capybara-mechanize>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, ["< 4.1", ">= 3.1"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<capybara-mechanize>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
  end
end
