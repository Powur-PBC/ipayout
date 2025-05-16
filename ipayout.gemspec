# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ipayout/version'

Gem::Specification.new do |spec|
  spec.name          = 'ipayout'
  spec.version       = Ipayout::VERSION
  spec.authors       = ['Danny mcalerney']
  spec.email         = ['danny.mcalerney@eyecuelab.com']
  spec.summary       = ['Integrate the iPayout eWallet API with your ROR app']
  spec.description   = ['coming soon....']
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files = Dir['lib/**/*'] + ['Rakefile', 'README.md']
  spec.test_files = Dir['spec/**/*']
  # spec.files         = `git ls-files -z`.split("\x0")
  # spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  # spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  # spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'factory_girl_rails', '~> 4.0'
  spec.add_dependency 'hashie'
  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday-mashify'
  spec.add_dependency 'multi_json'
  spec.add_dependency 'extlib'
  spec.add_dependency 'pry-rails'
end
