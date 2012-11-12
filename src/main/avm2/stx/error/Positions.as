package stx.error {
	public class Positions {
		static public function toString(pos : *) : String {
			if(pos == null) return "nil";
			var type : Array = pos.className.split(".");
			return type[type.length - 1] + "::" + pos.methodName + "#" + pos.lineNumber;
		}
		
		static public function here(pos : * = null) : * {
			return pos;
		}
		
	}
}
