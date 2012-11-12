package haxe.xml._Fast {
	import haxe.xml.Fast;
	import flash.Boot;
	public dynamic class NodeAccess {
		public function NodeAccess(x : Xml = null) : void { if( !flash.Boot.skip_constructor ) {
			this.__x = x;
		}}
		
		public function resolve(name : String) : haxe.xml.Fast {
			var x : Xml = this.__x.elementsNamed(name).next();
			if(x == null) {
				var xname : String = ((this.__x.nodeType == Xml.Document)?"Document":this.__x.getNodeName());
				throw xname + " is missing element " + name;
			}
			return new haxe.xml.Fast(x);
		}
		
		protected var __x : Xml;
	}
}
