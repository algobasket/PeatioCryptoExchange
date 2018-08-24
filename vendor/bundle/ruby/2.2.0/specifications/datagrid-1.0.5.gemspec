# -*- encoding: utf-8 -*-
# stub: datagrid 1.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "datagrid"
  s.version = "1.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Bogdan Gusiev"]
  s.date = "2014-01-15"
  s.description = "This allows you to easily build datagrid aka data tables with sortable columns and filters"
  s.email = "agresso@gmail.com"
  s.extra_rdoc_files = ["LICENSE.txt"]
  s.files = ["LICENSE.txt"]
  s.homepage = "http://github.com/bogdan/datagrid"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Ruby gem to create datagrids"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<debugger>, [">= 0"])
      s.add_development_dependency(%q<byebug>, [">= 0"])
      s.add_development_dependency(%q<ruby-debug>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_development_dependency(%q<mongoid>, ["= 2.2.2"])
      s.add_development_dependency(%q<mongo_mapper>, [">= 0.11.0"])
      s.add_development_dependency(%q<bson>, ["= 1.4.0"])
      s.add_development_dependency(%q<bson_ext>, ["= 1.4.0"])
      s.add_development_dependency(%q<fastercsv>, [">= 0"])
    else
      s.add_dependency(%q<rails>, [">= 3.0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<debugger>, [">= 0"])
      s.add_dependency(%q<byebug>, [">= 0"])
      s.add_dependency(%q<ruby-debug>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_dependency(%q<mongoid>, ["= 2.2.2"])
      s.add_dependency(%q<mongo_mapper>, [">= 0.11.0"])
      s.add_dependency(%q<bson>, ["= 1.4.0"])
      s.add_dependency(%q<bson_ext>, ["= 1.4.0"])
      s.add_dependency(%q<fastercsv>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<debugger>, [">= 0"])
    s.add_dependency(%q<byebug>, [">= 0"])
    s.add_dependency(%q<ruby-debug>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
    s.add_dependency(%q<mongoid>, ["= 2.2.2"])
    s.add_dependency(%q<mongo_mapper>, [">= 0.11.0"])
    s.add_dependency(%q<bson>, ["= 1.4.0"])
    s.add_dependency(%q<bson_ext>, ["= 1.4.0"])
    s.add_dependency(%q<fastercsv>, [">= 0"])
  end
end
