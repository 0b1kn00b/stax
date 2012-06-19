package stx;

/**
 * ...
 * @author 0b1kn00b
 */

class Enums {

	public function new() { }
	/**
	 * Creates an Enum
	 */
	public static inline function create<T>(e : Enum<T>, constr : String, ?params : Array<Dynamic>):T {
		return Type.createEnum(e, constr, params);
	}
	/**
	 * Produces the name of the Enum constructor at 'index'.
	 * @param	e
	 * @param	index
	 * @return
	 */
	public static inline function ofIndex( e : Enum<Dynamic>, index : Int):String {
		return constructors(e)[index];
	}
	/**
	 * Produces the index of the EnumValue
	 * @param	e
	 * @return
	 */
	public static function indexOf( e : EnumValue ):Int {
		return Type.enumIndex(e);
	}
	/**
	 * Produces the name of the constructor of 'value'
	 * @param	e
	 * @return
	 */
	public static function constructorOf(value:EnumValue) : String {
		return Type.enumConstructor(value);
	}
	/**
	 * Produces the full equality of two Enums.
	 */
	public static function equals<T>( a : EnumValue, b : EnumValue ):Bool {
		return Type.enumEq(a, b);
	}
	/**
	 * Produces the parameters for the given 'value'
	 * @param	e
	 * @return
	 */
	public static function params( value : EnumValue ) : Array<Dynamic> {
		return Type.enumParameters(value);
	}
	/**
	 * Produces the Enum of the given 'value'
	 * @param	o
	 * @return
	 */
	public static function ofValue( value : EnumValue ) : Enum<Dynamic> {
		return Type.getEnum(value);
	}
	/**
	 * Produces the names of the given Enum.
	 * @param	e
	 * @return
	 */
	public static function constructors( e : Enum<Dynamic> ) : Array<String> {
		return Type.getEnumConstructs(e);
	}
	/**
	 * Produces the name of the given Enum
	 * @param	e
	 * @return
	 */
	public static function nameOf( e : Enum<Dynamic> ) : String {
		return Type.getEnumName(e);
	}
	/**
	 * Produces an Enum from the given 'name'.
	 * @param	name
	 * @return
	 */
	public static function enumOf( name : String ) : Enum<Dynamic> {
		return Type.resolveEnum(name);
	}
	public static function alike(e1:EnumValue,e2:EnumValue):Bool{
		return Enums.indexOf(e1) == Enums.indexOf(e2);
	}
}