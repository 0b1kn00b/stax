package stx.test.ui.common {
	import stx.test.ui.common.FixtureResult;
	import stx.test.ui.common.ResultStats;
	import flash.Boot;
	public class ClassResult {
		public function ClassResult(className : String = null,setupName : String = null,teardownName : String = null) : void { if( !flash.Boot.skip_constructor ) {
			this.fixtures = new Hash();
			this.className = className;
			this.setupName = setupName;
			this.hasSetup = setupName != null;
			this.teardownName = teardownName;
			this.hasTeardown = teardownName != null;
			this.methods = 0;
			this.stats = new stx.test.ui.common.ResultStats();
		}}
		
		public function methodNames(errorsHavePriority : Boolean = true) : Array {
			var names : Array = [];
			{ var $it : * = this.fixtures.keys();
			while( $it.hasNext() ) { var name : String = $it.next();
			names.push(name);
			}}
			if(errorsHavePriority) {
				var me : stx.test.ui.common.ClassResult = this;
				names.sort(function(a : String,b : String) : int {
					var _as : stx.test.ui.common.ResultStats = me.get(a).stats;
					var bs : stx.test.ui.common.ResultStats = me.get(b).stats;
					if(_as.hasErrors) return ((!bs.hasErrors)?-1:((_as.errors == bs.errors)?Reflect.compare(a,b):Reflect.compare(_as.errors,bs.errors)));
					else if(bs.hasErrors) return 1;
					else if(_as.hasFailures) return ((!bs.hasFailures)?-1:((_as.failures == bs.failures)?Reflect.compare(a,b):Reflect.compare(_as.failures,bs.failures)));
					else if(bs.hasFailures) return 1;
					else if(_as.hasWarnings) return ((!bs.hasWarnings)?-1:((_as.warnings == bs.warnings)?Reflect.compare(a,b):Reflect.compare(_as.warnings,bs.warnings)));
					else if(bs.hasWarnings) return 1;
					else return Reflect.compare(a,b);
					return 0;
				});
			}
			else names.sort(function(a1 : String,b1 : String) : int {
				return Reflect.compare(a1,b1);
			});
			return names;
		}
		
		public function exists(method : String) : Boolean {
			return this.fixtures.exists(method);
		}
		
		public function get(method : String) : stx.test.ui.common.FixtureResult {
			return this.fixtures.get(method);
		}
		
		public function add(result : stx.test.ui.common.FixtureResult) : void {
			if(this.fixtures.exists(result.methodName)) throw "invalid duplicated fixture result";
			this.stats.wire(result.stats);
			this.methods++;
			this.fixtures.set(result.methodName,result);
		}
		
		public var stats : stx.test.ui.common.ResultStats;
		public var methods : int;
		public var hasTeardown : Boolean;
		public var hasSetup : Boolean;
		public var teardownName : String;
		public var setupName : String;
		public var className : String;
		protected var fixtures : Hash;
	}
}
