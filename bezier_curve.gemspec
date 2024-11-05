$: << File.expand_path("lib")
require "bezier_curve/version"

Gem::Specification.new do |s|
  s.name        = 'bezier_curve'
  s.version     = BezierCurve::VERSION
  s.date        = BezierCurve::RELEASE_DATE
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = "~> 2.0, ~> 3.0"
  
  s.summary     = "N-dimensional, nth-degree Bézier curves"
  s.description = "A Bézier curve library for Ruby, supporting n-dimensional, nth-degree curves"
  s.license     = "MIT"
  s.author      = "Mark Hubbart"
  s.email       = "mark.hubbart@gmail.com"

  s.files       = Dir["{bin,lib,test}/**/*.{rb,md}"] + Dir["*.{md,rdoc}"] + ["Rakefile"]

  s.homepage    = "https://github.com/marcuserronius/bezier_curve"

  s.add_development_dependency 'rake', "~> 10.3"
  s.add_development_dependency 'simplecov', "~> 0.10"
  s.add_development_dependency 'rubocop-rails-omakase', "~> 0.0"
end
