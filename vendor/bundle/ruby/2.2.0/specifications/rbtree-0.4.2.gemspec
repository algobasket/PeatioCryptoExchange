# -*- encoding: utf-8 -*-
# stub: rbtree 0.4.2 ruby lib
# stub: extconf.rb

Gem::Specification.new do |s|
  s.name = "rbtree"
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["OZAWA Takuma"]
  s.date = "2013-12-26"
  s.description = "A RBTree is a sorted associative collection that is implemented with a\nRed-Black Tree. It maps keys to values like a Hash, but maintains its\nelements in ascending key order. The interface is the almost identical\nto that of Hash.\n"
  s.extensions = ["extconf.rb"]
  s.extra_rdoc_files = ["README", "rbtree.c"]
  s.files = ["README", "extconf.rb", "rbtree.c"]
  s.homepage = "http://rbtree.rubyforge.org/"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--title", "Ruby/RBTree", "--main", "README", "--exclude", "\\A(?!README|rbtree\\.c).*\\z"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = "rbtree"
  s.rubygems_version = "2.4.5"
  s.summary = "A sorted associative collection."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version
end
