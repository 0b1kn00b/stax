package stx;

import Stax.*;

import stx.Fail;
import Prelude;

class Enums {
	@doc("Creates an Enum.")
	@:noUsing static public inline function create<T>(e : Enum<T>, constr : String, ?params : Array<Dynamic>):T {
		return Type.createEnum(e, constr, params);
	}
	@doc("Produces the name of the Enum constructor at `index`.")
	static public inline function byIndex( e : Enum<Dynamic>, index : Int):String {
		return constructors(e)[index];
	}
	@doc("Produces the index of the EnumValue.")
	static public function toIndex( e : EnumValue ):Int {
		return Type.enumIndex(e);
	}
	@doc("Produces the name of the constructor of `value`.")
	static public function constructor(value:EnumValue) : String {
		return Type.enumConstructor(value);
	}
	@doc("Produces the full equality of two Enums.")
	static public function equals<T>( a : EnumValue, b : EnumValue ):Bool {
		return Type.enumEq(a, b);
	}
	@doc("Produces the parameters for the given `value`.")
	static public function params( value : EnumValue ) : Array<Dynamic> {
		return try{
		 	Type.enumParameters(value); 
		}catch(e:Dynamic){
			[];
		}
	}
	@doc("Produces the Enum of the given `value`.")
	static public function toEnum( value : EnumValue ) : Enum<Dynamic> {
		return Type.getEnum(value);
	}
	@doc("Produces the names of the given Enum.")
	static public function constructors( e : Enum<Dynamic> ) : Array<String> {
		return Type.getEnumConstructs(e);
	}
	@doc("Produces the name of the given Enum.")
	static public function name( e : Enum<Dynamic> ) : String {
		return Type.getEnumName(e);
	}
	@doc("Produces an Enum from the given `name`.")
	static public function enumerify(name : String) : Enum<Dynamic> {
		return Type.resolveEnum(name);
	}
	@doc("Top level enum comparison, doesn't compare contents.")
	static public function alike<T:EnumValue>(e1:T,e2:T):Bool{
		return Enums.toIndex(e1) == Enums.toIndex(e2);
	}
	@doc('Produces parameter at index `i`.')
	static public function param(e:EnumValue,i:Int):Dynamic{
		return params(e)[i];
	}
}