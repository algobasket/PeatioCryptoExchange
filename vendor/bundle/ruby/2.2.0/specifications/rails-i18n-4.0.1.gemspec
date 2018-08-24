# -*- encoding: utf-8 -*-
# stub: rails-i18n 4.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "rails-i18n"
  s.version = "4.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Rails I18n Group"]
  s.date = "2013-12-19"
  s.description = "A set of common locale data and translations to internationalize and/or localize your Rails applications."
  s.email = "rails-i18n@googlegroups.com"
  s.homepage = "http://github.com/svenfuchs/rails-i18n"
  s.licenses = ["MIT"]
  s.rubyforge_project = "[none]"
  s.rubygems_version = "2.4.5"
  s.summary = "Common locale data and translations for Rails i18n."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<i18n>, ["~> 0.6"])
      s.add_runtime_dependency(%q<rails>, ["~> 4.0"])
      s.add_development_dependency(%q<rails>, ["= 4.0.2"])
      s.add_development_dependency(%q<rspec-rails>, ["= 2.14.0"])
      s.add_development_dependency(%q<i18n-spec>, ["= 0.4.0"])
      s.add_development_dependency(%q<spork>, ["= 1.0.0rc3"])
    else
      s.add_dependency(%q<i18n>, ["~> 0.6"])
      s.add_dependency(%q<rails>, ["~> 4.0"])
      s.add_dependency(%q<rails>, ["= 4.0.2"])
      s.add_dependency(%q<rspec-rails>, ["= 2.14.0"])
      s.add_dependency(%q<i18n-spec>, ["= 0.4.0"])
      s.add_dependency(%q<spork>, ["= 1.0.0rc3"])
    end
  else
    s.add_dependency(%q<i18n>, ["~> 0.6"])
    s.add_dependency(%q<rails>, ["~> 4.0"])
    s.add_dependency(%q<rails>, ["= 4.0.2"])
    s.add_dependency(%q<rspec-rails>, ["= 2.14.0"])
    s.add_dependency(%q<i18n-spec>, ["= 0.4.0"])
    s.add_dependency(%q<spork>, ["= 1.0.0rc3"])
  end
end
