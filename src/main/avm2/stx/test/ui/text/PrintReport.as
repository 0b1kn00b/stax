package stx.test.ui.text {
	import stx.test.Runner;
	import stx.test.ui.text.PlainTextReport;
	import haxe.Log;
	import flash.Boot;
	public class PrintReport extends stx.test.ui.text.PlainTextReport {
		public function PrintReport(runner : stx.test.Runner = null) : void { if( !flash.Boot.skip_constructor ) {
			super(runner,this._handler);
			this.newline = "\n";
			this.indent = "  ";
		}}
		
		protected function _trace(s : String) : void {
			s = StringTools.replace(s,"  ",this.indent);
			s = StringTools.replace(s,"\n",this.newline);
			haxe.Log._trace(s,{ fileName : "PrintReport.hx", lineNumber : 85, className : "stx.test.ui.text.PrintReport", methodName : "_trace"});
		}
		
		protected function _handler(report : stx.test.ui.text.PlainTextReport) : void {
			this._trace(report.getResults());
		}
		
		protected var useTrace : Boolean;
	}
}
