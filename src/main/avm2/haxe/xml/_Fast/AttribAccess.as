package haxe.xml._Fast {
	import flash.Boot;
	public dynamic class AttribAccess {
		public function AttribAccess(x : Xml = null) : void { if( !flash.Boot.skip_constructor ) {
			this.__x = x;
		}}
		
		public function resolve(name : String) : String {
			if(this.__x.nodeType == Xml.Document) throw "Cannot access document attribute " + name;
			var v : String = this.__x.get(name);
			if(v == null) throw this.__x.getNodeName() + " is missing attribute " + name;
			return v;
		}
		
		protected var __x : Xml;
	}
}
