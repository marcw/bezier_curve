lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "bezier/version"

Gem::Specification.new do |s|
  s.name        = 'bezier_curve'
  s.version     = Bezier::VERSION
  s.date        = Bezier::RELEASE_DATE
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = "> 2.0"

  s.summary     = "N-dimensional, nth-degree Bézier curves"
  s.description = "A Bézier curve library for Ruby, supporting n-dimensional, nth-degree curves"
  s.license     = "MIT"
  s.authors     = ["Mark Hubbart", "Marc Weistroff"]
  s.email       = ["mark.hubbart@gmail.com", "marc@weistroff.net"]

  s.files       = Dir["README.md", "lib/**/*.*"]

  s.homepage    = "https://github.com/marcuserronius/bezier_curve"

  s.add_runtime_dependency 'matrix'

  s.add_development_dependency 'rake', "~> 13.2"
  s.add_development_dependency 'simplecov', "~> 0.21"
  s.add_development_dependency 'rubocop-rails-omakase'
  s.add_development_dependency 'test-unit'
end
