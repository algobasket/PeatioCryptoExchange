# -*- encoding: utf-8 -*-
# stub: liability-proof 0.0.9 ruby lib

Gem::Specification.new do |s|
  s.name = "liability-proof"
  s.version = "0.0.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Peatio Opensource"]
  s.date = "2014-04-18"
  s.description = "Check https://iwilcox.me.uk/2014/proving-bitcoin-reserves for more details."
  s.email = ["community@peatio.com"]
  s.executables = ["lproof"]
  s.files = ["bin/lproof"]
  s.homepage = "https://github.com/peatio/liability-proof"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "An implementation of Greg Maxwell's Merkle approach to prove Bitcoin liabilities."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<awesome_print>, [">= 0"])
    else
      s.add_dependency(%q<awesome_print>, [">= 0"])
    end
  else
    s.add_dependency(%q<awesome_print>, [">= 0"])
  end
end
