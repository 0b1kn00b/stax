package stx.test {
	import stx.test.MustMatcherExtensions;
	import stx.Future;
	import stx.test.Assert;
	public class TestCase {
		public function TestCase() : void {
		}
		
		public function warn(msg : String) : void {
			stx.test.Assert.warn(msg);
		}
		
		public function fail(msg : String = "failure expected",pos : * = null) : void {
			if(msg==null) msg="failure expected";
			stx.test.Assert.fail(msg,pos);
		}
		
		public function assertNotDelivered(future : stx.Future,timeout : * = null,pos : * = null) : void {
			stx.test.Assert.notDelivered(future,timeout,pos);
			return;
		}
		
		public function assertCanceled(future : stx.Future,assertions : Function,timeout : * = null) : void {
			stx.test.Assert.canceled(future,assertions,timeout);
			return;
		}
		
		public function assertDelivered(future : stx.Future,assertions : Function,timeout : * = null) : void {
			stx.test.Assert.delivered(future,assertions,timeout);
			return;
		}
		
		public function assertStringSequence(sequence : Array,value : String,msg : String = null,pos : * = null) : void {
			stx.test.Assert.stringSequence(sequence,value,msg,pos);
		}
		
		public function assertStringContains(match : String,value : String,msg : String = null,pos : * = null) : void {
			stx.test.Assert.stringContains(match,value,msg,pos);
		}
		
		public function assertNotContains(values : *,match : *,msg : String = null,pos : * = null) : void {
			stx.test.Assert.notContains(values,match,msg,pos);
		}
		
		public function assertContains(values : *,match : *,msg : String = null,pos : * = null) : void {
			stx.test.Assert.contains(values,match,msg,pos);
		}
		
		public function assertEqualsOneOf(value : *,possibilities : Array,msg : String = null,pos : * = null) : void {
			stx.test.Assert.equalsOneOf(value,possibilities,msg,pos);
		}
		
		public function assertThrowsException(method : Function,type : Class = null,msg : String = null,pos : * = null) : void {
			stx.test.Assert.throwsException(method,type,msg,pos);
		}
		
		public function assertLooksLike(expected : *,value : *,recursive : * = null,msg : String = null,pos : * = null) : void {
			stx.test.Assert.looksLike(expected,value,recursive,msg,pos);
		}
		
		public function assertFloatEquals(expected : Number,value : Number,approx : * = null,msg : String = null,pos : * = null) : void {
			stx.test.Assert.floatEquals(expected,value,approx,msg,pos);
		}
		
		public function assertMatches(pattern : EReg,value : *,msg : String = null,pos : * = null) : void {
			stx.test.Assert.matches(pattern,value,msg,pos);
		}
		
		public function assertEquals(expected : *,value : *,equal : Function = null,msg : String = null,pos : * = null) : void {
			if(equal != null) stx.test.Assert.isTrue(equal(expected,value),((msg != null)?msg:"expected " + Std.string(expected) + " but found " + Std.string(value)),pos);
			else stx.test.Assert.equals(expected,value,null,msg,pos);
		}
		
		public function assertNotEquals(expected : *,value : *,msg : String = null,pos : * = null) : void {
			stx.test.Assert.notEquals(expected,value,msg,pos);
		}
		
		public function assertIs(value : *,type : *,msg : String = null,pos : * = null) : void {
			stx.test.Assert._is(value,type,msg,pos);
		}
		
		public function assertNotNull(value : *,msg : String = null,pos : * = null) : void {
			stx.test.Assert.notNull(value,msg,pos);
		}
		
		public function assertNull(value : *,msg : String = null,pos : * = null) : void {
			stx.test.Assert.isNull(value,msg,pos);
		}
		
		public function assertFalse(value : Boolean,msg : String = null,pos : * = null) : void {
			stx.test.Assert.isFalse(value,msg,pos);
		}
		
		public function assertTrue(cond : Boolean,msg : String = null,pos : * = null) : void {
			stx.test.Assert.isTrue(cond,msg,pos);
		}
		
		public function assertThat(obj : *,cond : Function,msg : String = null,pos : * = null) : void {
			stx.test.Assert.that(obj,cond,msg,pos);
		}
		
		public function not(c : Function) : Function {
			return stx.test.MustMatcherExtensions.negate(c);
		}
		
		public function afterAll() : void {
		}
		
		public function beforeAll() : void {
		}
		
		public function after() : void {
		}
		
		public function before() : void {
		}
		
	}
}
