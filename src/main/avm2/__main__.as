package  {
	import flash.Boot;
	import flash.Lib;
	public class __main__ extends flash.Boot {
		public function __main__() {
			super();
			flash.Lib.current = this;
			{
				var d : * = Date;
				d.now = function() : * {
					return new Date();
				}
				d.fromTime = function(t : *) : Date {
					var d1 : Date = new Date();
					d1.setTime(t);
					return d1;
				}
				d.fromString = function(s : String) : Date {
					switch(s.length) {
					case 8:
					{
						var k : Array = s.split(":");
						var d2 : Date = new Date();
						d2.setTime(0);
						d2.setUTCHours(k[0]);
						d2.setUTCMinutes(k[1]);
						d2.setUTCSeconds(k[2]);
						return d2;
					}
					break;
					case 10:
					{
						var k1 : Array = s.split("-");
						return new Date(k1[0],k1[1] - 1,k1[2],0,0,0);
					}
					break;
					case 19:
					{
						var k2 : Array = s.split(" ");
						var y : Array = k2[0].split("-");
						var t1 : Array = k2[1].split(":");
						return new Date(y[0],y[1] - 1,y[2],t1[0],t1[1],t1[2]);
					}
					break;
					default:
					throw "Invalid date format : " + s;
					break;
					}
					return null;
				}
				d.prototype["toStringHX"] = function() : String {
					var date : Date = this;
					var m : int = date.getMonth() + 1;
					var d3 : int = date.getDate();
					var h : int = date.getHours();
					var mi : int = date.getMinutes();
					var s1 : int = date.getSeconds();
					return date.getFullYear() + "-" + (((m < 10)?"0" + m:"" + m)) + "-" + (((d3 < 10)?"0" + d3:"" + d3)) + " " + (((h < 10)?"0" + h:"" + h)) + ":" + (((mi < 10)?"0" + mi:"" + mi)) + ":" + (((s1 < 10)?"0" + s1:"" + s1));
				}
			}
			{
				Math["NaN"] = Number.NaN;
				Math["NEGATIVE_INFINITY"] = Number.NEGATIVE_INFINITY;
				Math["POSITIVE_INFINITY"] = Number.POSITIVE_INFINITY;
				Math["isFinite"] = function(i : Number) : Boolean {
					return isFinite(i);
				}
				Math["isNaN"] = function(i1 : Number) : Boolean {
					return isNaN(i1);
				}
			}
			{
				Xml.Element = "element";
				Xml.PCData = "pcdata";
				Xml.CData = "cdata";
				Xml.Comment = "comment";
				Xml.DocType = "doctype";
				Xml.Prolog = "prolog";
				Xml.Document = "document";
			}
			{
				var aproto : * = Array.prototype;
				aproto.copy = function() : * {
					return this.slice();
				}
				aproto.insert = function(i : *,x : *) : void {
					this.splice(i,0,x);
				}
				aproto.remove = function(obj : *) : Boolean {
					var idx : int = this.indexOf(obj);
					if(idx == -1) return false;
					this.splice(idx,1);
					return true;
				}
				aproto.iterator = function() : * {
					var cur : int = 0;
					var arr : Array = this;
					return { hasNext : function() : Boolean {
						return cur < arr.length;
					}, next : function() : * {
						return arr[cur++];
					}}
				}
				aproto.setPropertyIsEnumerable("copy",false);
				aproto.setPropertyIsEnumerable("insert",false);
				aproto.setPropertyIsEnumerable("remove",false);
				aproto.setPropertyIsEnumerable("iterator",false);
				String.prototype.charCodeAtHX = function(i1 : *) : * {
					var s : String = this;
					var x1 : Number = s.charCodeAt(i1);
					if(isNaN(x1)) return null;
					return Std._int(x1);
				}
			}
			AllClasses.main();
		}
	}
}
