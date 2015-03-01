# -*- encoding: utf-8 -*-
require File.expand_path("../lib/direction/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "direction"
  gem.description   = <<-END.gsub(/^ +/, "")
    Direction helps you separate commands, queries, and state changes, making
    your codebase and team more scalable and focused on use cases rather than
    state
  END
  gem.homepage      = "https://github.com/kibiz0r/#{gem.name}"
  gem.version       = Direction::VERSION

  gem.authors       = ["Michael Harrington"]
  gem.email         = ["kibiz0r@gmail.com"]

  gem.files         = `git ls-files`.split($\)
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "bubble-wrap"
  gem.add_runtime_dependency "motion-support", "~> 0.2.6"
  gem.add_runtime_dependency "activesupport"
  gem.add_runtime_dependency "coalesce"
  gem.add_development_dependency "rspec-core"
  gem.add_development_dependency "rspec-expectations"
  gem.add_development_dependency "rspec-mocks"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "cucumber"
  gem.add_development_dependency "ruby-prof"

  gem.summary       = <<-END.gsub(/^ +/, "")
    Direction helps you separate commands, queries, and state changes, making
    your codebase and team more scalable and focused on use cases rather than
    state.
  END
end
