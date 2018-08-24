# -*- encoding: utf-8 -*-
# stub: bootstrap-wysihtml5-rails 0.3.1.23 ruby lib

Gem::Specification.new do |s|
  s.name = "bootstrap-wysihtml5-rails"
  s.version = "0.3.1.23"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gonzalo Rodr\u{ed}guez-Baltan\u{e1}s D\u{ed}az"]
  s.date = "2013-09-02"
  s.description = "A wysiwyg text editor for Twitter Bootstrap"
  s.email = ["siotopo@gmail.com"]
  s.homepage = "https://github.com/Nerian/bootstrap-wysihtml5-rails"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "A wysiwyg text editor for Twitter Bootstrap"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, [">= 3.0"])
      s.add_development_dependency(%q<bundler>, [">= 1.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<railties>, [">= 3.0"])
      s.add_dependency(%q<bundler>, [">= 1.0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<railties>, [">= 3.0"])
    s.add_dependency(%q<bundler>, [">= 1.0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
