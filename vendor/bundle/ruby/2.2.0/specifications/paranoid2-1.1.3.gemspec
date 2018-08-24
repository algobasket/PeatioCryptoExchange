# -*- encoding: utf-8 -*-
# stub: paranoid2 1.1.3 ruby lib

Gem::Specification.new do |s|
  s.name = "paranoid2"
  s.version = "1.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["yury"]
  s.date = "2013-05-23"
  s.description = "paranoid models for rails 4"
  s.email = ["yury.korolev@gmail.com"]
  s.homepage = "https://github.com/anjlab/paranoid2"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "paranoid models for rails 4"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 4.0.0.rc1"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 4.0.0.rc1"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 4.0.0.rc1"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
