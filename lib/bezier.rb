# bezier_curve.rb
# A bézier curve library for Ruby, supporting n-dimensional,
# nth-degree curves.

require "bezier/version"
require "matrix"

module Bezier
  autoload :Curve, "bezier/curve"
  autoload :Point, "bezier/point"
end

# require "bezier_curve/version"
# require "bezier_curve/n_point"
