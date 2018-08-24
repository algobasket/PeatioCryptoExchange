# -*- encoding: utf-8 -*-
# stub: active_hash 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "active_hash"
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jeff Dean", "Mike Dalessio", "Corey Innis", "Peter Jaros", "Brandon Keene", "Brian Takita", "Pat Nakajima", "John Pignata", "Michael Schubert", "Jeremy Weiskotten", "Ryan Garver", "Tom Stuart", "Joel Chippindale", "Kevin Olsen", "Vladimir Andrijevik", "Adam Anderson", "Keenan Brock", "Desmond Bowe", "Matthew O'Riordan", "Brett Richardson", "Rachel Heaton"]
  s.date = "2014-02-19"
  s.description = "Includes the ability to specify data using hashes, yml files or JSON files"
  s.email = "jeff@zilkey.com"
  s.homepage = "http://github.com/zilkey/active_hash"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "An ActiveRecord-like model that uses a hash or file as a datasource"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.2.2"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.2.2"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.2.2"])
  end
end
