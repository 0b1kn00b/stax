package haxe.xml {
	import haxe.xml._Fast.AttribAccess;
	import haxe.xml._Fast.HasNodeAccess;
	import haxe.xml._Fast.NodeListAccess;
	import haxe.xml._Fast.HasAttribAccess;
	import haxe.xml._Fast.NodeAccess;
	import flash.Boot;
	public class Fast {
		public function Fast(x : Xml = null) : void { if( !flash.Boot.skip_constructor ) {
			if(x.nodeType != Xml.Document && x.nodeType != Xml.Element) throw "Invalid nodeType " + Std.string(x.nodeType);
			this.x = x;
			this.node = new haxe.xml._Fast.NodeAccess(x);
			this.nodes = new haxe.xml._Fast.NodeListAccess(x);
			this.att = new haxe.xml._Fast.AttribAccess(x);
			this.has = new haxe.xml._Fast.HasAttribAccess(x);
			this.hasNode = new haxe.xml._Fast.HasNodeAccess(x);
		}}
		
		public function getElements() : * {
			var it : * = this.x.elements();
			return { hasNext : it.hasNext, next : function() : haxe.xml.Fast {
				var x : Xml = it.next();
				if(x == null) return null;
				return new haxe.xml.Fast(x);
			}}
		}
		
		public function getInnerHTML() : String {
			var s : StringBuf = new StringBuf();
			{ var $it : * = this.x.iterator();
			while( $it.hasNext() ) { var x : Xml = $it.next();
			s.add(x.toString());
			}}
			return s.toString();
		}
		
		public function getInnerData() : String {
			var it : * = this.x.iterator();
			if(!it.hasNext()) throw this.getName() + " does not have data";
			var v : Xml = it.next();
			var n : Xml = it.next();
			if(n != null) {
				if(v.nodeType == Xml.PCData && n.nodeType == Xml.CData && StringTools.trim(v.getNodeValue()) == "") {
					var n2 : Xml = it.next();
					if(n2 == null || n2.nodeType == Xml.PCData && StringTools.trim(n2.getNodeValue()) == "" && it.next() == null) return n.getNodeValue();
				}
				throw this.getName() + " does not only have data";
			}
			if(v.nodeType != Xml.PCData && v.nodeType != Xml.CData) throw this.getName() + " does not have data";
			return v.getNodeValue();
		}
		
		public function getName() : String {
			return ((this.x.nodeType == Xml.Document)?"Document":this.x.getNodeName());
		}
		
		public function get elements() : * { return getElements(); }
		protected function set elements( __v : * ) : void { $elements = __v; }
		protected var $elements : *;
		public var hasNode : haxe.xml._Fast.HasNodeAccess;
		public var has : haxe.xml._Fast.HasAttribAccess;
		public var att : haxe.xml._Fast.AttribAccess;
		public var nodes : haxe.xml._Fast.NodeListAccess;
		public var node : haxe.xml._Fast.NodeAccess;
		public function get innerHTML() : String { return getInnerHTML(); }
		protected function set innerHTML( __v : String ) : void { $innerHTML = __v; }
		protected var $innerHTML : String;
		public function get innerData() : String { return getInnerData(); }
		protected function set innerData( __v : String ) : void { $innerData = __v; }
		protected var $innerData : String;
		public function get name() : String { return getName(); }
		protected function set name( __v : String ) : void { $name = __v; }
		protected var $name : String;
		public var x : Xml;
	}
}
