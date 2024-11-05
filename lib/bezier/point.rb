# frozen_string_literal: true

require "matrix"

module Bezier
  class Point
    extend Forwardable

    attr_reader :vector

    def_delegator :vector, :magnitude, :magnitude
    def_delegator :vector, :to_a, :to_a
    def_delegator :vector, :size, :size
    alias_method :to_ary, :to_a

    def initialize(*args)
      @vector = ::Vector.elements(*args)
    end

    def x
      vector[0]
    end

    def y
      vector[1]
    end

    def z
      vector[2]
    end

    def ==(other)
      vector == other.vector
    end

    def +(other)
      Point.new(vector + other.vector)
    end

    def -(other)
      Point.new(vector - other.vector)
    end

    def *(scalar)
      Point.new(vector * scalar)
    end

    def interpolate_to(other, t)
      self + (other - self) * t
    end

    def distance_from(other)
      (self - other).magnitude
    end

    def angle_to(a, b)
      # Calculate distances as in original
      d0 = distance_from(a)
      d1 = a.distance_from(b)

      # Calculate the point z on extended line
      z = interpolate_to(a, 1 + d1 / d0)

      # Calculate distance from z to b
      dz = z.distance_from(b)

      # Calculate angle using same formula as original
      Math.asin(dz / (2 * d1)) * 2
    end

    def zip(other)
      to_a.zip(other.to_a)
    end
  end
end
