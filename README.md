# bezier_curve

A Bézier curve library for Ruby, supporting n-dimensional, nth-degree curves

A rather simple and small library that should do pretty much anything you need to do with a bezier curve. It supports
arbitrary numbers of dimensions, and arbitrary numbers of control points. Even still, it is pretty easy to use. Here's a
simple quadratic (1st degree) bezier curve, in 2-dimensional space:

```ruby
# create the curve
curve = Bezier::Curve.new([0,0],[0,1],[1,1])
# determine its points for drawing purposes
curve.points
[[0, 0], [0.00390625, 0.12109375], ... [0.87890625, 0.99609375], 1, 1]
```

When outputting points, it automatically chooses a suitable angle tolerance which would make the resulting poly-line
appear relatively smooth (no angle changes more than about 3 degrees). But you can choose your own tolerance:

```ruby
# Extreme precision, less than 1 degree tolerance
curve.points(tolerance: Math::PI/180)
# just give me 5 points, quick: 
curve.points(count: 5)
```

You can easily split a curve into two, at a given value of `t`

```ruby
# split the curve at its midpoint
curve.split_at(0.5)
#=> [Bezier::Curve([0, 0], [0.0, 0.5], [0.25, 0.75]), Bezier::Curve([0.25, 0.75], [0.5, 1.0], [1, 1])]
```

You can also specify n-dimensional curves:

```ruby
# a 4-dimensional curve of 2nd order
curve = Bezier::Curve.new([0,0,0,0], [1,1,2,2], [4,5,9,3])
# get its points
curve.points(count:3)
#=> [[0.0, 0.0, 0.0, 0.0], [1.5, 1.75, 3.25, 1.75], [4.0, 5.0, 9.0, 3.0]]
```

You can also specify any degree/order of curve you like:

```ruby
# 2d curve, 6th degree
curve = Bezier::Curve.new([0,0],[1,1],[2,-1],[3,1],[4,-1],[5,1],[6,-1])
curve.degree
#=> 6
curve.points.size
#=> 35
```

Note that the complexity goes up exponentially for higher degree curves, so performance may suffer if used extensively;
but the capability is there if you need it. In fact, if you want, you can really slow things down and do a
18-dimensional curve of the 300th order. The sky is the limit. Well, your processor and memory are the limit, but you
get the idea.

## Note

This project was forked from https://github.com/marcuserronius/bezier_curve/.
