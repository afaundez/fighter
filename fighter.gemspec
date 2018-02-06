
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fighter/version'

Gem::Specification.new do |spec|
  spec.name          = 'fighter'
  spec.version       = Fighter::VERSION
  spec.authors       = ['Alvaro Faundez']
  spec.email         = ['alvaro@faundez.net']

  spec.summary       = %q{Fighter will fight for your.}
  spec.description   = %q{Fighter gives you a reusable development workspace.}
  spec.homepage      = 'https://github.com/afaundez/fighter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1.19'

  spec.add_runtime_dependency 'thor', '~> 0.20.0'
end
