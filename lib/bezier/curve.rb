# frozen_string_literal: true

require "forwardable"

module Bezier
  # A bezier curve. Usage:
  #   c = Curve.new([0,0], [0,1], [1,1])
  #   c.first             #=> [0,0]
  #   c.last              #=> [1,1]
  #   c[0.375]            #=> [t=.375]
  #   c.points            #=> an array of points that make a fairly smooth curve
  #   c.points(tolerance:Math::PI/20)
  #                       #=> returns points with given tolerance for smoothness
  #   c.points(count: 10) #=> returns 10 points, for evenly spaced values of `t`
  class Curve
    extend Forwardable

    # create a new curve, from a list of points.
    def initialize(*controls)
      # check for argument errors
      raise InsufficientPointsError if controls.size <= 1
      raise ZeroDimensionError if controls[0].size == 0
      # steep:ignore:start
      raise DifferingDimensionError if controls[1..].any? { |pt| controls[0].size != pt.size }
      # steep:ignore:end

      @controls = controls.map { |item| Point.new(item) }
    end

    attr_reader :controls

    def_delegator :controls, :first, :first
    alias_method :start, :first

    def_delegator :controls, :last, :last
    alias_method :end, :last

    # the degree of the curve
    def degree
      controls.size - 1
    end
    alias_method :order, :degree

    # the number of dimensions given
    def dimensions
      controls[0].size
    end

    # find the point for a given value of `t`.
    def index(t)
      pts = controls
      while pts.size > 1
        # steep:ignore:start
        pts = (0..pts.size - 2).map do |i|
          pts[i].zip(pts[i + 1]).map { |a, b| t * (b - a) + a }
        end
        # steep:ignore:end
      end
      Point.new(pts[0])
    end
    alias_method :[], :index

    # divide this bezier curve into two curves, at the given `t`
    def split_at(t)
      pts = controls
      # @type var a: Array[Point]
      # @type var b: Array[Point]
      a, b = [pts.first], [pts.last]
      while pts.size > 1
        # steep:ignore:start
        pts = (0..pts.size - 2).map do |i|
          pts[i].zip(pts[i + 1]).map { |a, b| t * (b - a) + a }
        end
        a << pts.first
        b << pts.last
        # steep:ignore:end
      end

      # steep:ignore:start
      [Curve.new(*a), Curve.new(*b.reverse)]
      # steep:ignore:end
    end

    # Returns a list of points on this curve. If you specify `count`,
    # returns that many points, evenly spread over values of `t`.
    # If you specify `tolerance`, no adjoining line segments will
    # deviate from 180 by an angle of more than the value given (in
    # radians). If unspecified, defaults to `tolerance: 1/64pi` (~3 deg)
    def points(count: nil, tolerance: Math::PI / 64)
      if count
        (0...count).map { |i| index i / (count - 1.0) }
      else
        lines = subdivide(tolerance)
        lines.map { |seg| seg.first } + [lines.last.last]
      end
    end

    # recursively subdivides the curve until each is straight within the
    # given tolerance value, in radians. Then, subdivides further as
    # needed to remove remaining corners.
    def subdivide(tolerance)
      return [self] if is_straight?(tolerance)

      # @type var a: Array[Curve]
      # @type var b: Array[Curve]
      a, b = split_at(0.5).map { |c| c.subdivide(tolerance) }
      # now make sure the angle from a to b is good
      while a.last.first.angle_to(a.last.last, b.first.last) > tolerance
        if a.last.divergence > b.first.divergence
          a[-1, 1] = a[-1].split_at(0.5)
        else
          b[0, 1] = b[0].split_at(0.5)
        end
      end
      a + b
    end

    # test this curve to see of it can be considered straight, optionally
    # within the given angular tolerance, in radians
    def is_straight?(tolerance)
      return false if divergence > tolerance

      # maximum wavyness is `degree` - 1; split at `degree` points
      pts = points(count: degree)
      # size-3, because we ignore the last 2 points as starting points;
      # check all angles against `tolerance`
      (0..pts.size - 3).all? do |i|
        pts[i].angle_to(pts[i + 1], pts[i + 2]) < tolerance
      end
    end

    # How much this curve diverges from straight, measuring from `t=0.5`
    def divergence
      first.angle_to(self[0.5], last)
    end

    # Indicates an error where the control points are in zero dimensions.
    # Sounds silly, but you never know, when software is generating the
    # points.
    class ZeroDimensionError < ArgumentError
      def message
        "Points given must have at least one dimension"
      end
    end

    # Indicates that the points do not all have the same number of
    # dimensions, which makes them impossible to use.
    class DifferingDimensionError < ArgumentError
      def message
        "All points must have the same number of dimensions"
      end
    end

    # Indicates that there aren't enough control points; minimum of two
    # for a first-degree bezier.
    class InsufficientPointsError < ArgumentError
      def message
        "You must supply a minimum of two points"
      end
    end
  end
end
