package stx;

import Stax.*;

import stx.Fail;
 
import Prelude;

using stx.Maths;
using stx.Option;

using StringTools;

class Strings {
  @doc("Unit function.")
  @:noUsing static public function unit():String{
    return '';
  }
  static var SepAlphaPattern        = ~/(-|_)([a-z])/g;
  static var AlphaUpperAlphaPattern = ~/-([a-z])([A-Z])/g;

  @doc("Returns `true` if `v` is `'true'` or `'1'`, `false` if `'false'` or `'0'` and `d` otherwise.")
  static public function toBool(v: String, ?d: Bool): Bool {
    if (v == null) return d;
    
    var vLower = v.toLowerCase();
    
    return (if (vLower == 'false' || v == '0') Some(false) else if (vLower == 'true' || v == '1') Some(true) else None).getOrElseC(d);
  }
  @doc("Returns an Int from String format, defaulting to `d`.")
  static public function int(v: String, ?d: Null<Int>): Int {
    if (v == null) return d;
    
    return option(Std.parseInt(v)).filter(function(i) return !Math.isNaN(i)).getOrElseC(d);
  }
  @doc("Returns a Float from String format, defaulting to `d`.")
  static public function toFloat(v: String, ?d: Null<Float>): Float { 
    if (v == null) return d;
    
    return option(Std.parseFloat(v)).filter(function(i) return !Math.isNaN(i)).getOrElseC(d);
  }
  @doc("Returns `true` if `frag` is at the beginning of `v`, `false` otherwise.")
  static public function startsWith(v: String, frag: String): Bool {
    return if (v.length >= frag.length && frag == v.substr(0, frag.length)) true else false;
  }
  @doc("Returns `true` if `frag` is at the end of `v`, `false` otherwise.")
  static public function endsWith(v: String, frag: String): Bool {
    return if (v.length >= frag.length && frag == v.substr(v.length - frag.length)) true else false;
  }
  @doc("Returns `v` as a url encoded String.")
  static public function urlEncode(v: String): String {
    return StringTools.urlEncode(v);
  }
  @doc("Decodes a url encoded String.")
  static public function urlDecode(v: String): String {
    return StringTools.urlDecode(v);
  } 
  @doc("Escapes an html encoded String.")
  static public function htmlEscape(v: String): String {
    return StringTools.htmlEscape(v);
  }
  @doc("Unescapes an html encoded String.")
  static public function htmlUnescape(v: String): String {
    return StringTools.htmlUnescape(v);
  }
  @doc("Removes spaces either side of the `s`.")
  static public function trim(v: String): String {
    return StringTools.trim(v);
  }
  static public function dropLeft(v:String,n:Int):String{
    return v.substr(n);
  }
  static public function take(v:String,n:Int):String {
    return v.substr(0,n);
  }
  @doc("Returns true if v contains s, false otherwise.")
  static public function contains(v: String, s: String): Bool {
    return v.indexOf(s) != -1;
  }
  @doc("Returns a String where sub is replaced by by in s.")
  static public function replace( s : String, sub : String, by : String ) : String {
    return StringTools.replace(s, sub, by);
  }
  @doc("Returns 0 if v1 equals v2, 1 if v1 is bigger than v2, or .1 if v1 is smaller than v2.")
  static public function compare(v1: String, v2: String) { 
  return (v1 == v2) ? 0 : (v1 > v2 ? 1 : -1);
  }
  @doc("Returns true if v1 equals v2, flase otherwise.")
  static public function equals(v1: String, v2: String) {
    return v1 == v2;
  }
  @doc("Identity function.")
  static public function toString(v: String): String {
    return v;
  }
  @doc("Surrounds `v`, prepending `l` and appending `r`.")
  static public function surrounder(l:String,r:String,v:String){
    return '$l$v$r';
  }
  @doc("prepend `before` on `str.`")
  static public function prepend(str:String,before:String){
    return before + str;
  }
  @doc("append `before` on `str.`")
  static public function append(str:String,after:String){
    return str + after;
  }
  @doc("Get character code from `str` at index `i`.")
  static public function cca(str:String,i:Int){
    return str.charCodeAt(i);
  }
  static public function at(str:String,i:Int):String{
    return str.charAt(i);
  }
  @doc("Returns an Array of `str` divided into sections of length `len`.")
  static public function chunk(str: String, len: Int = 1): Array<String> {
    var start = 0;
    var end   = (start + len).min(str.length);
    
    return if (end == 0) [];
     else {
       var prefix = str.substr(start, end);
       var rest   = str.substr(end);

       [prefix].concat(chunk(rest, len));
     }
  }
  @doc("Returns an Array of the characters of `str`.")
  static public function chars(str: String): Array<String> {
    var a = [];
    
    for (i in 0...str.length) {
      a.push(str.charAt(i));
    }
    
    return a;
  }
  @doc("Returns a seamless joined string of `l`.")
  static public function string(l: Iterable<String>): String {
    var o = '';
    for ( val in l) {
      o += val;
    }
    return o;
  }
  @doc("Turns a slugged or underscored string into a camelCase string.")
  static public function toCamelCase(str: String): String {
    return SepAlphaPattern.map(str, function(e) { return e.matched(2).toUpperCase(); });
  }
  @doc("Replaces uppercased letters with prefix `sep` + lowercase.")
  static public function fromCamelCase(str: String, sep: String): String {
    return AlphaUpperAlphaPattern.map(str, function(e) { return e.matched(1) + sep + e.matched(2).toLowerCase(); });
  }
  @doc("Split `st` at `sep`.")
  static public function split(st:String,sep:String):Array<String>{
    return st.split(sep);
  }
  @doc("Determines empty string.")
  static public function isEmpty(value : String):Bool{
    return value == null || value.length < 1;
  }
  @doc("Determines empty string.")
  static public function isNotEmpty(value : String) : Bool {
    return !isEmpty(value);
  }
  @doc("Determines empty string, or string with only spaces.")
  static public function isEmptyOrBlank(value : String) : Bool {
    return isEmpty(StringTools.trim(value));
  }
  @doc("Does what it says on the tin.")
  static public function isNotEmptyOrBlank(value : String) : Bool {
    return isNotEmpty(StringTools.trim(value));
  }
  @doc("Strip whitespace out of a string.")
  static public function stripWhite( s : String ) : String {
    var l = s.length;
    var i = 0;
    var sb = new StringBuf();
    while( i < l ) {
      if(!isSpace(s, i))
        sb.add(s.charAt(i));
      i++;
    }
    return sb.toString();
  }
  @doc("Continues to replace `sub` with `by` until no more instances of `sub` exist.")
  static public function replaceRecurse( s : String, sub : String, by : String ) : String {
    if(sub.length == 0)
      return replace(s, sub, by);
    if(by.indexOf(sub) >= 0)
      throw "Infinite recursion";
    var ns : String = s.toString();
    var olen = 0;
    var nlen = ns.length;
    while(olen != nlen) {
      olen = ns.length;
      replace( ns, sub, by );
      nlen = ns.length;
    }
    return ns;
  }
  @doc("Returns a unique identifier, each `x` replaced with a hex character.")
  static public function uuid(value : String = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx') : String {
    var reg = ~/[xy]/g;
    return reg.map(value, function(reg) {
        var r = Std.int(Math.random() * 16) | 0;
        var v = reg.matched(0) == 'x' ? r : (r & 0x3 | 0x8);
        return v.hex();
    }).toLowerCase();
  }
  @doc("Returns an iterator of `value`.")
  static public function iterator(value : String) : Iterator<String> {
    var index = 0;
    return {
        hasNext: function() {
            return index < value.length;
        },
        next: function() {
            return if (index < value.length) {
                value.substr(index++, 1);
            } else {
                except()(OutOfBoundsError());
            }
        }
    };
  }
  static public function camelCaseToDashes(value : String) : String {
    var regexp = new EReg("([a-zA-Z])(?=[A-Z])", "g");
    return regexp.replace(value, "$1-");
  }

  static public function camelCaseToLowerCase(value : String, ?separator : String = "_") : String {
    var reg = new EReg("([^\\A])([A-Z])", "g");
    return reg.replace(value, "$1${separator}$2").toLowerCase();
  }
  static public function camelCaseToUpperCase(value : String, ?separator : String = "_") : String {
    var reg = new EReg("([^\\A])([A-Z])", "g");
    return reg.replace(value, "$1${separator}$2").toUpperCase();
  }
  static public function isSpace( s : String, pos : Int ) : Bool {
    var c = s.charCodeAt( pos );
    return (c >= 9 && c <= 13) || c == 32;
  }
  static public inline function chr(i:Int){
    return String.fromCharCode(i);
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