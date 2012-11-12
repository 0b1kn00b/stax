package  {
	public class Xml {
		public function Xml() : void {
		}
		
		public function toString() : String {
			XML.prettyPrinting = false;
			if(this.nodeType == Xml.Document) {
				var str : String = this._node.toXMLString();
				str = str.substr(str.indexOf(">") + 1);
				str = str.substr(0,str.length - 13);
				return str;
			}
			return this._node.toXMLString();
		}
		
		public function insertChild(x : Xml,pos : int) : void {
			if(this.nodeType != Xml.Element && this.nodeType != Xml.Document) throw "bad nodeType";
			var children : XMLList = this._node.children();
			if(pos < children.length()) this._node.insertChildBefore(children[pos],x._node);
			else this._node.appendChild(x._node);
		}
		
		public function removeChild(x : Xml) : Boolean {
			if(this.nodeType != Xml.Element && this.nodeType != Xml.Document) throw "bad nodeType";
			var children : XMLList = this._node.children();
			if(this._node != x._node.parent()) return false;
			var i : int = x._node.childIndex();
			delete(children[Reflect.fields(children)[i]]);
			return true;
		}
		
		public function addChild(x : Xml) : void {
			if(this.nodeType != Xml.Element && this.nodeType != Xml.Document) throw "bad nodeType";
			var children : XMLList = this._node.children();
			this._node.appendChild(x._node);
		}
		
		public function firstElement() : Xml {
			if(this.nodeType != Xml.Element && this.nodeType != Xml.Document) throw "bad nodeType";
			var elements : XMLList = this._node.elements();
			if(elements.length() == 0) return null;
			return Xml.wrap(elements[0]);
		}
		
		public function firstChild() : Xml {
			if(this.nodeType != Xml.Element && this.nodeType != Xml.Document) throw "bad nodeType";
			var children : XMLList = this._node.children();
			if(children.length() == 0) return null;
			return Xml.wrap(children[0]);
		}
		
		public function elementsNamed(name : String) : * {
			if(this.nodeType != Xml.Element && this.nodeType != Xml.Document) throw "bad nodeType";
			var ns : Array = name.split(":");
			var elements : XMLList;
			if(ns.length == 1) elements = this._node.elements(name);
			else elements = this._node.elements();
			var wrappers : Array = this.wraps(elements);
			if(ns.length != 1) {
				var _g : int = 0, _g1 : Array = wrappers.copy();
				while(_g < _g1.length) {
					var w : Xml = _g1[_g];
					++_g;
					if(w._node.localName() != ns[1] || w._node.namespace().prefix != ns[0]) wrappers.remove(w);
				}
			}
			var cur : int = 0;
			return { hasNext : function() : Boolean {
				return cur < wrappers.length;
			}, next : function() : Xml {
				return wrappers[cur++];
			}}
		}
		
		public function elements() : * {
			if(this.nodeType != Xml.Element && this.nodeType != Xml.Document) throw "bad nodeType";
			var elements : XMLList = this._node.elements();
			var wrappers : Array = this.wraps(elements);
			var cur : int = 0;
			return { hasNext : function() : Boolean {
				return cur < wrappers.length;
			}, next : function() : Xml {
				return wrappers[cur++];
			}}
		}
		
		public function iterator() : * {
			if(this.nodeType != Xml.Element && this.nodeType != Xml.Document) throw "bad nodeType";
			var children : XMLList = this._node.children();
			var wrappers : Array = this.wraps(children);
			var cur : int = 0;
			return { hasNext : function() : Boolean {
				return cur < wrappers.length;
			}, next : function() : Xml {
				return wrappers[cur++];
			}}
		}
		
		public function attributes() : * {
			if(this.nodeType != Xml.Element) throw "bad nodeType";
			var attributes : XMLList = this._node.attributes();
			var names : Array = Reflect.fields(attributes);
			var cur : int = 0;
			return { hasNext : function() : Boolean {
				return cur < names.length;
			}, next : function() : String {
				return attributes[Std._parseInt(names[cur++])].name();
			}}
		}
		
		public function exists(att : String) : Boolean {
			if(this.nodeType != Xml.Element) throw "bad nodeType";
			var ns : Array = att.split(":");
			if(ns[0] == "xmlns") return this._node.namespace(((ns[1] == null)?"":ns[1])) != null;
			if(ns.length == 1) return Reflect.hasField(this._node,"@" + att);
			return this.getAttribNS(this._node,ns).length() > 0;
		}
		
		public function remove(att : String) : void {
			if(this.nodeType != Xml.Element) throw "bad nodeType";
			var ns : Array = att.split(":");
			if(ns.length == 1) Reflect.deleteField(this._node,"@" + att);
			else delete(this.getAttribNS(this._node,ns)[0]);
		}
		
		public function set(att : String,value : String) : void {
			if(this.nodeType != Xml.Element) throw "bad nodeType";
			var ns : Array = att.split(":");
			if(ns[0] == "xmlns") {
				var n : Namespace = this._node.namespace(((ns[1] == null)?"":ns[1]));
				if(n != null) throw "Can't modify namespace";
				if(ns[1] == null) throw "Can't set default namespace";
				this._node.addNamespace(new Namespace(ns[1],value));
				return;
			}
			if(ns.length == 1) Reflect.setField(this._node,"@" + att,value);
			else {
				var a : XMLList = this.getAttribNS(this._node,ns);
				a[0] = value;
			}
		}
		
		public function get(att : String) : String {
			if(this.nodeType != Xml.Element) throw "bad nodeType";
			var ns : Array = att.split(":");
			if(ns[0] == "xmlns") {
				var n : Namespace = this._node.namespace(((ns[1] == null)?"":ns[1]));
				return ((n == null)?null:n.uri);
			}
			if(ns.length == 1) {
				if(!Reflect.hasField(this._node,"@" + att)) return null;
				return Reflect.field(this._node,"@" + att);
			}
			var a : XMLList = this.getAttribNS(this._node,ns);
			return ((a.length() == 0)?null:a.toString());
		}
		
		protected function getAttribNS(cur : XML,ns : Array) : XMLList {
			var n : Namespace = cur.namespace(ns[0]);
			if(n == null) {
				var parent : XML = cur.parent();
				if(parent == null) {
					n = new Namespace(ns[0],"@" + ns[0]);
					cur.addNamespace(n);
				}
				else return this.getAttribNS(parent,ns);
			}
			return this._node.attribute(new QName(n,ns[1]));
		}
		
		protected function wraps(xList : XMLList) : Array {
			var out : Array = new Array();
			{
				var _g1 : int = 0, _g : int = xList.length();
				while(_g1 < _g) {
					var i : int = _g1++;
					out.push(Xml.wrap(xList[i]));
				}
			}
			return out;
		}
		
		public function getParent() : Xml {
			var p : XML = this._node.parent();
			return ((p == null)?null:Xml.wrap(p));
		}
		
		public function setNodeValue(v : String) : String {
			var nodeType : Object = this.nodeType;
			var x : Xml = null;
			if(nodeType == Xml.Element || nodeType == Xml.Document) throw "bad nodeType";
			else if(nodeType == Xml.PCData) x = Xml.createPCData(v);
			else if(nodeType == Xml.CData) x = Xml.createCData(v);
			else if(nodeType == Xml.Comment) x = Xml.createComment(v);
			else if(nodeType == Xml.DocType) x = Xml.createDocType(v);
			else x = Xml.createProlog(v);
			var p : XML = this._node.parent();
			if(p != null) {
				p.insertChildAfter(this._node,x._node);
				var i : int = this._node.childIndex();
				var children : XMLList = p.children();
				delete(children[Reflect.fields(children)[i]]);
			}
			this._node = x._node;
			return v;
		}
		
		public function getNodeValue() : String {
			var nodeType : Object = this.nodeType;
			if(nodeType == Xml.Element || nodeType == Xml.Document) throw "bad nodeType";
			if(nodeType == Xml.Comment) return this._node.toString().substr(4,-7);
			return this._node.toString();
		}
		
		public function setNodeName(n : String) : String {
			if(this.nodeType != Xml.Element) throw "bad nodeType";
			var ns : Array = n.split(":");
			if(ns.length == 1) this._node.setLocalName(n);
			else {
				this._node.setLocalName(ns[1]);
				this._node.setNamespace(this._node.namespace(ns[0]));
			}
			return n;
		}
		
		public function getNodeName() : String {
			if(this.nodeType != Xml.Element) throw "bad nodeType";
			var ns : Namespace = this._node.namespace();
			return ((ns.prefix == "")?this._node.localName():Std.string(ns.prefix) + ":" + Std.string(this._node.localName()));
		}
		
		protected var _node : XML;
		public function get parent() : Xml { return getParent(); }
		protected function set parent( __v : Xml ) : void { $parent = __v; }
		protected var $parent : Xml;
		public function get nodeValue() : String { return getNodeValue(); }
		public function set nodeValue( __v : String ) : void { setNodeValue(__v); }
		protected var $nodeValue : String;
		public function get nodeName() : String { return getNodeName(); }
		public function set nodeName( __v : String ) : void { setNodeName(__v); }
		protected var $nodeName : String;
		public var nodeType : Object;
		static public var Element : Object;
		static public var PCData : Object;
		static public var CData : Object;
		static public var Comment : Object;
		static public var DocType : Object;
		static public var Prolog : Object;
		static public var Document : Object;
		static public function parse(str : String) : Xml {
			XML.ignoreWhitespace = false;
			XML.ignoreProcessingInstructions = false;
			XML.ignoreComments = false;
			var prefix : String = "<__document";
			var root : XML = null;
			while(root == null) try {
				root = new XML(prefix + ">" + str + "</__document>");
			}
			catch( e : TypeError ){
				var r : EReg = new EReg("\"([^\"]+)\"","");
				if(e.errorID == 1083 && r.match(e.message)) {
					var ns : String = r.matched(1);
					prefix += " xmlns:" + ns + "=\"@" + ns + "\"";
				}
				else throw e;
			}
			return Xml.wrap(root,Xml.Document);
		}
		
		static public function compare(a : Xml,b : Xml) : Boolean {
			return ((a == null)?b == null:((b == null)?false:a._node == b._node));
		}
		
		static public function createElement(name : String) : Xml {
			return Xml.wrap(new XML("<" + name + "/>"),Xml.Element);
		}
		
		static public function createPCData(data : String) : Xml {
			XML.ignoreWhitespace = false;
			return Xml.wrap(new XML(data),Xml.PCData);
		}
		
		static public function createCData(data : String) : Xml {
			return Xml.wrap(new XML("<![CDATA[" + data + "]]>"),Xml.CData);
		}
		
		static public function createComment(data : String) : Xml {
			XML.ignoreComments = false;
			return Xml.wrap(new XML("<!--" + data + "-->"),Xml.Comment);
		}
		
		static public function createDocType(data : String) : Xml {
			return Xml.wrap(new XML("<!DOCTYPE " + data + ">"),Xml.DocType);
		}
		
		static public function createProlog(data : String) : Xml {
			XML.ignoreProcessingInstructions = false;
			return Xml.wrap(new XML("<?" + data + "?>"),Xml.Prolog);
		}
		
		static public function createDocument() : Xml {
			return Xml.wrap(new XML("<__document/>"),Xml.Document);
		}
		
		static protected function getNodeType(node : XML) : Object {
			switch(node.nodeKind()) {
			case "element":
			return Xml.Element;
			break;
			case "text":
			return Xml.PCData;
			break;
			case "processing-instruction":
			return Xml.Prolog;
			break;
			case "comment":
			return Xml.Comment;
			break;
			default:
			throw "unimplemented node type: " + Std.string(node.nodeType);
			break;
			}
			return null;
		}
		
		static protected function wrap(node : XML,type : Object = null) : Xml {
			var x : Xml = new Xml();
			x._node = node;
			x.nodeType = ((type != null)?type:Xml.getNodeType(node));
			return x;
		}
		
	}
}
