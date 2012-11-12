package stx.test.mock {
	import stx.test.mock.Mock;
	import flash.Boot;
	import stx.test.TestCase;
	public class MockTestCase extends stx.test.TestCase {
		public function MockTestCase() : void { if( !flash.Boot.skip_constructor ) {
			super();
			this._runningTest = false;
		}}
		
		public override function afterAll() : void {
			{
				var _g : int = 0, _g1 : Array = this._globalMocks;
				while(_g < _g1.length) {
					var mock : stx.test.mock.Mock = _g1[_g];
					++_g;
					mock.verifyAllExpectations();
				}
			}
			this._globalMocks = [];
		}
		
		public override function after() : void {
			try {
				{
					var _g : int = 0, _g1 : Array = this._localMocks;
					while(_g < _g1.length) {
						var mock : stx.test.mock.Mock = _g1[_g];
						++_g;
						mock.verifyAllExpectations();
					}
				}
				this._localMocks = [];
				this._runningTest = false;
			}
			catch( e : * ){
				this._runningTest = false;
				throw e;
			}
		}
		
		public function newMock(c : Class) : stx.test.mock.Mock {
			var mock : stx.test.mock.Mock = stx.test.mock.Mock.internal_create(c);
			if(this._runningTest) this._localMocks.push(mock);
			else this._globalMocks.push(mock);
			return mock;
		}
		
		public override function before() : void {
			this._localMocks = [];
			this._runningTest = true;
		}
		
		protected var _runningTest : Boolean;
		protected var _globalMocks : Array;
		protected var _localMocks : Array;
	}
}
