$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "formstack_integration/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "formstack_integration"
  s.version     = FormstackIntegration::VERSION
  s.authors     = ["Steve Kenworthy"]
  s.email       = ["steveyken@gmail.com"]
  s.homepage    = "http://github.com/crossroads/formstack_integration"
  s.summary     = "Zaps data from formstack.com forms into models."
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "formstack", "~> 0.0.1"
  s.add_dependency "hashie", "~> 1.2.0"
  s.add_development_dependency "debugger", "~> 1.1.4"
  s.add_development_dependency 'rspec-rails', '~> 2.0'
  s.add_development_dependency 'spork', '~> 0.9.2'
  s.add_development_dependency 'vcr', '~> 1.11.3'
  s.add_development_dependency 'webmock', '~> 1.7.6'
end
