# -*- encoding: utf-8 -*-
# stub: twilio-ruby 5.7.2 ruby lib

Gem::Specification.new do |s|
  s.name = "twilio-ruby"
  s.version = "5.7.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.metadata = { "yard.run" => "yri" } if s.respond_to? :metadata=
  s.require_paths = ["lib"]
  s.authors = ["Twilio API Team"]
  s.date = "2018-03-22"
  s.description = "A simple library for communicating with the Twilio REST API, building TwiML, and generating Twilio JWT Capability Tokens"
  s.extra_rdoc_files = ["README.md", "LICENSE.md"]
  s.files = ["LICENSE.md", "README.md"]
  s.homepage = "http://github.com/twilio/twilio-ruby"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "twilio-ruby", "--main", "README.md"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0")
  s.rubygems_version = "2.4.5"
  s.summary = "A simple library for communicating with the Twilio REST API, building TwiML, and generating Twilio JWT Capability Tokens"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jwt>, ["<= 2.5", ">= 1.5"])
      s.add_runtime_dependency(%q<nokogiri>, ["< 2.0", ">= 1.6"])
      s.add_runtime_dependency(%q<faraday>, ["~> 0.9"])
      s.add_development_dependency(%q<bundler>, ["~> 1.5"])
      s.add_development_dependency(%q<rubocop>, ["~> 0.49.1"])
      s.add_development_dependency(%q<yard>, ["~> 0.9.9"])
    else
      s.add_dependency(%q<jwt>, ["<= 2.5", ">= 1.5"])
      s.add_dependency(%q<nokogiri>, ["< 2.0", ">= 1.6"])
      s.add_dependency(%q<faraday>, ["~> 0.9"])
      s.add_dependency(%q<bundler>, ["~> 1.5"])
      s.add_dependency(%q<rubocop>, ["~> 0.49.1"])
      s.add_dependency(%q<yard>, ["~> 0.9.9"])
    end
  else
    s.add_dependency(%q<jwt>, ["<= 2.5", ">= 1.5"])
    s.add_dependency(%q<nokogiri>, ["< 2.0", ">= 1.6"])
    s.add_dependency(%q<faraday>, ["~> 0.9"])
    s.add_dependency(%q<bundler>, ["~> 1.5"])
    s.add_dependency(%q<rubocop>, ["~> 0.49.1"])
    s.add_dependency(%q<yard>, ["~> 0.9.9"])
  end
end
