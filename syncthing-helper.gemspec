
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
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/syncthing-helper}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"

  # spec.add_dependency 'rest-client'
  # spec.add_dependency 'wrest'
  # spec.add_dependency 'virtus'
  # spec.add_dependency 'dry-struct'
  # spec.add_dependency 'virtus-relations'
  # spec.add_dependency 'activeresource'
  # spec.add_dependency 'saxy'
  # spec.add_dependency 'hashie'
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
