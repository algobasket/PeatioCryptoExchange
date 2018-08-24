# -*- encoding: utf-8 -*-
# stub: phonelib 0.3.5 ruby lib

Gem::Specification.new do |s|
  s.name = "phonelib"
  s.version = "0.3.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Vadim Senderovich"]
  s.date = "2014-10-28"
  s.description = "    Google libphonenumber library was taken as a basis for\n    this gem. Gem uses its data file for validations and number formatting.\n"
  s.email = ["daddyzgm@gmail.com"]
  s.homepage = "https://github.com/daddyz/phonelib"
  s.licenses = ["MIT"]
  s.post_install_message = "    IMPORTANT NOTICE!\n    Phone types were changed from camel case to snake case!\n    Example: \":tollFree\" changed to \":toll_free\".\n    Please update your app in case you are checking types!\n"
  s.rubygems_version = "2.4.5"
  s.summary = "Gem validates phone numbers with Google libphonenumber database"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["= 2.14.1"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<rspec>, ["= 2.14.1"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<rspec>, ["= 2.14.1"])
  end
end
