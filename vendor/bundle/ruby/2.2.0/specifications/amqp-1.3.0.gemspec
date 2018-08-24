# -*- encoding: utf-8 -*-
# stub: amqp 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "amqp"
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Aman Gupta", "Jakub Stastny aka botanicus", "Michael S. Klishin"]
  s.date = "2014-02-03"
  s.description = "Widely used, feature-rich asynchronous RabbitMQ client with batteries included."
  s.email = ["michael@novemberain.com", "stastny@101ideas.cz"]
  s.extra_rdoc_files = ["README.md", "docs/08Migration.textile", "docs/AMQP091ModelExplained.textile", "docs/Bindings.textile", "docs/Clustering.textile", "docs/ConnectingToTheBroker.textile", "docs/ConnectionEncryptionWithTLS.textile", "docs/DocumentationGuidesIndex.textile", "docs/Durability.textile", "docs/ErrorHandling.textile", "docs/Exchanges.textile", "docs/GettingStarted.textile", "docs/PatternsAndUseCases.textile", "docs/Queues.textile", "docs/RabbitMQVersions.textile", "docs/RunningTests.textile", "docs/TestingWithEventedSpec.textile", "docs/Troubleshooting.textile", "docs/VendorSpecificExtensions.textile"]
  s.files = ["README.md", "docs/08Migration.textile", "docs/AMQP091ModelExplained.textile", "docs/Bindings.textile", "docs/Clustering.textile", "docs/ConnectingToTheBroker.textile", "docs/ConnectionEncryptionWithTLS.textile", "docs/DocumentationGuidesIndex.textile", "docs/Durability.textile", "docs/ErrorHandling.textile", "docs/Exchanges.textile", "docs/GettingStarted.textile", "docs/PatternsAndUseCases.textile", "docs/Queues.textile", "docs/RabbitMQVersions.textile", "docs/RunningTests.textile", "docs/TestingWithEventedSpec.textile", "docs/Troubleshooting.textile", "docs/VendorSpecificExtensions.textile"]
  s.homepage = "http://rubyamqp.info"
  s.licenses = ["Ruby"]
  s.rdoc_options = ["--include=examples --main README.md"]
  s.rubyforge_project = "amqp"
  s.rubygems_version = "2.4.5"
  s.summary = "Widely used, feature-rich asynchronous RabbitMQ client with batteries included"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<eventmachine>, [">= 0"])
      s.add_runtime_dependency(%q<amq-protocol>, [">= 1.9.2"])
    else
      s.add_dependency(%q<eventmachine>, [">= 0"])
      s.add_dependency(%q<amq-protocol>, [">= 1.9.2"])
    end
  else
    s.add_dependency(%q<eventmachine>, [">= 0"])
    s.add_dependency(%q<amq-protocol>, [">= 1.9.2"])
  end
end
