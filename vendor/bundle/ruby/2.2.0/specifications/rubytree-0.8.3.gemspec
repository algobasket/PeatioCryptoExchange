# -*- encoding: utf-8 -*-
# stub: rubytree 0.8.3 ruby lib

Gem::Specification.new do |s|
  s.name = "rubytree"
  s.version = "0.8.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Anupam Sengupta"]
  s.date = "2012-08-21"
  s.description = "    RubyTree is a Ruby implementation of the generic tree data structure.\n    It provides a node-based model to store uniquely identifiable node-elements in\n    the tree and simple APIs to access, modify and traverse the structure.\n    RubyTree is node-centric, where individual nodes on the tree are the primary\n    compositional and structural elements.\n\n    This implementation also mixes in the Enumerable module to allow standard\n    access to the tree as a collection.\n"
  s.email = "anupamsg@gmail.com"
  s.extra_rdoc_files = ["README.rdoc", "COPYING.rdoc", "API-CHANGES.rdoc", "History.rdoc"]
  s.files = ["API-CHANGES.rdoc", "COPYING.rdoc", "History.rdoc", "README.rdoc"]
  s.homepage = "http://rubytree.rubyforge.org"
  s.licenses = ["BSD"]
  s.post_install_message = "    ========================================================================\n                    Thank you for installing rubytree.\n\n    Note that the TreeNode#siblings method has changed in 0.8.3.\n    It now returns an empty array for the root node.\n\n                 WARNING: SIGNIFICANT API CHANGE in 0.8.0 !\n                 ------------------------------------------\n\n    Please note that as of 0.8.0 the CamelCase method names are DEPRECATED.\n    The new method names follow the ruby_convention (separated by '_').\n\n    The old CamelCase methods still work (a warning will be displayed),\n    but may go away in the future.\n\n    Details of the API changes are documented in the API-CHANGES file.\n    ========================================================================\n"
  s.rdoc_options = ["--title", "Rubytree Documentation", "--quiet"]
  s.rubyforge_project = "rubytree"
  s.rubygems_version = "2.4.5"
  s.summary = "A generic tree data structure."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<structured_warnings>, [">= 0.1.3"])
      s.add_runtime_dependency(%q<json>, [">= 1.7.5"])
      s.add_development_dependency(%q<rake>, [">= 0.9.2.2"])
      s.add_development_dependency(%q<yard>, [">= 0.8.2.1"])
      s.add_development_dependency(%q<rtagstask>, [">= 0.0.4"])
      s.add_development_dependency(%q<rcov>, ["~> 0.9.0"])
    else
      s.add_dependency(%q<structured_warnings>, [">= 0.1.3"])
      s.add_dependency(%q<json>, [">= 1.7.5"])
      s.add_dependency(%q<rake>, [">= 0.9.2.2"])
      s.add_dependency(%q<yard>, [">= 0.8.2.1"])
      s.add_dependency(%q<rtagstask>, [">= 0.0.4"])
      s.add_dependency(%q<rcov>, ["~> 0.9.0"])
    end
  else
    s.add_dependency(%q<structured_warnings>, [">= 0.1.3"])
    s.add_dependency(%q<json>, [">= 1.7.5"])
    s.add_dependency(%q<rake>, [">= 0.9.2.2"])
    s.add_dependency(%q<yard>, [">= 0.8.2.1"])
    s.add_dependency(%q<rtagstask>, [">= 0.0.4"])
    s.add_dependency(%q<rcov>, ["~> 0.9.0"])
  end
end
