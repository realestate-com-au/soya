lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "soya/version"

Gem::Specification.new do |s|
  s.name          = 'soya'
  s.version       = Soya::VERSION
  s.authors       = ['Edmund Lam']
  s.email         = 'edmund.lam@rea-group.com'
  s.licenses      = 'MIT'
  s.homepage      = 'https://github.com/realestate-com-au/soya'
  s.files         = Dir['bin/*', 'lib/**/*']
  s.executables   = ['soya']
  s.require_paths = ['lib']
  s.summary       = 'YAML/JSON file toolkit'
  s.description   = 'Handle YAML/JSON in a Unix-like manner, designed to assist in deployment and configuration management'
  s.add_runtime_dependency('safe_yaml', '~> 1.0')
  s.add_development_dependency('bundler', '~> 1.3')
  s.add_development_dependency('rake', '~> 10.0')
end
