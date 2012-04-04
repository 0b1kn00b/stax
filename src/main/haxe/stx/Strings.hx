package stx;

/**
 * ...
 * @author 0b1kn00b
 */
using stx.Maths;
using stx.Options;

import Prelude;

class Strings {
  static public function toBool(v: String, ?d: Bool): Bool {
    if (v == null) return d;
    
    var vLower = v.toLowerCase();
    
    return (if (vLower == 'false' || v == '0') Some(false) else if (vLower == 'true' || v == '1') Some(true) else None).getOrElseC(d);
  }
  static public function int(v: String, ?d: Null<Int>): Int {
    if (v == null) return d;
    
    return Std.parseInt(v).toOption().filter(function(i) return !Math.isNaN(i)).getOrElseC(d);
  }
  static public function toFloat(v: String, ?d: Null<Float>): Float { 
    if (v == null) return d;
    
    return Std.parseFloat(v).toOption().filter(function(i) return !Math.isNaN(i)).getOrElseC(d);
  }
  static public function startsWith(v: String, frag: String): Bool {
    return if (v.length >= frag.length && frag == v.substr(0, frag.length)) true else false;
  }
  static public function endsWith(v: String, frag: String): Bool {
    return if (v.length >= frag.length && frag == v.substr(v.length - frag.length)) true else false;
  }
  static public function urlEncode(v: String): String {
    return StringTools.urlEncode(v);
  }
  static public function urlDecode(v: String): String {
    return StringTools.urlDecode(v);
  }  
  static public function htmlEscape(v: String): String {
    return StringTools.htmlEscape(v);
  }
  static public function htmlUnescape(v: String): String {
    return StringTools.htmlUnescape(v);
  }
  static public function trim(v: String): String {
    return StringTools.trim(v);
  }
  static public function contains(v: String, s: String): Bool {
    return v.indexOf(s) != -1;
  }
  static public function replace( s : String, sub : String, by : String ) : String {
    return StringTools.replace(s, sub, by);
  }    
  static public function compare(v1: String, v2: String) { 
  return (v1 == v2) ? 0 : (v1 > v2 ? 1 : -1);
  }
  static public function equals(v1: String, v2: String) {
    return v1 == v2;
  }
  static public function toString(v: String): String {
    return v;
  }
	static public function surround(str:String,before:String,after:String){
		return before + str + after;
	}
	static public function prepend(str:String,before:String){
		return before + str;
	}
	static public function append(str:String,after:String){
		return str + after;
	}
}