package stx.test.ui.text {
	import stx.test.ui.common.SuccessResultsDisplayMode;
	import stx.test.ui.common.IReport;
	import stx.test.ui.common.HeaderDisplayMode;
	import stx.test.ui.common.PackageResult;
	import stx.test.ui.common.FixtureResult;
	import flash.Boot;
	import stx.test.Assertation;
	import haxe.Timer;
	import stx.test.ui.common.ResultAggregator;
	import haxe.Stack;
	import haxe.Log;
	import stx.test.ui.common.ClassResult;
	import flash.external.ExternalInterface;
	import stx.test.ui.common.ResultStats;
	import stx.test.ui.common.ReportTools;
	import stx.test.Runner;
	public class HtmlReport implements stx.test.ui.common.IReport{
		public function HtmlReport(runner : stx.test.Runner = null,outputHandler : Function = null,traceRedirected : Boolean = true) : void { if( !flash.Boot.skip_constructor ) {
			this.aggregator = new stx.test.ui.common.ResultAggregator(runner,true);
			runner.onStart.add(this.start);
			this.aggregator.onComplete.add(this.complete);
			if(null == outputHandler) this.setHandler(this._handler);
			else this.setHandler(outputHandler);
			if(traceRedirected) this.redirectTrace();
			this.displaySuccessResults = stx.test.ui.common.SuccessResultsDisplayMode.AlwaysShowSuccessResults;
			this.displayHeader = stx.test.ui.common.HeaderDisplayMode.AlwaysShowHeader;
		}}
		
		protected function _handler(report : stx.test.ui.text.HtmlReport) : void {
			var quote : Function = function(s : String) : String {
				s = StringTools.replace(s,"\r","");
				s = StringTools.replace(s,"\n","\\n");
				s = StringTools.replace(s,"\"","\\\"");
				return "\"" + s + "\"";
			}
			var fHeader : String = "function() {\r\nvar head = document.getElementsByTagName('head')[0];\r\n// add script\r\nvar script = document.createElement('script');\r\nscript.type = 'text/javascript';\r\nscript.innerHTML = " + quote(report.jsScript()) + ";\r\nhead.appendChild(script);\r\n// add style\r\nvar isDef = function(v) { return typeof v != 'undefined'; };\r\nvar style = document.createElement('style');\r\nstyle.type = 'text/css';\r\nvar styleContent = " + quote(report.cssStyle()) + ";\r\nif (isDef(style.cssText))\r\n{\r\n  style.cssText = styleContent;\r\n} else if (isDef(style.innerText)) {\r\n  style.innerText = styleContent;\r\n} else {\r\n  style.innerHTML = styleContent;\r\n}\r\nhead.appendChild(style);\r\nif(typeof utest == 'undefined')\r\n  utest = { };\r\nutest.append_result = function(s) {\r\n  var el = document.getElementById('utest-results');\r\n  if (null == el) {\r\n    el = document.createElement('div');\r\n    el.id = 'utest-results';\r\n    document.body.appendChild(el);\r\n  }\r\n  el.innerHTML += s;\r\n};\r\nutest.append_package = function(s) {\r\n  var el = document.getElementById('utest-results-packages');\r\n  el.innerHTML += s;\r\n};\r\n}";
			var fResult : String = "function() { utest.append_result(" + quote(report.getAll().substr(0,7000)) + "); }";
			var ef : Function = function(s1 : String) : void {
				flash.external.ExternalInterface.call("(" + s1 + ")()");
			}
			var er : Function = function(s2 : String) : void {
				ef("function() { utest.append_result(" + quote(s2) + "); }");
			}
			var ep : Function = function(s3 : String) : void {
				ef("function() { utest.append_package(" + quote(s3) + "); }");
			}
			var me : stx.test.ui.text.HtmlReport = this;
			haxe.Timer.delay(function() : void {
				ef(fHeader);
				er(report.getHeader());
				er(report.getTrace());
				if(stx.test.ui.common.ReportTools.skipResult(me,me.result.stats,me.result.stats.isOk)) return;
				er("<ul id=\"utest-results-packages\"></ul>");
				{
					var _g : int = 0, _g1 : Array = me.result.packageNames(false);
					while(_g < _g1.length) {
						var name : String = _g1[_g];
						++_g;
						var buf : StringBuf = new StringBuf();
						me.addPackage(buf,me.result.getPackage(name),name,me.result.stats.isOk);
						ep(buf.toString());
					}
				}
			},100);
		}
		
		protected function wrapHtml(title : String,s : String) : String {
			return "<head>\n<meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\" />\n<title>" + title + "</title>\r\n      <style type=\"text/css\">" + this.cssStyle() + "</style>\r\n      <script type=\"text/javascript\">\n" + this.jsScript() + "\n</script>\n</head>\r\n      <body>\n" + s + "\n</body>\n</html>";
		}
		
		protected function jsScript() : String {
			return "function utestTooltip(ref, text) {\r\n  var el = document.getElementById(\"utesttip\");\r\n  if(!el) {\r\n    var el = document.createElement(\"div\")\r\n    el.id = \"utesttip\";\r\n    el.style.position = \"absolute\";\r\n    document.body.appendChild(el)\r\n  }\r\n  var p = utestFindPos(ref);\r\n  el.style.left = p[0];\r\n  el.style.top = p[1];\r\n  el.innerHTML =  text;\r\n}\r\n\r\nfunction utestFindPos(el) {\r\n  var left = 0;\r\n  var top = 0;\r\n  do {\r\n    left += el.offsetLeft;\r\n    top += el.offsetTop;\r\n  } while(el = el.offsetParent)\r\n  return [left, top];\r\n}\r\n\r\nfunction utestRemoveTooltip() {\r\n  var el = document.getElementById(\"utesttip\")\r\n  if(el)\r\n    document.body.removeChild(el)\r\n}";
		}
		
		protected function cssStyle() : String {
			return "body, dd, dt {\r\n  font-family: Verdana, Arial, Sans-serif;\r\n  font-size: 12px;\r\n}\r\ndl {\r\n  width: 180px;\r\n}\r\ndd, dt {\r\n  margin : 0;\r\n  padding : 2px 5px;\r\n  border-top: 1px solid #f0f0f0;\r\n  border-left: 1px solid #f0f0f0;\r\n  border-right: 1px solid #CCCCCC;\r\n  border-bottom: 1px solid #CCCCCC;\r\n}\r\ndd.value {\r\n  text-align: center;\r\n  background-color: #eeeeee;\r\n}\r\ndt {\r\n  text-align: left;\r\n  background-color: #e6e6e6;\r\n  float: left;\r\n  width: 100px;\r\n}\r\n\r\nh1, h2, h3, h4, h5, h6 {\r\n  margin: 0;\r\n  padding: 0;\r\n}\r\n\r\nh1 {\r\n  text-align: center;\r\n  font-weight: bold;\r\n  padding: 5px 0 4px 0;\r\n  font-family: Arial, Sans-serif;\r\n  font-size: 18px;\r\n  border-top: 1px solid #f0f0f0;\r\n  border-left: 1px solid #f0f0f0;\r\n  border-right: 1px solid #CCCCCC;\r\n  border-bottom: 1px solid #CCCCCC;\r\n  margin: 0 2px 0px 2px;\r\n}\r\n\r\nh2 {\r\n  font-weight: bold;\r\n  padding: 2px 0 2px 8px;\r\n  font-family: Arial, Sans-serif;\r\n  font-size: 13px;\r\n  border-top: 1px solid #f0f0f0;\r\n  border-left: 1px solid #f0f0f0;\r\n  border-right: 1px solid #CCCCCC;\r\n  border-bottom: 1px solid #CCCCCC;\r\n  margin: 0 0 0px 0;\r\n  background-color: #FFFFFF;\r\n  color: #777777;\r\n}\r\n\r\nh2.classname {\r\n  color: #000000;\r\n}\r\n\r\n.okbg {\r\n  background-color: #66FF55;\r\n}\r\n.errorbg {\r\n  background-color: #CC1100;\r\n}\r\n.failurebg {\r\n  background-color: #EE3322;\r\n}\r\n.warnbg {\r\n  background-color: #FFCC99;\r\n}\r\n.headerinfo {\r\n  text-align: right;\r\n  font-size: 11px;\r\n  font - color: 0xCCCCCC;\r\n  margin: 0 2px 5px 2px;\r\n  border-left: 1px solid #f0f0f0;\r\n  border-right: 1px solid #CCCCCC;\r\n  border-bottom: 1px solid #CCCCCC;\r\n  padding: 2px;\r\n}\r\n\r\nli {\r\n  padding: 4px;\r\n  margin: 2px;\r\n  border-top: 1px solid #f0f0f0;\r\n  border-left: 1px solid #f0f0f0;\r\n  border-right: 1px solid #CCCCCC;\r\n  border-bottom: 1px solid #CCCCCC;\r\n  background-color: #e6e6e6;\r\n}\r\n\r\nli.fixture {\r\n  background-color: #f6f6f6;\r\n  padding-bottom: 6px;\r\n}\r\n\r\ndiv.fixturedetails {\r\n  padding-left: 108px;\r\n}\r\n\r\nul {\r\n  padding: 0;\r\n  margin: 6px 0 0 0;\r\n  list-style-type: none;\r\n}\r\n\r\nol {\r\n  padding: 0 0 0 28px;\r\n  margin: 0px 0 0 0;\r\n}\r\n\r\n.statnumbers {\r\n  padding: 2px 8px;\r\n}\r\n\r\n.fixtureresult {\r\n  width: 100px;\r\n  text-align: center;\r\n  display: block;\r\n  float: left;\r\n  font-weight: bold;\r\n  padding: 1px;\r\n  margin: 0 0 0 0;\r\n}\r\n\r\n.testoutput {\r\n  border: 1px dashed #CCCCCC;\r\n  margin: 4px 0 0 0;\r\n  padding: 4px 8px;\r\n  background-color: #eeeeee;\r\n}\r\n\r\nspan.tracepos, span.traceposempty {\r\n  display: block;\r\n  float: left;\r\n  font-weight: bold;\r\n  font-size: 9px;\r\n  width: 170px;\r\n  margin: 2px 0 0 2px;\r\n}\r\n\r\nspan.tracepos:hover {\r\n  cursor : pointer;\r\n  background-color: #ffff99;\r\n}\r\n\r\nspan.tracemsg {\r\n  display: block;\r\n  margin-left: 180px;\r\n  background-color: #eeeeee;\r\n  padding: 7px;\r\n}\r\n\r\nspan.tracetime {\r\n  display: block;\r\n  float: right;\r\n  margin: 2px;\r\n  font-size: 9px;\r\n  color: #777777;\r\n}\r\n\r\n\r\ndiv.trace ol {\r\n  padding: 0 0 0 40px;\r\n  color: #777777;\r\n}\r\n\r\ndiv.trace li {\r\n  padding: 0;\r\n}\r\n\r\ndiv.trace li div.li {\r\n  color: #000000;\r\n}\r\n\r\ndiv.trace h2 {\r\n  margin: 0 2px 0px 2px;\r\n  padding-left: 4px;\r\n}\r\n\r\n.tracepackage {\r\n  color: #777777;\r\n  font-weight: normal;\r\n}\r\n\r\n.clr {\r\n  clear: both;\r\n}\r\n\r\n#utesttip {\r\n  margin-top: -3px;\r\n  margin-left: 170px;\r\n  font-size: 9px;\r\n}\r\n\r\n#utesttip li {\r\n  margin: 0;\r\n  background-color: #ffff99;\r\n  padding: 2px 4px;\r\n  border: 0;\r\n  border-bottom: 1px dashed #ffff33;\r\n}";
		}
		
		protected function formatTime(t : Number) : String {
			return Math.round(t * 1000) + " ms";
		}
		
		protected function complete(result : stx.test.ui.common.PackageResult) : void {
			this.result = result;
			(this.handler)(this);
			this.restoreTrace();
		}
		
		protected var result : stx.test.ui.common.PackageResult;
		public function getHtml(title : String = null) : String {
			if(null == title) title = "utest: " + stx.test.ui.text.HtmlReport.platform;
			var s : String = this.getAll();
			if("" == s) return "";
			else return this.wrapHtml(title,s);
			return null;
		}
		
		public function getAll() : String {
			if(!stx.test.ui.common.ReportTools.hasOutput(this,this.result.stats)) return "";
			else return this.getHeader() + this.getTrace() + this.getResults();
			return null;
		}
		
		public function getResults() : String {
			var buf : StringBuf = new StringBuf();
			this.addPackages(buf,this.result,this.result.stats.isOk);
			return buf.toString();
		}
		
		public function getTrace() : String {
			var buf : StringBuf = new StringBuf();
			if(this._traces == null || this._traces.length == 0) return "";
			buf.add("<div class=\"trace\"><h2>traces</h2><ol>");
			{
				var _g : int = 0, _g1 : Array = this._traces;
				while(_g < _g1.length) {
					var t : * = _g1[_g];
					++_g;
					buf.add("<li><div class=\"li\">");
					var stack : String = StringTools.replace(this.formatStack(t.stack,false),"'","\\'");
					var method : String = "<span class=\"tracepackage\">" + t.infos.className + "</span><br/>" + t.infos.methodName + "(" + t.infos.lineNumber + ")";
					buf.add("<span class=\"tracepos\" onmouseover=\"utestTooltip(this.parentNode, '" + stack + "')\" onmouseout=\"utestRemoveTooltip()\">");
					buf.add(method);
					buf.add("</span><span class=\"tracetime\">");
					buf.add("@ " + this.formatTime(t.time));
					if(Math.round(t.delta * 1000) > 0) buf.add(", ~" + this.formatTime(t.delta));
					buf.add("</span><span class=\"tracemsg\">");
					buf.add(StringTools.replace(StringTools.trim(t.msg),"\n","<br/>\n"));
					buf.add("</span><div class=\"clr\"></div></div></li>");
				}
			}
			buf.add("</ol></div>");
			return buf.toString();
		}
		
		public function getHeader() : String {
			var buf : StringBuf = new StringBuf();
			if(!stx.test.ui.common.ReportTools.hasHeader(this,this.result.stats)) return "";
			var end : Number = haxe.Timer.stamp();
			var time : Number = Std._int((end - this.startTime) * 1000) / 1000;
			var msg : String = "TEST OK";
			if(this.result.stats.hasErrors) msg = "TEST ERRORS";
			else if(this.result.stats.hasFailures) msg = "TEST FAILED";
			else if(this.result.stats.hasWarnings) msg = "WARNING REPORTED";
			buf.add("<h1 class=\"" + this.cls(this.result.stats) + "bg header\">" + msg + "</h1>\n");
			buf.add("<div class=\"headerinfo\">");
			this.resultNumbers(buf,this.result.stats);
			buf.add(" performed on <strong>" + stx.test.ui.text.HtmlReport.platform + "</strong>, executed in <strong> " + time + " sec. </strong></div >\n ");
			return buf.toString();
		}
		
		protected function addPackage(buf : StringBuf,result : stx.test.ui.common.PackageResult,name : String,isOk : Boolean) : void {
			if(stx.test.ui.common.ReportTools.skipResult(this,result.stats,isOk)) return;
			if(name == "" && result.classNames().length == 0) return;
			buf.add("<li>");
			buf.add("<h2>" + name + "</h2>");
			this.blockNumbers(buf,result.stats);
			buf.add("<ul>\n");
			{
				var _g : int = 0, _g1 : Array = result.classNames();
				while(_g < _g1.length) {
					var cname : String = _g1[_g];
					++_g;
					this.addClass(buf,result.getClass(cname),cname,isOk);
				}
			}
			buf.add("</ul>\n");
			buf.add("</li>\n");
		}
		
		protected function addPackages(buf : StringBuf,result : stx.test.ui.common.PackageResult,isOk : Boolean) : void {
			if(stx.test.ui.common.ReportTools.skipResult(this,result.stats,isOk)) return;
			buf.add("<ul id=\"utest-results-packages\">\n");
			{
				var _g : int = 0, _g1 : Array = result.packageNames(false);
				while(_g < _g1.length) {
					var name : String = _g1[_g];
					++_g;
					this.addPackage(buf,result.getPackage(name),name,isOk);
				}
			}
			buf.add("</ul>\n");
		}
		
		protected function addClass(buf : StringBuf,result : stx.test.ui.common.ClassResult,name : String,isOk : Boolean) : void {
			if(stx.test.ui.common.ReportTools.skipResult(this,result.stats,isOk)) return;
			buf.add("<li>");
			buf.add("<h2 class=\"classname\">" + name + "</h2>");
			this.blockNumbers(buf,result.stats);
			buf.add("<ul>\n");
			{
				var _g : int = 0, _g1 : Array = result.methodNames();
				while(_g < _g1.length) {
					var mname : String = _g1[_g];
					++_g;
					this.addFixture(buf,result.get(mname),mname,isOk);
				}
			}
			buf.add("</ul>\n");
			buf.add("</li>\n");
		}
		
		protected function addFixture(buf : StringBuf,result : stx.test.ui.common.FixtureResult,name : String,isOk : Boolean) : void {
			if(stx.test.ui.common.ReportTools.skipResult(this,result.stats,isOk)) return;
			buf.add("<li class=\"fixture\"><div class=\"li\">");
			buf.add("<span class=\"" + this.cls(result.stats) + "bg fixtureresult\">");
			if(result.stats.isOk) buf.add("OK ");
			else if(result.stats.hasErrors) buf.add("ERROR ");
			else if(result.stats.hasFailures) buf.add("FAILURE ");
			else if(result.stats.hasWarnings) buf.add("WARNING ");
			buf.add("</span>");
			buf.add("<div class=\"fixturedetails\">");
			buf.add("<strong>" + name + "</strong>");
			buf.add(": ");
			this.resultNumbers(buf,result.stats);
			var messages : Array = [];
			{ var $it : * = result.iterator();
			while( $it.hasNext() ) { var assertation : stx.test.Assertation = $it.next();
			{
				{
					var $e2 : enum = (assertation);
					switch( $e2.index ) {
					case 0:
					var pos : * = $e2.params[0];
					break;
					case 1:
					var pos1 : * = $e2.params[1], msg : String = $e2.params[0];
					messages.push("<strong>line " + pos1.lineNumber + "</strong>: <em>" + StringTools.htmlEscape(msg) + "</em>");
					break;
					case 2:
					var s : Array = $e2.params[1], e : * = $e2.params[0];
					messages.push("<strong>error</strong>: <em>" + StringTools.htmlEscape(Std.string(e)) + "</em>\n" + this.formatStack(s));
					break;
					case 3:
					var s1 : Array = $e2.params[1], e1 : * = $e2.params[0];
					messages.push("<strong>setup error</strong>: " + StringTools.htmlEscape(Std.string(e1)) + "\n" + this.formatStack(s1));
					break;
					case 4:
					var s2 : Array = $e2.params[1], e2 : * = $e2.params[0];
					messages.push("<strong>tear-down error</strong>: " + StringTools.htmlEscape(Std.string(e2)) + "\n" + this.formatStack(s2));
					break;
					case 5:
					var s3 : Array = $e2.params[1], missedAsyncs : int = $e2.params[0];
					messages.push("<strong>missed async call(s)</strong>: " + missedAsyncs);
					break;
					case 6:
					var s4 : Array = $e2.params[1], e3 : * = $e2.params[0];
					messages.push("<strong>async error</strong>: " + StringTools.htmlEscape(Std.string(e3)) + "\n" + this.formatStack(s4));
					break;
					case 7:
					var msg1 : String = $e2.params[0];
					messages.push(StringTools.htmlEscape(msg1));
					break;
					}
				}
			}
			}}
			if(messages.length > 0) {
				buf.add("<div class=\"testoutput\">");
				buf.add(messages.join("<br/>"));
				buf.add("</div>\n");
			}
			buf.add("</div>\n");
			buf.add("</div></li>\n");
		}
		
		protected function formatStack(stack : Array,addNL : Boolean = true) : String {
			var parts : Array = [];
			var nl : String = ((addNL)?"\n":"");
			{
				var _g : int = 0, _g1 : Array = haxe.Stack.toString(stack).split("\n");
				while(_g < _g1.length) {
					var part : String = _g1[_g];
					++_g;
					if(StringTools.trim(part) == "") continue;
					if(-1 < part.indexOf("Called from utest.")) continue;
					parts.push(part);
				}
			}
			var s : String = "<ul><li>" + parts.join("</li>" + nl + "<li>") + "</li></ul>" + nl;
			return "<div>" + s + "</div>" + nl;
		}
		
		protected function blockNumbers(buf : StringBuf,stats : stx.test.ui.common.ResultStats) : void {
			buf.add("<div class=\"" + this.cls(stats) + "bg statnumbers\">");
			this.resultNumbers(buf,stats);
			buf.add("</div>");
		}
		
		protected function resultNumbers(buf : StringBuf,stats : stx.test.ui.common.ResultStats) : void {
			var numbers : Array = [];
			if(stats.assertations == 1) numbers.push("<strong>1</strong> test");
			else numbers.push("<strong>" + stats.assertations + "</strong> tests");
			if(stats.successes != stats.assertations) {
				if(stats.successes == 1) numbers.push("<strong>1</strong> pass");
				else if(stats.successes > 0) numbers.push("<strong>" + stats.successes + "</strong> passes");
			}
			if(stats.errors == 1) numbers.push("<strong>1</strong> error");
			else if(stats.errors > 0) numbers.push("<strong>" + stats.errors + "</strong> errors");
			if(stats.failures == 1) numbers.push("<strong>1</strong> failure");
			else if(stats.failures > 0) numbers.push("<strong>" + stats.failures + "</strong> failures");
			if(stats.warnings == 1) numbers.push("<strong>1</strong> warning");
			else if(stats.warnings > 0) numbers.push("<strong>" + stats.warnings + "</strong> warnings");
			buf.add(numbers.join(", "));
		}
		
		protected function cls(stats : stx.test.ui.common.ResultStats) : String {
			if(stats.hasErrors) return "error";
			else if(stats.hasFailures) return "failure";
			else if(stats.hasWarnings) return "warn";
			else return "ok";
			return null;
		}
		
		protected function start(e : stx.test.Runner) : void {
			this.startTime = haxe.Timer.stamp();
		}
		
		protected var startTime : Number;
		protected function _trace(v : *,infos : * = null) : void {
			var time : Number = haxe.Timer.stamp();
			var delta : Number = ((this._traceTime == null)?0:time - this._traceTime);
			this._traces.push({ msg : StringTools.htmlEscape(Std.string(v)), infos : infos, time : time - this.startTime, delta : delta, stack : haxe.Stack.callStack()});
			this._traceTime = haxe.Timer.stamp();
		}
		
		protected var _traceTime : *;
		public function restoreTrace() : void {
			if(!this.traceRedirected) return;
			haxe.Log._trace = this.oldTrace;
		}
		
		public function redirectTrace() : void {
			if(this.traceRedirected) return;
			this._traces = [];
			this.oldTrace = haxe.Log._trace;
			haxe.Log._trace = this._trace;
		}
		
		public function setHandler(_tmp_handler : Function) : void {
			var handler : Function = _tmp_handler;
			this.handler = handler;
		}
		
		protected var _traces : Array;
		protected var oldTrace : *;
		protected var aggregator : stx.test.ui.common.ResultAggregator;
		public var handler : Function;
		public var displayHeader : stx.test.ui.common.HeaderDisplayMode;
		public var displaySuccessResults : stx.test.ui.common.SuccessResultsDisplayMode;
		public var traceRedirected : Boolean;
		static protected var platform : String = "flash";
	}
}
