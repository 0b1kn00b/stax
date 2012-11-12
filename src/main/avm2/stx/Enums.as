package stx {
	public class Enums {
		public function Enums() : void {
		}
		
		static public function create(e : Class,constr : String,params : Array = null) : * {
			return Type.createEnum(e,constr,params);
		}
		
		static public function ofIndex(e : Class,index : int) : String {
			return stx.Enums.constructors(e)[index];
		}
		
		static public function indexOf(e : enum) : int {
			return Type.enumIndex(e);
		}
		
		static public function constructorOf(value : enum) : String {
			return Type.enumConstructor(value);
		}
		
		static public function equals(a : enum,b : enum) : Boolean {
			return Type.enumEq(a,b);
		}
		
		static public function params(value : enum) : Array {
			return Type.enumParameters(value);
		}
		
		static public function ofValue(value : enum) : Class {
			return Type.getEnum(value);
		}
		
		static public function constructors(e : Class) : Array {
			return Type.getEnumConstructs(e);
		}
		
		static public function nameOf(e : Class) : String {
			return Type.getEnumName(e);
		}
		
		static public function enumOf(name : String) : Class {
			return Type.resolveEnum(name);
		}
		
		static public function alike(e1 : enum,e2 : enum) : Boolean {
			return stx.Enums.indexOf(e1) == stx.Enums.indexOf(e2);
		}
		
	}
}
