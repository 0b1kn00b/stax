package stx;

/**
 * ...
 * @author 0b1kn00b
 */

class Enums {

	public static function create() {
		return new Enums();
	}
	public function new() { }
	
	public function construct<T>(e : Enum<T>, constr : String, ?params : Array<Dynamic>):T {
		return Type.createEnum(e, constr, params);
	}
	public function ofindex( e : Enum<Dynamic>, index : Int):String {
		return constructors(e)[index];
	}
	public function constructorof(e:Dynamic) : String {
		return Type.enumConstructor(e);
	}
	public function equals<T>( a : T, b : T ):Bool {
		return Type.enumEq(a, b);
	}
	public function params( e : Dynamic ) : Array<Dynamic> {
		return Type.enumParameters(e);
	}
	public function get( o : Dynamic ) : Enum<Dynamic> {
		return Type.getEnum(o);
	}
	public function constructors( e : Enum<Dynamic> ) : Array<String> {
		return Type.getEnumConstructs(e);
	}
	public function name( e : Enum<Dynamic> ) : String {
		return Type.getEnumName(e);
	}
	public function resolve( name : String ) : Enum<Dynamic> {
		return Type.resolveEnum(name);
	}
}