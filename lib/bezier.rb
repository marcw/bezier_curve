# frozen_string_literal: true
# A bézier curve library for Ruby, supporting n-dimensional, nth-degree curves.

require "bezier/version"

module Bezier
  autoload :Curve, "bezier/curve"
  autoload :Point, "bezier/point"
end
