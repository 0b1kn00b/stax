package stx;

using stx.Maths;
using stx.Options;

import stx.Prelude;

class Strings {
  static var SepAlphaPattern        = ~/(-|_)([a-z])/g;
  static var AlphaUpperAlphaPattern = ~/-([a-z])([A-Z])/g;

  /**
  * Returns true if v is 'true' or '1', false if 'false' or '0' and d otherwise.
  */
  static public function toBool(v: String, ?d: Bool): Bool {
    if (v == null) return d;
    
    var vLower = v.toLowerCase();
    
    return (if (vLower == 'false' || v == '0') Some(false) else if (vLower == 'true' || v == '1') Some(true) else None).getOrElseC(d);
  }
  /**
  * Returns an Int from String format, defaulting to d
  */
  static public function int(v: String, ?d: Null<Int>): Int {
    if (v == null) return d;
    
    return Std.parseInt(v).toOption().filter(function(i) return !Math.isNaN(i)).getOrElseC(d);
  }
  /**
  * Returns a Float from String format, defaulting to d
  */
  static public function toFloat(v: String, ?d: Null<Float>): Float { 
    if (v == null) return d;
    
    return Std.parseFloat(v).toOption().filter(function(i) return !Math.isNaN(i)).getOrElseC(d);
  }
  /**
  * Returns true if frag is at the beginning of String v, false otherwise.
  */
  static public function startsWith(v: String, frag: String): Bool {
    return if (v.length >= frag.length && frag == v.substr(0, frag.length)) true else false;
  }
  /**
  * Returns truw if frag is at the end of String v, false otherwise
  */
  static public function endsWith(v: String, frag: String): Bool {
    return if (v.length >= frag.length && frag == v.substr(v.length - frag.length)) true else false;
  }
  /*
  * Returns v as a url encoded String.
  */
  static public function urlEncode(v: String): String {
    return StringTools.urlEncode(v);
  }
  /*
  * Decodes a url encoded String.
  */
  static public function urlDecode(v: String): String {
    return StringTools.urlDecode(v);
  } 
  /*
  * Escapes an html encoded String.
  */
  static public function htmlEscape(v: String): String {
    return StringTools.htmlEscape(v);
  }
  /*
  * Unescapes an html encoded String.
  */
  static public function htmlUnescape(v: String): String {
    return StringTools.htmlUnescape(v);
  }
  /*
  * Removes spaces either side of the String s.
  */
  static public function trim(v: String): String {
    return StringTools.trim(v);
  }
  /**
  * Returns true if v contains s, false otherwise.
  */
  static public function contains(v: String, s: String): Bool {
    return v.indexOf(s) != -1;
  }
  /*
  * Returns a String where sub is replaced by by in s
  */
  static public function replace( s : String, sub : String, by : String ) : String {
    return StringTools.replace(s, sub, by);
  }
  /*
  * Returns 0 if v1 equals v2, 1 if v1 is bigger than v2, or .1 if v1 is smaller than v2
  */
  static public function compare(v1: String, v2: String) { 
  return (v1 == v2) ? 0 : (v1 > v2 ? 1 : -1);
  }
  /**
  * Returns true if v1 equals v2, flase otherwise.
  */
  static public function equals(v1: String, v2: String) {
    return v1 == v2;
  }
  /**
  * Identity function.
  */
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
  static public function cca(str:String,i:Int){
    return str.charCodeAt(i);
  }

  public static function chunk(str: String, len: Int): Array<String> {
    var start = 0;
    var end   = (start + len).min(str.length);
    
    return if (end == 0) [];
     else {
       var prefix = str.substr(start, end);
       var rest   = str.substr(end);

       [prefix].concat(chunk(rest, len));
     }
  }
  public static function chars(str: String): Array<String> {
    var a = [];
    
    for (i in 0...str.length) {
      a.push(str.charAt(i));
    }
    
    return a;
  }
  public static function string(l: Iterable<String>): String {
    var o = '';
    for ( val in l) {
      o += val;
    }
    return o;
  }
  
  public static function toCamelCase(str: String): String {
    return SepAlphaPattern.customReplace(str, function(e) { return e.matched(2).toUpperCase(); });
  }
  
  public static function fromCamelCase(str: String, sep: String): String {
    return AlphaUpperAlphaPattern.customReplace(str, function(e) { return e.matched(1) + sep + e.matched(2).toLowerCase(); });
  }
}