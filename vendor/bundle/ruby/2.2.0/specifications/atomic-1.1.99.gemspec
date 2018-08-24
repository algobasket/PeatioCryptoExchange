# -*- encoding: utf-8 -*-
# stub: atomic 1.1.99 ruby lib
# stub: ext/extconf.rb

Gem::Specification.new do |s|
  s.name = "atomic"
  s.version = "1.1.99"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Charles Oliver Nutter", "MenTaLguY", "Sokolov Yura"]
  s.date = "2015-01-26"
  s.description = "An atomic reference implementation for JRuby, Rubinius, and MRI"
  s.email = ["headius@headius.com", "mental@rydia.net", "funny.falcon@gmail.com"]
  s.extensions = ["ext/extconf.rb"]
  s.files = ["ext/extconf.rb"]
  s.homepage = "http://github.com/ruby-concurrency/ruby-atomic"
  s.licenses = ["Apache-2.0"]
  s.post_install_message = "This gem has been deprecated and merged into Concurrent Ruby (http://concurrent-ruby.com)."
  s.rubygems_version = "2.4.5"
  s.summary = "An atomic reference implementation for JRuby, Rubinius, and MRI"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version
end
