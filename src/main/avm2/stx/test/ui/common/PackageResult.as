package stx.test.ui.common {
	import stx.test.Assertation;
	import stx.test.ui.common.ResultStats;
	import stx.test.ui.common.FixtureResult;
	import stx.test.TestResult;
	import stx.test.ui.common.ClassResult;
	import flash.Boot;
	public class PackageResult {
		public function PackageResult(packageName : String = null) : void { if( !flash.Boot.skip_constructor ) {
			this.packageName = packageName;
			this.classes = new Hash();
			this.packages = new Hash();
			this.stats = new stx.test.ui.common.ResultStats();
		}}
		
		protected function getOrCreatePackage(pack : String,flat : Boolean,ref : stx.test.ui.common.PackageResult) : stx.test.ui.common.PackageResult {
			if(pack == null || pack == "") return ref;
			if(flat) {
				if(ref.existsPackage(pack)) return ref.getPackage(pack);
				var p : stx.test.ui.common.PackageResult = new stx.test.ui.common.PackageResult(pack);
				ref.addPackage(p);
				return p;
			}
			else {
				var parts : Array = pack.split(".");
				{
					var _g : int = 0;
					while(_g < parts.length) {
						var part : String = parts[_g];
						++_g;
						ref = this.getOrCreatePackage(part,true,ref);
					}
				}
				return ref;
			}
			return null;
		}
		
		protected function getOrCreateClass(pack : stx.test.ui.common.PackageResult,cls : String,setup : String,teardown : String) : stx.test.ui.common.ClassResult {
			if(pack.existsClass(cls)) return pack.getClass(cls);
			var c : stx.test.ui.common.ClassResult = new stx.test.ui.common.ClassResult(cls,setup,teardown);
			pack.addClass(c);
			return c;
		}
		
		protected function createFixture(method : String,assertations : *) : stx.test.ui.common.FixtureResult {
			var f : stx.test.ui.common.FixtureResult = new stx.test.ui.common.FixtureResult(method);
			{ var $it : * = assertations.iterator();
			while( $it.hasNext() ) { var assertation : stx.test.Assertation = $it.next();
			f.add(assertation);
			}}
			return f;
		}
		
		public function packageNames(errorsHavePriority : Boolean = true) : Array {
			var names : Array = [];
			if(this.packageName == null) names.push("");
			{ var $it : * = this.packages.keys();
			while( $it.hasNext() ) { var name : String = $it.next();
			names.push(name);
			}}
			if(errorsHavePriority) {
				var me : stx.test.ui.common.PackageResult = this;
				names.sort(function(a : String,b : String) : int {
					var _as : stx.test.ui.common.ResultStats = me.getPackage(a).stats;
					var bs : stx.test.ui.common.ResultStats = me.getPackage(b).stats;
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
		
		public function classNames(errorsHavePriority : Boolean = true) : Array {
			var names : Array = [];
			{ var $it : * = this.classes.keys();
			while( $it.hasNext() ) { var name : String = $it.next();
			names.push(name);
			}}
			if(errorsHavePriority) {
				var me : stx.test.ui.common.PackageResult = this;
				names.sort(function(a : String,b : String) : int {
					var _as : stx.test.ui.common.ResultStats = me.getClass(a).stats;
					var bs : stx.test.ui.common.ResultStats = me.getClass(b).stats;
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
		
		public function getClass(name : String) : stx.test.ui.common.ClassResult {
			return this.classes.get(name);
		}
		
		public function getPackage(name : String) : stx.test.ui.common.PackageResult {
			if(this.packageName == null && name == "") return this;
			return this.packages.get(name);
		}
		
		public function existsClass(name : String) : Boolean {
			return this.classes.exists(name);
		}
		
		public function existsPackage(name : String) : Boolean {
			return this.packages.exists(name);
		}
		
		public function addPackage(result : stx.test.ui.common.PackageResult) : void {
			this.packages.set(result.packageName,result);
			this.stats.wire(result.stats);
		}
		
		public function addClass(result : stx.test.ui.common.ClassResult) : void {
			this.classes.set(result.className,result);
			this.stats.wire(result.stats);
		}
		
		public function addResult(result : stx.test.TestResult,flattenPackage : Boolean) : void {
			var pack : stx.test.ui.common.PackageResult = this.getOrCreatePackage(result.pack,flattenPackage,this);
			var cls : stx.test.ui.common.ClassResult = this.getOrCreateClass(pack,result.cls,result.setup,result.teardown);
			var fix : stx.test.ui.common.FixtureResult = this.createFixture(result.method,result.assertations);
			cls.add(fix);
		}
		
		public var stats : stx.test.ui.common.ResultStats;
		protected var packages : Hash;
		protected var classes : Hash;
		public var packageName : String;
	}
}
