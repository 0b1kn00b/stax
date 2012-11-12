package haxe.xml._Fast {
	import haxe.xml.Fast;
	import flash.Boot;
	public dynamic class NodeListAccess {
		public function NodeListAccess(x : Xml = null) : void { if( !flash.Boot.skip_constructor ) {
			this.__x = x;
		}}
		
		public function resolve(name : String) : List {
			var l : List = new List();
			{ var $it : * = this.__x.elementsNamed(name);
			while( $it.hasNext() ) { var x : Xml = $it.next();
			l.add(new haxe.xml.Fast(x));
			}}
			return l;
		}
		
		protected var __x : Xml;
	}
}
