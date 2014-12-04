$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "record_encoder/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "record_encoder"
  s.version     = RecordEncoder::VERSION
  s.authors     = ["Tomasz Skorupa"]
  s.summary     = "RecordEncoder can be chained to an activerecord relation or a class and will yield encoded representation"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.required_ruby_version = '>= 2.1.3'

  s.add_dependency "activesupport"
  s.add_dependency "bert"

  s.add_development_dependency "rails", "~> 4.1.8"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "mocha"
end
