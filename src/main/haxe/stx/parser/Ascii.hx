package stx.parser;
import Prelude;
/**
 * ...
 * @author 0b1kn00b
 */
import stx.Parser;

using stx.parser.StringParsers;

using stx.Parser;

using stx.parser.Ascii;

class Ascii {
	public static function range(min:Int, max:Int):String->Bool {
		return function(s:String):Bool {
			var x = s.charCodeAt(0);
			return (x >= min) && (x <= max);
		}
	}
	//public static var many = ParseExtend.anything;
	public static function mergeString(a:String,b:String){
		return a + b;
	}
	public static function mergeOption(a:String, b:Option<String>) {
		return switch (b) { case Some(v) : a += v ; default : '';} return a; 
	}
	public static function id(s:String) {
		return StringParsers.identifier(s);
	}
	public static var lower				= range(97, 122).predicated();
	public static var upper				= range(65, 90).predicated();
	
	public static var alpha				= Parsers.or(upper,lower);
	public static var digit				= range(48, 57).predicated();
	public static var alphanum		= alpha.or(digit);
	public static var ascii				= range(0, 255).predicated();
	
	public static var valid				= alpha.or(digit).or('_'.id());
	
	public static var tab					= '	'.id();
	public static var space				= ' '.id();
	
	public static var nl					= '\n'.id().or('\r'.id()._and('\n'.id()));
	public static var gap					= [tab, space].ors();

	public static var camel 			= lower.andWith(word, mergeString);
	public static var word				= lower.or(upper).oneMany().token();//[a-z]*
	public static var quote				= '"'.id().or("'".id());
	public static var escape			= '\\'.id();
	public static var not_escaped	= '\\\\'.id();
	
	public static var x 					= not_escaped.not()._and(escape);
	public static var x_quote 		= x._and(quote);
	
 	public static var whitespace	= range(0, 33).predicated();
	
	//TODO test
	// http://wordaligned.org/articles/string-literals-and-regular-expressions
	public static var literalR		= ~/"([^"\\\\]|\\\\.)*"/;
	public static var literal 		= literalR.regexParser();
	
	public static function spaced( p : Void -> Parser<String,String> ) {
		return p.and_(gap.many());
	}
	public static function returned(p : Void -> Parser<String,String>) {
		return p.and_(whitespace.many());
	}
	public static function pnt<I,O>(p:Void->Parser<I,O>):Void->Parser<I,O>{
		return p.trace( function(x) return Std.string(x));
	}
}