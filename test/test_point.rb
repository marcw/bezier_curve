# test functionality of NPoint module
require "test/unit"
require "bezier"

class TestNPoint < Test::Unit::TestCase
  def pt(*args)
    Bezier::Point.new(*args)
  end

  def test_x
    np = pt([ 9, 8, 7 ])
    assert_equal 9, np.x
  end

  def test_y
    np = pt([ 9, 8, 7 ])
    assert_equal 8, np.y
  end

  def test_z
    np = pt([ 9, 8, 7 ])
    assert_equal 7, np.z
  end

  def test_to
    a, b = pt([ 1, 1, 1 ]), pt([ 5, 5, 5 ])

    assert_equal pt([ 3, 3, 3 ]), a.interpolate_to(b, 0.5)
    assert_equal pt([ -1, -1, -1 ]), a.interpolate_to(b, -0.5)
    assert_equal pt([ 7, 7, 7 ]), a.interpolate_to(b, 1.5)
  end

  def test_dist_from
    # various numbers of dimensions
    assert_equal 3,             pt([ 3 ]).distance_from(pt([ 6 ]))
    assert_equal (3**2*2)**0.5, pt([ 3, 3 ]).distance_from(pt([ 6, 6 ]))
    assert_equal (3**2*3)**0.5, pt([ 3, 3, 3 ]).distance_from(pt([ 6, 6, 6 ]))
    assert_equal (3**2*4)**0.5, pt([ 3, 3, 3, 3 ]).distance_from(pt([ 6, 6, 6, 6 ]))
    assert_equal (3**2*5)**0.5, pt([ 3, 3, 3, 3, 3 ]).distance_from(pt([ 6, 6, 6, 6, 6 ]))

    # across the origin
    assert_in_delta 8**0.5, pt([ 1, 1 ]).distance_from(pt([ -1, -1 ])), 0.00001
  end

  def test_angle_to
    pi = Math::PI
    pi_eps = (pi.next_float-pi)*16
    assert_in_epsilon pi/2,  pt([ 1, 0 ]).angle_to(pt([ 0, 0 ]), pt([ 0, 1 ])),   pi_eps
    assert_in_epsilon pi,    pt([ 1, 1 ]).angle_to(pt([ 0, 0 ]), pt([ 1, 1 ])),   pi_eps
    assert_in_epsilon 0,     pt([ 1, 1 ]).angle_to(pt([ 0, 0 ]), pt([ -1, -1 ])), pi_eps
    assert_in_epsilon pi/4,  pt([ -1, 0 ]).angle_to(pt([ 0, 0 ]), pt([ 1, 1 ])),  pi_eps
  end
end
