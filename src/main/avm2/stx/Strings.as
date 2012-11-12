package stx {
	import stx.Ints;
	import stx.Option;
	import stx.Options;
	public class Strings {
		static protected var SepAlphaPattern : EReg = new EReg("(-|_)([a-z])","g");
		static protected var AlphaUpperAlphaPattern : EReg = new EReg("-([a-z])([A-Z])","g");
		static public function toBool(v : String,d : * = null) : Boolean {
			if(v == null) return d;
			var vLower : String = v.toLowerCase();
			return stx.Options.getOrElseC(((vLower == "false" || v == "0")?stx.Option.Some(false):((vLower == "true" || v == "1")?stx.Option.Some(true):stx.Option.None)),d);
		}
		
		static public function _int(v : String,d : * = null) : int {
			if(v == null) return d;
			return stx.Options.getOrElseC(stx.Options.filter(stx.Options.create(Std._parseInt(v)),function(i : *) : Boolean {
				return !Math["isNaN"](i);
			}),d);
		}
		
		static public function toFloat(v : String,d : * = null) : Number {
			if(v == null) return d;
			return stx.Options.getOrElseC(stx.Options.filter(stx.Options.create(Std._parseFloat(v)),function(i : Number) : Boolean {
				return !Math["isNaN"](i);
			}),d);
		}
		
		static public function startsWith(v : String,frag : String) : Boolean {
			return ((v.length >= frag.length && frag == v.substr(0,frag.length))?true:false);
		}
		
		static public function endsWith(v : String,frag : String) : Boolean {
			return ((v.length >= frag.length && frag == v.substr(v.length - frag.length))?true:false);
		}
		
		static public function urlEncode(v : String) : String {
			return StringTools.urlEncode(v);
		}
		
		static public function urlDecode(v : String) : String {
			return StringTools.urlDecode(v);
		}
		
		static public function htmlEscape(v : String) : String {
			return StringTools.htmlEscape(v);
		}
		
		static public function htmlUnescape(v : String) : String {
			return StringTools.htmlUnescape(v);
		}
		
		static public function trim(v : String) : String {
			return StringTools.trim(v);
		}
		
		static public function contains(v : String,s : String) : Boolean {
			return v.indexOf(s) != -1;
		}
		
		static public function replace(s : String,sub : String,by : String) : String {
			return StringTools.replace(s,sub,by);
		}
		
		static public function compare(v1 : String,v2 : String) : int {
			return ((v1 == v2)?0:((v1 > v2)?1:-1));
		}
		
		static public function equals(v1 : String,v2 : String) : Boolean {
			return v1 == v2;
		}
		
		static public function toString(v : String) : String {
			return v;
		}
		
		static public function surround(str : String,before : String,after : String) : String {
			return before + str + after;
		}
		
		static public function prepend(str : String,before : String) : String {
			return before + str;
		}
		
		static public function append(str : String,after : String) : String {
			return str + after;
		}
		
		static public function cca(str : String,i : int) : * {
			return str["charCodeAtHX"](i);
		}
		
		static public function chunk(str : String,len : int) : Array {
			var start : int = 0;
			var end : int = stx.Ints.min(start + len,str.length);
			return ((end == 0)?[]:function() : Array {
				var $r : Array;
				var prefix : String = str.substr(start,end);
				var rest : String = str.substr(end);
				$r = [prefix].concat(stx.Strings.chunk(rest,len));
				return $r;
			}());
		}
		
		static public function chars(str : String) : Array {
			var a : Array = [];
			{
				var _g1 : int = 0, _g : int = str.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					a.push(str.charAt(i));
				}
			}
			return a;
		}
		
		static public function string(l : *) : String {
			var o : String = "";
			{ var $it : * = l.iterator();
			while( $it.hasNext() ) { var val : String = $it.next();
			o += val;
			}}
			return o;
		}
		
		static public function toCamelCase(str : String) : String {
			return stx.Strings.SepAlphaPattern.customReplace(str,function(e : EReg) : String {
				return e.matched(2).toUpperCase();
			});
		}
		
		static public function fromCamelCase(str : String,sep : String) : String {
			return stx.Strings.AlphaUpperAlphaPattern.customReplace(str,function(e : EReg) : String {
				return e.matched(1) + sep + e.matched(2).toLowerCase();
			});
		}
		
	}
}
