Gem::Specification.new do |spec|
  spec.name          = 'grape-pagy'
  spec.version       = '0.5.0'
  spec.authors       = ['Black Square Media']
  spec.email         = ['info@blacksquaremedia.com']
  spec.description   = 'Pagy paginator for grape API'
  spec.summary       = ''
  spec.homepage      = ''
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.start_with?('spec/') }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.0'

  spec.add_runtime_dependency 'grape', '>= 1.5'
  spec.add_runtime_dependency 'pagy', '>= 5.4'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop-bsm'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
