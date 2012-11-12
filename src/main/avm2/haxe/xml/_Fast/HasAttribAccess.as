package haxe.xml._Fast {
	import flash.Boot;
	public dynamic class HasAttribAccess {
		public function HasAttribAccess(x : Xml = null) : void { if( !flash.Boot.skip_constructor ) {
			this.__x = x;
		}}
		
		public function resolve(name : String) : Boolean {
			if(this.__x.nodeType == Xml.Document) throw "Cannot access document attribute " + name;
			return this.__x.exists(name);
		}
		
		protected var __x : Xml;
	}
}
