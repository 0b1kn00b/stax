package stx;
import stx.test.TestCase;
using stx.test.Assert;
using stx.Maths;

class MathsTest extends TestCase{
	public function testNormalize(){
		Assert.equals(-0.5,-10.normalize(5,15));
	}
	public function testInterpolate(){
		Assert.equals(6., 1.interpolate(5,6) );
		Assert.equals(5.5, 0.5.interpolate(5,6) );
	}
	public function testSgn(){
		Assert.equals(-1.,(-0.6.sgn()));
		Assert.equals(1.,(0.6.sgn()));
	}
}