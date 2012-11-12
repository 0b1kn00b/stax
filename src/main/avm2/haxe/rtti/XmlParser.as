package haxe.rtti {
	import haxe.rtti.TypeTree;
	import haxe.xml.Fast;
	import haxe.rtti.TypeApi;
	import haxe.rtti.Rights;
	import haxe.rtti.CType;
	import flash.Boot;
	public class XmlParser {
		public function XmlParser() : void { if( !flash.Boot.skip_constructor ) {
			if(this.newField == null) this.newField = function(c : *,f : *) : void {
			}
			this.root = new Array();
		}}
		
		protected function defplat() : List {
			var l : List = new List();
			if(this.curplatform != null) l.add(this.curplatform);
			return l;
		}
		
		protected function xtypeparams(x : haxe.xml.Fast) : List {
			var p : List = new List();
			{ var $it : * = x.getElements();
			while( $it.hasNext() ) { var c : haxe.xml.Fast = $it.next();
			p.add(this.xtype(c));
			}}
			return p;
		}
		
		protected function xtype(x : haxe.xml.Fast) : haxe.rtti.CType {
			return (function($this:XmlParser) : haxe.rtti.CType {
				var $r : haxe.rtti.CType;
				switch(x.getName()) {
				case "unknown":
				$r = haxe.rtti.CType.CUnknown;
				break;
				case "e":
				$r = haxe.rtti.CType.CEnum($this.mkPath(x.att.resolve("path")),$this.xtypeparams(x));
				break;
				case "c":
				$r = haxe.rtti.CType.CClass($this.mkPath(x.att.resolve("path")),$this.xtypeparams(x));
				break;
				case "t":
				$r = haxe.rtti.CType.CTypedef($this.mkPath(x.att.resolve("path")),$this.xtypeparams(x));
				break;
				case "f":
				$r = (function($this:XmlParser) : haxe.rtti.CType {
					var $r2 : haxe.rtti.CType;
					var args : List = new List();
					var aname : Array = x.att.resolve("a").split(":");
					var eargs : * = aname.iterator();
					{ var $it3 : * = x.getElements();
					while( $it3.hasNext() ) { var e : haxe.xml.Fast = $it3.next();
					{
						var opt : Boolean = false;
						var a : String = eargs.next();
						if(a == null) a = "";
						if(a.charAt(0) == "?") {
							opt = true;
							a = a.substr(1);
						}
						args.add({ name : a, opt : opt, t : $this.xtype(e)});
					}
					}}
					var ret : * = args.last();
					args.remove(ret);
					$r2 = haxe.rtti.CType.CFunction(args,ret.t);
					return $r2;
				}($this));
				break;
				case "a":
				$r = (function($this:XmlParser) : haxe.rtti.CType {
					var $r4 : haxe.rtti.CType;
					var fields : List = new List();
					{ var $it5 : * = x.getElements();
					while( $it5.hasNext() ) { var f : haxe.xml.Fast = $it5.next();
					fields.add({ name : f.getName(), t : $this.xtype(new haxe.xml.Fast(f.x.firstElement()))});
					}}
					$r4 = haxe.rtti.CType.CAnonymous(fields);
					return $r4;
				}($this));
				break;
				case "d":
				$r = (function($this:XmlParser) : haxe.rtti.CType {
					var $r6 : haxe.rtti.CType;
					var t : haxe.rtti.CType = null;
					var tx : Xml = x.x.firstElement();
					if(tx != null) t = $this.xtype(new haxe.xml.Fast(tx));
					$r6 = haxe.rtti.CType.CDynamic(t);
					return $r6;
				}($this));
				break;
				default:
				$r = $this.xerror(x);
				break;
				}
				return $r;
			}(this));
		}
		
		protected function xtypedef(x : haxe.xml.Fast) : * {
			var doc : String = null;
			var t : haxe.rtti.CType = null;
			{ var $it : * = x.getElements();
			while( $it.hasNext() ) { var c : haxe.xml.Fast = $it.next();
			if(c.getName() == "haxe_doc") doc = c.getInnerData();
			else if(c.getName() == "meta") {
			}
			else t = this.xtype(c);
			}}
			var types : Hash = new Hash();
			if(this.curplatform != null) types.set(this.curplatform,t);
			return { path : this.mkPath(x.att.resolve("path")), module : ((x.has.resolve("module"))?this.mkPath(x.att.resolve("module")):null), doc : doc, isPrivate : x.x.exists("private"), params : this.mkTypeParams(x.att.resolve("params")), type : t, types : types, platforms : this.defplat()}
		}
		
		protected function xenumfield(x : haxe.xml.Fast) : * {
			var args : List = null;
			var xdoc : Xml = x.x.elementsNamed("haxe_doc").next();
			if(x.has.resolve("a")) {
				var names : Array = x.att.resolve("a").split(":");
				var elts : * = x.getElements();
				args = new List();
				{
					var _g : int = 0;
					while(_g < names.length) {
						var c : String = names[_g];
						++_g;
						var opt : Boolean = false;
						if(c.charAt(0) == "?") {
							opt = true;
							c = c.substr(1);
						}
						args.add({ name : c, opt : opt, t : this.xtype(elts.next())});
					}
				}
			}
			return { name : x.getName(), args : args, doc : ((xdoc == null)?null:new haxe.xml.Fast(xdoc).getInnerData()), platforms : this.defplat()}
		}
		
		protected function xenum(x : haxe.xml.Fast) : * {
			var cl : List = new List();
			var doc : String = null;
			{ var $it : * = x.getElements();
			while( $it.hasNext() ) { var c : haxe.xml.Fast = $it.next();
			if(c.getName() == "haxe_doc") doc = c.getInnerData();
			else if(c.getName() == "meta") {
			}
			else cl.add(this.xenumfield(c));
			}}
			return { path : this.mkPath(x.att.resolve("path")), module : ((x.has.resolve("module"))?this.mkPath(x.att.resolve("module")):null), doc : doc, isPrivate : x.x.exists("private"), isExtern : x.x.exists("extern"), params : this.mkTypeParams(x.att.resolve("params")), constructors : cl, platforms : this.defplat()}
		}
		
		protected function xclassfield(x : haxe.xml.Fast) : * {
			var e : * = x.getElements();
			var t : haxe.rtti.CType = this.xtype(e.next());
			var doc : String = null;
			{ var $it : * = e;
			while( $it.hasNext() ) { var c : haxe.xml.Fast = $it.next();
			switch(c.getName()) {
			case "haxe_doc":
			doc = c.getInnerData();
			break;
			case "meta":
			break;
			default:
			this.xerror(c);
			break;
			}
			}}
			return { name : x.getName(), type : t, isPublic : x.x.exists("public"), isOverride : x.x.exists("override"), doc : doc, get : ((x.has.resolve("get"))?this.mkRights(x.att.resolve("get")):haxe.rtti.Rights.RNormal), set : ((x.has.resolve("set"))?this.mkRights(x.att.resolve("set")):haxe.rtti.Rights.RNormal), params : ((x.has.resolve("params"))?this.mkTypeParams(x.att.resolve("params")):null), platforms : this.defplat()}
		}
		
		protected function xclass(x : haxe.xml.Fast) : * {
			var csuper : * = null;
			var doc : String = null;
			var tdynamic : haxe.rtti.CType = null;
			var interfaces : List = new List();
			var fields : List = new List();
			var statics : List = new List();
			{ var $it : * = x.getElements();
			while( $it.hasNext() ) { var c : haxe.xml.Fast = $it.next();
			switch(c.getName()) {
			case "haxe_doc":
			doc = c.getInnerData();
			break;
			case "extends":
			csuper = this.xpath(c);
			break;
			case "implements":
			interfaces.add(this.xpath(c));
			break;
			case "haxe_dynamic":
			tdynamic = this.xtype(new haxe.xml.Fast(c.x.firstElement()));
			break;
			case "meta":
			break;
			default:
			if(c.x.exists("static")) statics.add(this.xclassfield(c));
			else fields.add(this.xclassfield(c));
			break;
			}
			}}
			return { path : this.mkPath(x.att.resolve("path")), module : ((x.has.resolve("module"))?this.mkPath(x.att.resolve("module")):null), doc : doc, isPrivate : x.x.exists("private"), isExtern : x.x.exists("extern"), isInterface : x.x.exists("interface"), params : this.mkTypeParams(x.att.resolve("params")), superClass : csuper, interfaces : interfaces, fields : fields, statics : statics, tdynamic : tdynamic, platforms : this.defplat()}
		}
		
		protected function xpath(x : haxe.xml.Fast) : * {
			var path : String = this.mkPath(x.att.resolve("path"));
			var params : List = new List();
			{ var $it : * = x.getElements();
			while( $it.hasNext() ) { var c : haxe.xml.Fast = $it.next();
			params.add(this.xtype(c));
			}}
			return { path : path, params : params}
		}
		
		public function processElement(x : Xml) : haxe.rtti.TypeTree {
			var c : haxe.xml.Fast = new haxe.xml.Fast(x);
			return (function($this:XmlParser) : haxe.rtti.TypeTree {
				var $r : haxe.rtti.TypeTree;
				switch(c.getName()) {
				case "class":
				$r = haxe.rtti.TypeTree.TClassdecl($this.xclass(c));
				break;
				case "enum":
				$r = haxe.rtti.TypeTree.TEnumdecl($this.xenum(c));
				break;
				case "typedef":
				$r = haxe.rtti.TypeTree.TTypedecl($this.xtypedef(c));
				break;
				default:
				$r = $this.xerror(c);
				break;
				}
				return $r;
			}(this));
		}
		
		protected function xroot(x : haxe.xml.Fast) : void {
			{ var $it : * = x.x.elements();
			while( $it.hasNext() ) { var c : Xml = $it.next();
			this.merge(this.processElement(c));
			}}
		}
		
		protected function xerror(c : haxe.xml.Fast) : * {
			return (function($this:XmlParser) : * {
				var $r : *;
				throw "Invalid " + c.getName();
				return $r;
			}(this));
		}
		
		protected function mkRights(r : String) : haxe.rtti.Rights {
			return (function($this:XmlParser) : haxe.rtti.Rights {
				var $r : haxe.rtti.Rights;
				switch(r) {
				case "null":
				$r = haxe.rtti.Rights.RNo;
				break;
				case "method":
				$r = haxe.rtti.Rights.RMethod;
				break;
				case "dynamic":
				$r = haxe.rtti.Rights.RDynamic;
				break;
				case "inline":
				$r = haxe.rtti.Rights.RInline;
				break;
				default:
				$r = haxe.rtti.Rights.RCall(r);
				break;
				}
				return $r;
			}(this));
		}
		
		protected function mkTypeParams(p : String) : Array {
			var pl : Array = p.split(":");
			if(pl[0] == "") return new Array();
			return pl;
		}
		
		protected function mkPath(p : String) : String {
			return p;
		}
		
		protected function merge(t : haxe.rtti.TypeTree) : void {
			var inf : * = haxe.rtti.TypeApi.typeInfos(t);
			var pack : Array = inf.path.split(".");
			var cur : Array = this.root;
			var curpack : Array = new Array();
			pack.pop();
			{
				var _g : int = 0;
				while(_g < pack.length) {
					var p : String = pack[_g];
					++_g;
					var found : Boolean = false;
					{
						var _g1 : int = 0;
						try {
							while(_g1 < cur.length) {
								var pk : haxe.rtti.TypeTree = cur[_g1];
								++_g1;
								{
									var $e : enum = (pk);
									switch( $e.index ) {
									case 0:
									var subs : Array = $e.params[2], pname : String = $e.params[0];
									if(pname == p) {
										found = true;
										cur = subs;
										throw "__break__";
									}
									break;
									default:
									break;
									}
								}
							}
						} catch( e : * ) { if( e != "__break__" ) throw e; }
					}
					curpack.push(p);
					if(!found) {
						var pk1 : Array = new Array();
						cur.push(haxe.rtti.TypeTree.TPackage(p,curpack.join("."),pk1));
						cur = pk1;
					}
				}
			}
			var prev : * = null;
			{
				var _g2 : int = 0;
				while(_g2 < cur.length) {
					var ct : haxe.rtti.TypeTree = cur[_g2];
					++_g2;
					var tinf : *;
					try {
						tinf = haxe.rtti.TypeApi.typeInfos(ct);
					}
					catch( e : * ){
						continue;
					}
					if(tinf.path == inf.path) {
						var sameType : Boolean = true;
						if(tinf.doc == null != (inf.doc == null)) {
							if(inf.doc == null) inf.doc = tinf.doc;
							else tinf.doc = inf.doc;
						}
						if(tinf.module == inf.module && tinf.doc == inf.doc && tinf.isPrivate == inf.isPrivate) {
							{
								var $e2 : enum = (ct);
								switch( $e2.index ) {
								case 1:
								var c : * = $e2.params[0];
								{
									{
										var $e3 : enum = (t);
										switch( $e3.index ) {
										case 1:
										var c2 : * = $e3.params[0];
										if(this.mergeClasses(c,c2)) return;
										break;
										default:
										sameType = false;
										break;
										}
									}
								}
								break;
								case 2:
								var e1 : * = $e2.params[0];
								{
									{
										var $e4 : enum = (t);
										switch( $e4.index ) {
										case 2:
										var e2 : * = $e4.params[0];
										if(this.mergeEnums(e1,e2)) return;
										break;
										default:
										sameType = false;
										break;
										}
									}
								}
								break;
								case 3:
								var td : * = $e2.params[0];
								{
									{
										var $e5 : enum = (t);
										switch( $e5.index ) {
										case 3:
										var td2 : * = $e5.params[0];
										if(this.mergeTypedefs(td,td2)) return;
										break;
										default:
										break;
										}
									}
								}
								break;
								case 0:
								sameType = false;
								break;
								}
							}
						}
						var msg : String = ((tinf.module != inf.module)?"module " + inf.module + " should be " + tinf.module:((tinf.doc != inf.doc)?"documentation is different":((tinf.isPrivate != inf.isPrivate)?"private flag is different":((!sameType)?"type kind is different":"could not merge definition"))));
						throw "Incompatibilities between " + tinf.path + " in " + tinf.platforms.join(",") + " and " + this.curplatform + " (" + msg + ")";
					}
				}
			}
			cur.push(t);
		}
		
		protected function mergeTypedefs(t : *,t2 : *) : Boolean {
			if(this.curplatform == null) return false;
			t.platforms.add(this.curplatform);
			t.types.set(this.curplatform,t2.type);
			return true;
		}
		
		protected function mergeEnums(e : *,e2 : *) : Boolean {
			if(e.isExtern != e2.isExtern) return false;
			if(this.curplatform != null) e.platforms.add(this.curplatform);
			{ var $it : * = e2.constructors.iterator();
			while( $it.hasNext() ) { var c2 : * = $it.next();
			{
				var found : * = null;
				{ var $it2 : * = e.constructors.iterator();
				while( $it2.hasNext() ) { var c : * = $it2.next();
				if(haxe.rtti.TypeApi.constructorEq(c,c2)) {
					found = c;
					break;
				}
				}}
				if(found == null) return false;
				if(this.curplatform != null) found.platforms.add(this.curplatform);
			}
			}}
			return true;
		}
		
		protected function mergeClasses(c : *,c2 : *) : Boolean {
			if(c.isInterface != c2.isInterface) return false;
			if(this.curplatform != null) c.platforms.add(this.curplatform);
			if(c.isExtern != c2.isExtern) c.isExtern = false;
			{ var $it : * = c2.fields.iterator();
			while( $it.hasNext() ) { var f2 : * = $it.next();
			{
				var found : * = null;
				{ var $it2 : * = c.fields.iterator();
				while( $it2.hasNext() ) { var f : * = $it2.next();
				if(this.mergeFields(f,f2)) {
					found = f;
					break;
				}
				}}
				if(found == null) {
					this.newField(c,f2);
					c.fields.add(f2);
				}
				else if(this.curplatform != null) found.platforms.add(this.curplatform);
			}
			}}
			{ var $it3 : * = c2.statics.iterator();
			while( $it3.hasNext() ) { var f21 : * = $it3.next();
			{
				var found1 : * = null;
				{ var $it4 : * = c.statics.iterator();
				while( $it4.hasNext() ) { var f1 : * = $it4.next();
				if(this.mergeFields(f1,f21)) {
					found1 = f1;
					break;
				}
				}}
				if(found1 == null) {
					this.newField(c,f21);
					c.statics.add(f21);
				}
				else if(this.curplatform != null) found1.platforms.add(this.curplatform);
			}
			}}
			return true;
		}
		
		public var newField : Function;
		protected function mergeFields(f : *,f2 : *) : Boolean {
			return haxe.rtti.TypeApi.fieldEq(f,f2) || f.name == f2.name && (this.mergeRights(f,f2) || this.mergeRights(f2,f)) && this.mergeDoc(f,f2) && haxe.rtti.TypeApi.fieldEq(f,f2);
		}
		
		protected function mergeDoc(f1 : *,f2 : *) : Boolean {
			if(f1.doc == null) f2.doc = f2.doc;
			else if(f2.doc == null) f2.doc = f1.doc;
			return true;
		}
		
		protected function mergeRights(f1 : *,f2 : *) : Boolean {
			if(f1.get == haxe.rtti.Rights.RInline && f1.set == haxe.rtti.Rights.RNo && f2.get == haxe.rtti.Rights.RNormal && f2.set == haxe.rtti.Rights.RMethod) {
				f1.get = haxe.rtti.Rights.RNormal;
				f1.set = haxe.rtti.Rights.RMethod;
				return true;
			}
			return false;
		}
		
		public function process(x : Xml,platform : String) : void {
			this.curplatform = platform;
			this.xroot(new haxe.xml.Fast(x));
		}
		
		protected function sortFields(fl : *) : List {
			var a : Array = Lambda.array(fl);
			a.sort(function(f1 : *,f2 : *) : int {
				var v1 : Boolean = haxe.rtti.TypeApi.isVar(f1.type);
				var v2 : Boolean = haxe.rtti.TypeApi.isVar(f2.type);
				if(v1 && !v2) return -1;
				if(v2 && !v1) return 1;
				if(f1.name == "new") return -1;
				if(f2.name == "new") return 1;
				if(f1.name > f2.name) return 1;
				return -1;
			});
			return Lambda.list(a);
		}
		
		public function sort(l : Array = null) : void {
			if(l == null) l = this.root;
			l.sort(function(e1 : haxe.rtti.TypeTree,e2 : haxe.rtti.TypeTree) : int {
				var n1 : String = function() : String {
					var $r : String;
					{
						var $e2 : enum = (e1);
						switch( $e2.index ) {
						case 0:
						var p : String = $e2.params[0];
						$r = " " + p;
						break;
						default:
						$r = haxe.rtti.TypeApi.typeInfos(e1).path;
						break;
						}
					}
					return $r;
				}();
				var n2 : String = function() : String {
					var $r3 : String;
					{
						var $e4 : enum = (e2);
						switch( $e4.index ) {
						case 0:
						var p1 : String = $e4.params[0];
						$r3 = " " + p1;
						break;
						default:
						$r3 = haxe.rtti.TypeApi.typeInfos(e2).path;
						break;
						}
					}
					return $r3;
				}();
				if(n1 > n2) return 1;
				return -1;
			});
			{
				var _g : int = 0;
				while(_g < l.length) {
					var x : haxe.rtti.TypeTree = l[_g];
					++_g;
					{
						var $e5 : enum = (x);
						switch( $e5.index ) {
						case 0:
						var l1 : Array = $e5.params[2];
						this.sort(l1);
						break;
						case 1:
						var c : * = $e5.params[0];
						{
							c.fields = this.sortFields(c.fields);
							c.statics = this.sortFields(c.statics);
						}
						break;
						case 2:
						var e : * = $e5.params[0];
						break;
						case 3:
						break;
						}
					}
				}
			}
		}
		
		protected var curplatform : String;
		public var root : Array;
	}
}
