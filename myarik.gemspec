lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "myarik/version"

Gem::Specification.new do |spec|
  spec.name          = "myarik"
  spec.version       = Myarik::VERSION
  spec.authors       = ["Civitaspo"]
  spec.email         = ["civitaspo@gmail.com"]

  spec.summary       = %q{A Codenize Tool for Redash}
  spec.description   = %q{A Codenize Tool for Redash}
  spec.homepage      = "https://github.com/civitaspo/myarik"
  spec.license       = "MIT"
 
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Auto generated dependencies by codenize-tools/codenize
  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency 'diffy'
  spec.add_dependency 'dslh', '>= 0.4.6'
  spec.add_dependency 'hashie'
  spec.add_dependency 'kwalify'
  #spec.add_dependency 'parallel'
  #spec.add_dependency 'pp_sort_hash'
  spec.add_dependency 'term-ansicolor'
  spec.add_dependency 'thor'

  # myarik dependencies
  spec.add_development_dependency 'pry'
  spec.add_dependency 'faraday', '>= 0.15.4'
  spec.add_dependency 'faraday_middleware', '>= 0.13.1'
  spec.add_dependency 'abstriker', '>= 0.1.3'
  spec.add_dependency 'overrider', '>= 0.1.5'
  spec.add_dependency 'finalist', '>= 0.1.4'
end
