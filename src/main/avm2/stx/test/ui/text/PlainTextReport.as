package stx.test.ui.text {
	import stx.test.Assertation;
	import stx.test.ui.common.HeaderDisplayMode;
	import stx.test.Runner;
	import stx.test.ui.common.PackageResult;
	import stx.test.ui.common.SuccessResultsDisplayMode;
	import stx.test.ui.common.IReport;
	import stx.test.ui.common.ResultAggregator;
	import haxe.Stack;
	import stx.test.ui.common.FixtureResult;
	import haxe.Timer;
	import stx.test.ui.common.ClassResult;
	import stx.test.ui.common.ReportTools;
	import flash.Boot;
	public class PlainTextReport implements stx.test.ui.common.IReport{
		public function PlainTextReport(runner : stx.test.Runner = null,outputHandler : Function = null) : void { if( !flash.Boot.skip_constructor ) {
			this.aggregator = new stx.test.ui.common.ResultAggregator(runner,true);
			runner.onStart.add(this.start);
			this.aggregator.onComplete.add(this.complete);
			if(null != outputHandler) this.setHandler(outputHandler);
			this.displaySuccessResults = stx.test.ui.common.SuccessResultsDisplayMode.AlwaysShowSuccessResults;
			this.displayHeader = stx.test.ui.common.HeaderDisplayMode.AlwaysShowHeader;
		}}
		
		protected function complete(result : stx.test.ui.common.PackageResult) : void {
			this.result = result;
			(this.handler)(this);
		}
		
		public function getResults() : String {
			var buf : StringBuf = new StringBuf();
			this.addHeader(buf,this.result);
			{
				var _g : int = 0, _g1 : Array = this.result.packageNames();
				while(_g < _g1.length) {
					var pname : String = _g1[_g];
					++_g;
					var pack : stx.test.ui.common.PackageResult = this.result.getPackage(pname);
					if(stx.test.ui.common.ReportTools.skipResult(this,pack.stats,this.result.stats.isOk)) continue;
					{
						var _g2 : int = 0, _g3 : Array = pack.classNames();
						while(_g2 < _g3.length) {
							var cname : String = _g3[_g2];
							++_g2;
							var cls : stx.test.ui.common.ClassResult = pack.getClass(cname);
							if(stx.test.ui.common.ReportTools.skipResult(this,cls.stats,this.result.stats.isOk)) continue;
							buf.add((((pname == "")?"":pname + ".")) + cname + this.newline);
							{
								var _g4 : int = 0, _g5 : Array = cls.methodNames();
								while(_g4 < _g5.length) {
									var mname : String = _g5[_g4];
									++_g4;
									var fix : stx.test.ui.common.FixtureResult = cls.get(mname);
									if(stx.test.ui.common.ReportTools.skipResult(this,fix.stats,this.result.stats.isOk)) continue;
									buf.add(this.indents(1) + mname + ": ");
									if(fix.stats.isOk) buf.add("OK ");
									else if(fix.stats.hasErrors) buf.add("ERROR ");
									else if(fix.stats.hasFailures) buf.add("FAILURE ");
									else if(fix.stats.hasWarnings) buf.add("WARNING ");
									var messages : String = "";
									{ var $it : * = fix.iterator();
									while( $it.hasNext() ) { var assertation : stx.test.Assertation = $it.next();
									{
										{
											var $e2 : enum = (assertation);
											switch( $e2.index ) {
											case 0:
											var pos : * = $e2.params[0];
											buf.add(".");
											break;
											case 1:
											var pos1 : * = $e2.params[1], msg : String = $e2.params[0];
											{
												buf.add("F");
												messages += this.indents(2) + "line: " + pos1.lineNumber + ", " + msg + this.newline;
											}
											break;
											case 2:
											var s : Array = $e2.params[1], e : * = $e2.params[0];
											{
												buf.add("E");
												messages += this.indents(2) + Std.string(e) + this.dumpStack(s) + this.newline;
											}
											break;
											case 3:
											var s1 : Array = $e2.params[1], e1 : * = $e2.params[0];
											{
												buf.add("S");
												messages += this.indents(2) + Std.string(e1) + this.dumpStack(s1) + this.newline;
											}
											break;
											case 4:
											var s2 : Array = $e2.params[1], e2 : * = $e2.params[0];
											{
												buf.add("T");
												messages += this.indents(2) + Std.string(e2) + this.dumpStack(s2) + this.newline;
											}
											break;
											case 5:
											var s3 : Array = $e2.params[1], missedAsyncs : int = $e2.params[0];
											{
												buf.add("O");
												messages += this.indents(2) + "missed async calls: " + missedAsyncs + this.dumpStack(s3) + this.newline;
											}
											break;
											case 6:
											var s4 : Array = $e2.params[1], e3 : * = $e2.params[0];
											{
												buf.add("A");
												messages += this.indents(2) + Std.string(e3) + this.dumpStack(s4) + this.newline;
											}
											break;
											case 7:
											var msg1 : String = $e2.params[0];
											{
												buf.add("W");
												messages += this.indents(2) + msg1 + this.newline;
											}
											break;
											}
										}
									}
									}}
									buf.add(this.newline);
									buf.add(messages);
								}
							}
						}
					}
				}
			}
			return buf.toString();
		}
		
		protected var result : stx.test.ui.common.PackageResult;
		protected function addHeader(buf : StringBuf,result : stx.test.ui.common.PackageResult) : void {
			if(!stx.test.ui.common.ReportTools.hasHeader(this,result.stats)) return;
			var end : Number = haxe.Timer.stamp();
			var time : Number = Std._int((end - this.startTime) * 1000) / 1000;
			buf.add("results: " + (((result.stats.isOk)?"ALL TESTS OK":"SOME TESTS FAILURES")) + this.newline + " " + this.newline);
			buf.add("assertations: " + result.stats.assertations + this.newline);
			buf.add("successes: " + result.stats.successes + this.newline);
			buf.add("errors: " + result.stats.errors + this.newline);
			buf.add("failures: " + result.stats.failures + this.newline);
			buf.add("warnings: " + result.stats.warnings + this.newline);
			buf.add("execution time: " + time + this.newline);
			buf.add(this.newline);
		}
		
		protected function dumpStack(stack : Array) : String {
			if(stack.length == 0) return "";
			var parts : Array = haxe.Stack.toString(stack).split("\n");
			var r : Array = [];
			{
				var _g : int = 0;
				while(_g < parts.length) {
					var part : String = parts[_g];
					++_g;
					if(part.indexOf(" utest.") >= 0) continue;
					r.push(part);
				}
			}
			return r.join(this.newline);
		}
		
		protected function indents(c : int) : String {
			var s : String = "";
			{
				var _g : int = 0;
				while(_g < c) {
					var _ : int = _g++;
					s += this.indent;
				}
			}
			return s;
		}
		
		protected function start(e : stx.test.Runner) : void {
			this.startTime = haxe.Timer.stamp();
		}
		
		protected var startTime : Number;
		public function setHandler(_tmp_handler : Function) : void {
			var handler : Function = _tmp_handler;
			this.handler = handler;
		}
		
		protected var indent : String;
		protected var newline : String;
		protected var aggregator : stx.test.ui.common.ResultAggregator;
		public var handler : Function;
		public var displayHeader : stx.test.ui.common.HeaderDisplayMode;
		public var displaySuccessResults : stx.test.ui.common.SuccessResultsDisplayMode;
	}
}
