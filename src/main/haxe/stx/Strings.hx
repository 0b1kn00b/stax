package stx;

import stx.Errors.*;
import stx.Prelude;

using stx.Maths;
using stx.Options;

using StringTools;

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
  static public function drop(v:String,n:Int):String{
    return v.substr(n);
  }
  static public function take(v:String,n:Int):String {
    return v.substr(0,n);
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
  static public function surround(l:String,r:String){
    return 
      function(v:String){
        return '$l$v$r';
      }
  }
  static public function join(with:String){
    return 
      function(before:String,after:String){
        return before + with + after;
      }
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
  static public function chunk(str: String, len: Int): Array<String> {
    var start = 0;
    var end   = (start + len).min(str.length);
    
    return if (end == 0) [];
     else {
       var prefix = str.substr(start, end);
       var rest   = str.substr(end);

       [prefix].concat(chunk(rest, len));
     }
  }
  static public function chars(str: String): Array<String> {
    var a = [];
    
    for (i in 0...str.length) {
      a.push(str.charAt(i));
    }
    
    return a;
  }
  static public function string(l: Iterable<String>): String {
    var o = '';
    for ( val in l) {
      o += val;
    }
    return o;
  }
  
  static public function toCamelCase(str: String): String {
    return SepAlphaPattern.map(str, function(e) { return e.matched(2).toUpperCase(); });
  }
  static public function fromCamelCase(str: String, sep: String): String {
    return AlphaUpperAlphaPattern.map(str, function(e) { return e.matched(1) + sep + e.matched(2).toLowerCase(); });
  }
  static public function split(st:String,sep:String):Array<String>{
    return st.split(sep);
  }
  public static function isEmpty(value : String):Bool{
    return value == null || value.length < 1;
  }
  public static function isNotEmpty(value : String) : Bool {
    return !isEmpty(value);
  }
  public static function isEmptyOrBlank(value : String) : Bool {
    return isEmpty(StringTools.trim(value));
  }
  public static function isNotEmptyOrBlank(value : String) : Bool {
    return isNotEmpty(StringTools.trim(value));
  }
  public static function pure() : String {
    return "";
  }
  public static function uuid(value : String = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx') : String {
    var reg = ~/[xy]/g;
    return reg.map(value, function(reg) {
        var r = Std.int(Math.random() * 16) | 0;
        var v = reg.matched(0) == 'x' ? r : (r & 0x3 | 0x8);
        return v.hex();
    }).toLowerCase();
  }
  public static function iterator(value : String) : Iterator<String> {
    var index = 0;
    return {
        hasNext: function() {
            return index < value.length;
        },
        next: function() {
            return if (index < value.length) {
                value.substr(index++, 1);
            } else {
                Prelude.err()(out_of_bounds_error());
            }
        }
    };
  }
}
class ERegs{
  static public function replace(s:String,reg:EReg,with:String):String {
    return reg.replace(s,with);
  }
  static public function matches(reg:EReg):Array<String>{
    var out = [];
    var idx = 0;
    var val = null;

    while(true){
      try{
        val = reg.matched(idx);
      }catch(e:Dynamic){
        break;
      }
      out.push(val);
      idx++;
    }
    return out;
  }
}