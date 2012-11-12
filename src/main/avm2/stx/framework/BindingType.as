package stx.framework {
	public final class BindingType extends enum {
		public static const __isenum : Boolean = true;
		public function BindingType( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var OneToMany : BindingType = new BindingType("OneToMany",1);
		public static var OneToOne : BindingType = new BindingType("OneToOne",0);
		public static var __constructs__ : Array = ["OneToOne","OneToMany"];;
	}
}
