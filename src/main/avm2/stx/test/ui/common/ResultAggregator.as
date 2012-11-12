package stx.test.ui.common {
	import stx.test.Assertation;
	import stx.test.Runner;
	import stx.test.Notifier;
	import stx.test.ui.common.PackageResult;
	import stx.test.ui.common.FixtureResult;
	import stx.test.ui.common.ClassResult;
	import stx.test.TestResult;
	import stx.test.Dispatcher;
	import flash.Boot;
	public class ResultAggregator {
		public function ResultAggregator(runner : stx.test.Runner = null,flattenPackage : Boolean = false) : void { if( !flash.Boot.skip_constructor ) {
			if(runner == null) throw "runner argument is null";
			this.flattenPackage = flattenPackage;
			this.runner = runner;
			runner.onStart.add(this.start);
			runner.onProgress.add(this.progress);
			runner.onComplete.add(this.complete);
			this.onStart = new stx.test.Notifier();
			this.onComplete = new stx.test.Dispatcher();
			this.onProgress = new stx.test.Dispatcher();
		}}
		
		protected function complete(runner : stx.test.Runner) : void {
			this.onComplete.dispatch(this.root);
		}
		
		protected function progress(e : *) : void {
			this.root.addResult(e.result,this.flattenPackage);
			this.onProgress.dispatch(e);
		}
		
		protected function createFixture(result : stx.test.TestResult) : stx.test.ui.common.FixtureResult {
			var f : stx.test.ui.common.FixtureResult = new stx.test.ui.common.FixtureResult(result.method);
			{ var $it : * = result.assertations.iterator();
			while( $it.hasNext() ) { var assertation : stx.test.Assertation = $it.next();
			f.add(assertation);
			}}
			return f;
		}
		
		protected function getOrCreateClass(pack : stx.test.ui.common.PackageResult,cls : String,setup : String,teardown : String) : stx.test.ui.common.ClassResult {
			if(pack.existsClass(cls)) return pack.getClass(cls);
			var c : stx.test.ui.common.ClassResult = new stx.test.ui.common.ClassResult(cls,setup,teardown);
			pack.addClass(c);
			return c;
		}
		
		protected function getOrCreatePackage(pack : String,flat : Boolean,ref : stx.test.ui.common.PackageResult = null) : stx.test.ui.common.PackageResult {
			if(ref == null) ref = this.root;
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
		
		protected function start(runner : stx.test.Runner) : void {
			this.root = new stx.test.ui.common.PackageResult(null);
			this.onStart.dispatch();
		}
		
		public var onProgress : stx.test.Dispatcher;
		public var onComplete : stx.test.Dispatcher;
		public var onStart : stx.test.Notifier;
		public var root : stx.test.ui.common.PackageResult;
		protected var flattenPackage : Boolean;
		protected var runner : stx.test.Runner;
	}
}
