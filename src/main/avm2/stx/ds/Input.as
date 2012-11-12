package stx.ds {
	public final class Input extends enum {
		public static const __isenum : Boolean = true;
		public function Input( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var EOF : Input = new Input("EOF",2);
		public static function El(e : *) : Input { return new Input("El",0,[e]); }
		public static var Empty : Input = new Input("Empty",1);
		public static var __constructs__ : Array = ["El","Empty","EOF"];;
	}
}
