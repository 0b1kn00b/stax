package stx;

import stx.UnitTest;

using stx.Maths;

class MathsTest extends Suite{
	public function testNormalize(u:TestCase):TestCase{
		u = u.add(isEqual(-0.5,-10.normalize(5,15)));
		return u;
	}
	public function testInterpolate(u:TestCase):TestCase{
		u = u.add(isEqual(6., 1.interpolate(5,6)));
		u = u.add(isEqual(5.5, 0.5.interpolate(5,6)));
		return u;
	}
	public function testSgn(u:TestCase):TestCase{
		u = u.add(isEqual(-1.,(-0.6.sgn())));
		u = u.add(isEqual(1.,(0.6.sgn())));
		return u;
	}
}