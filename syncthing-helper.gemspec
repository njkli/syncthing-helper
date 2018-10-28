
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "syncthing/helper/version"

Gem::Specification.new do |spec|
  spec.name          = "syncthing-helper"
  spec.version       = Syncthing::Helper::VERSION
  spec.authors       = ["voobscout"]
  spec.email         = ["voobscout+syncthing.helper@gmail.com"]

  spec.summary       = %q{syncthing-helper semi-automates management of multiple installs on NixOS}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/njkli/syncthing-helper"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "https://rubygems.org"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = ['syncthing-helper']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"

  # spec.add_dependency 'rom'
  # spec.add_dependency 'rom-sql'
  # spec.add_dependency 'rom-repository'
  # spec.add_dependency 'sqlite3'

  # spec.add_dependency 'rom-yaml'
  # spec.add_dependency 'rom-json'
  # spec.add_dependency 'rom-relation'
  # spec.add_dependency 'rom-mapper'
  # spec.add_dependency 'rom-repository'
  # spec.add_dependency 'rom-changeset'

  # spec.add_dependency 'rom-model'

  spec.add_dependency 'semantic_logger'
  spec.add_dependency 'activesupport'
  spec.add_dependency "tty-table"
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'roxml'
  spec.add_dependency 'multi_json'
  spec.add_dependency 'roar'
  spec.add_dependency 'concurrent-ruby'
  spec.add_dependency 'rio'
  spec.add_dependency 'clamp'
  spec.add_dependency 'google-cloud-firestore'
  spec.add_dependency 'google-cloud-pubsub'
end
