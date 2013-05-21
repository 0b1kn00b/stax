package stx.plus;

import haxe.CallStack;
import Type;
import stx.Maths;


using stx.Options;
using stx.Prelude;
using stx.Tuples;
using stx.plus.Show;
using stx.Compose;

typedef ShowFunction<T>         = Function1<T, String>;

class Show {
  static public function show<A>(v:A):String{
    return getShowFor(v)(v);
  }
  static public function __show__<T>(impl : ShowFunction<Dynamic>) : ShowFunction<T> {
    return function(v) return null == v ? 'null' : impl(v);
  }
  /** Returns a ShowFunction (T -> String). It works for any type. For Custom Classes you must provide a toString()
   * method, otherwise the full class name is returned.
   */
  public static function getShowFor<T>(t : T) : ShowFunction<T> {
    return getShowForType(Type.typeof(t));
  }
  
  /**
   *  @:todo Reflect.fields doesn't work consistenly across platforms so we may probably pass to use Type.getInstanceFields. The problem here
   *  is that we must check if the fields are functions before grabbing the value.
   */
  public static function getShowForType<T>(v : ValueType) : ShowFunction<T> {
    return switch(v) {
      case TBool                        : __show__(BoolShow.toString);
      case TInt                         : __show__(IntShow.toString);
      case TFloat                       : __show__(FloatShow.toString);
      case TUnknown                     : __show__(function(v) return '<unknown>');
      case TObject                      : __show__(ObjectShow.toString);
      case TEnum(_)                     : __show__(EnumShow.toString);
      case TClass(c) if(c == String)    : __show__(Strings.toString);
      case TClass(c) if(c == Array)     : __show__(ArrayShow.toString);
      case TClass(c)                    : 
          if(Type.getInstanceFields(c).remove("toString")){
            __show__(function(v) return Reflect.callMethod(v, Reflect.field(v, "toString"), []));
          }else{
            __show__(function(v) return Type.getClassName(Type.getClass(v)));
          }
      case TNull                        : NullShow.toString;
      case TFunction                    : __show__(function(v) return '<function>');
    }
  }
}
class NullShow{
  static public function toString<A>(v:A):String{
    return "null";
  }
}
class EnumShow{
  static public function toString(v:Dynamic):String {
    var buf = Type.enumConstructor(v);
    var params = Type.enumParameters(v);
    if(params.length == 0)
      return buf;
    else {
    buf +="(";
    for(p in params)
      buf += Show.getShowFor(p)(p);
    return buf + ")";
    }
  }
}
class ObjectShow {
  static public function toString(v:Dynamic):String{
    var buf = [];
    for(k in Reflect.fields(v)) {
      var i = Reflect.field(v, k);
      buf.push(k + ":" + Show.getShowFor(i)(i));
    }
    return "{" + buf.join(",") + "}";
  }
}
class ArrayShow {
	public static function toString<T>(v: Array<T>) {
    return toStringWith(v, Show.getShowFor(v[0]));
  }
  public static function toStringWith<T>(v: Array<T>, show : ShowFunction<T>) {
    return "[" + v.map(show).join(", ") + "]";  
  }

	public static function mkString<T>(arr: Array<T>, ?sep: String = ', ', ?show: T -> String): String {
    var isFirst = true;
    
    return arr.foldl('', function(a, b) {
      var prefix = if (isFirst) { isFirst = false; ''; } else sep;    
      if(null == show)
      show = Show.getShowFor(b);
      return a + prefix + show(b);
    });
  }
}
class IterableShow {
	public static function toString<T>(i: Iterable<T>, ?show: T -> String, ?prefix: String = '(', ?suffix: String = ')', ?sep = ', ') {
    return mkString(i, show, prefix, suffix, sep);
  }
  
  public static function mkString<T>(i: Iterable<T>, ?show: T -> String, ?prefix: String = '(', ?suffix: String = ')', ?sep = ', ') {
    if (show == null) show = Std.string;
    
    var s = prefix;
    
    var isFirst = true;

    for (t in i) {
      if (isFirst) isFirst = false; else s += sep;
      
      s += show(t);
    }
    
    return s + suffix;
  }
}
class BoolShow {
	public static function toString(v : Bool) : String {
    return if (v) "true" else "false";  
  }
}
class IntShow {
	public static function toString(v: Int) : String {
    return "" + v;
  }
}
class FloatShow {
	public static function toString(v: Float) : String {
    return "" + v;
  }
}
class StackItemShow{
  static public function toString(s:StackItem){
    return 
      switch (s){
        case CFunction                      : 'function';
        case Module( m )                    : m;
        case FilePos( si , _ , line )       : toString(si) + ':$line';
        case Method( classname , method )   : '$classname.$method';
        case Lambda( v )                    : '@$v';
      }
  }
}