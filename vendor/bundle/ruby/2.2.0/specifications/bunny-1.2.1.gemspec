# -*- encoding: utf-8 -*-
# stub: bunny 1.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "bunny"
  s.version = "1.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Chris Duncan", "Eric Lindvall", "Jakub Stastny aka botanicus", "Michael S. Klishin", "Stefan Kaes"]
  s.date = "2014-04-11"
  s.description = "Easy to use, feature complete Ruby client for RabbitMQ 2.0 and later versions."
  s.email = ["celldee@gmail.com", "eric@5stops.com", "stastny@101ideas.cz", "michael@novemberain.com", "skaes@railsexpress.de"]
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md"]
  s.homepage = "http://rubybunny.info"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Popular easy to use Ruby client for RabbitMQ"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<amq-protocol>, [">= 1.9.2"])
    else
      s.add_dependency(%q<amq-protocol>, [">= 1.9.2"])
    end
  else
    s.add_dependency(%q<amq-protocol>, [">= 1.9.2"])
  end
end
