package stx.test.ui.common {
	import stx.test.ui.common.ResultStats;
	import stx.test.Assertation;
	import flash.Boot;
	public class FixtureResult {
		public function FixtureResult(methodName : String = null) : void { if( !flash.Boot.skip_constructor ) {
			this.methodName = methodName;
			this.list = new List();
			this.hasTestError = false;
			this.hasSetupError = false;
			this.hasTeardownError = false;
			this.hasTimeoutError = false;
			this.hasAsyncError = false;
			this.stats = new stx.test.ui.common.ResultStats();
		}}
		
		public function add(assertation : stx.test.Assertation) : void {
			this.list.add(assertation);
			{
				var $e : enum = (assertation);
				switch( $e.index ) {
				case 0:
				this.stats.addSuccesses(1);
				break;
				case 1:
				this.stats.addFailures(1);
				break;
				case 2:
				this.stats.addErrors(1);
				break;
				case 3:
				{
					this.stats.addErrors(1);
					this.hasSetupError = true;
				}
				break;
				case 4:
				{
					this.stats.addErrors(1);
					this.hasTeardownError = true;
				}
				break;
				case 5:
				{
					this.stats.addErrors(1);
					this.hasTimeoutError = true;
				}
				break;
				case 6:
				{
					this.stats.addErrors(1);
					this.hasAsyncError = true;
				}
				break;
				case 7:
				this.stats.addWarnings(1);
				break;
				}
			}
		}
		
		public function iterator() : * {
			return this.list.iterator();
		}
		
		protected var list : List;
		public var stats : stx.test.ui.common.ResultStats;
		public var hasAsyncError : Boolean;
		public var hasTimeoutError : Boolean;
		public var hasTeardownError : Boolean;
		public var hasSetupError : Boolean;
		public var hasTestError : Boolean;
		public var methodName : String;
	}
}
