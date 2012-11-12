package stx.test.ui.common {
	import stx.test.Dispatcher;
	import flash.Boot;
	public class ResultStats {
		public function ResultStats() : void { if( !flash.Boot.skip_constructor ) {
			this.assertations = 0;
			this.successes = 0;
			this.failures = 0;
			this.errors = 0;
			this.warnings = 0;
			this.isOk = true;
			this.hasFailures = false;
			this.hasErrors = false;
			this.hasWarnings = false;
			this.onAddSuccesses = new stx.test.Dispatcher();
			this.onAddFailures = new stx.test.Dispatcher();
			this.onAddErrors = new stx.test.Dispatcher();
			this.onAddWarnings = new stx.test.Dispatcher();
		}}
		
		public function unwire(dependant : stx.test.ui.common.ResultStats) : void {
			dependant.onAddSuccesses.remove(this.addSuccesses);
			dependant.onAddFailures.remove(this.addFailures);
			dependant.onAddErrors.remove(this.addErrors);
			dependant.onAddWarnings.remove(this.addWarnings);
			this.subtract(dependant);
		}
		
		public function wire(dependant : stx.test.ui.common.ResultStats) : void {
			dependant.onAddSuccesses.add(this.addSuccesses);
			dependant.onAddFailures.add(this.addFailures);
			dependant.onAddErrors.add(this.addErrors);
			dependant.onAddWarnings.add(this.addWarnings);
			this.sum(dependant);
		}
		
		public function subtract(other : stx.test.ui.common.ResultStats) : void {
			this.addSuccesses(-other.successes);
			this.addFailures(-other.failures);
			this.addErrors(-other.errors);
			this.addWarnings(-other.warnings);
		}
		
		public function sum(other : stx.test.ui.common.ResultStats) : void {
			this.addSuccesses(other.successes);
			this.addFailures(other.failures);
			this.addErrors(other.errors);
			this.addWarnings(other.warnings);
		}
		
		public function addWarnings(v : int) : void {
			if(v == 0) return;
			this.assertations += v;
			this.warnings += v;
			this.hasWarnings = this.warnings > 0;
			this.isOk = !(this.hasFailures || this.hasErrors || this.hasWarnings);
			this.onAddWarnings.dispatch(v);
		}
		
		public function addErrors(v : int) : void {
			if(v == 0) return;
			this.assertations += v;
			this.errors += v;
			this.hasErrors = this.errors > 0;
			this.isOk = !(this.hasFailures || this.hasErrors || this.hasWarnings);
			this.onAddErrors.dispatch(v);
		}
		
		public function addFailures(v : int) : void {
			if(v == 0) return;
			this.assertations += v;
			this.failures += v;
			this.hasFailures = this.failures > 0;
			this.isOk = !(this.hasFailures || this.hasErrors || this.hasWarnings);
			this.onAddFailures.dispatch(v);
		}
		
		public function addSuccesses(v : int) : void {
			if(v == 0) return;
			this.assertations += v;
			this.successes += v;
			this.onAddSuccesses.dispatch(v);
		}
		
		public var hasWarnings : Boolean;
		public var hasErrors : Boolean;
		public var hasFailures : Boolean;
		public var isOk : Boolean;
		public var onAddWarnings : stx.test.Dispatcher;
		public var onAddErrors : stx.test.Dispatcher;
		public var onAddFailures : stx.test.Dispatcher;
		public var onAddSuccesses : stx.test.Dispatcher;
		public var warnings : int;
		public var errors : int;
		public var failures : int;
		public var successes : int;
		public var assertations : int;
	}
}
