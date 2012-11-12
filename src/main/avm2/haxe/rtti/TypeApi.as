package haxe.rtti {
	import haxe.rtti.Rights;
	import haxe.rtti.CType;
	import haxe.rtti.TypeTree;
	public class TypeApi {
		static public function typeInfos(t : haxe.rtti.TypeTree) : * {
			var inf : *;
			{
				var $e : enum = (t);
				switch( $e.index ) {
				case 1:
				var c : * = $e.params[0];
				inf = c;
				break;
				case 2:
				var e : * = $e.params[0];
				inf = e;
				break;
				case 3:
				var t1 : * = $e.params[0];
				inf = t1;
				break;
				case 0:
				throw "Unexpected Package";
				break;
				}
			}
			return inf;
		}
		
		static public function isVar(t : haxe.rtti.CType) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (t);
					switch( $e2.index ) {
					case 4:
					$r = false;
					break;
					default:
					$r = true;
					break;
					}
				}
				return $r;
			}();
		}
		
		static protected function leq(f : Function,l1 : List,l2 : List) : Boolean {
			var it : * = l2.iterator();
			{ var $it : * = l1.iterator();
			while( $it.hasNext() ) { var e1 : * = $it.next();
			{
				if(!it.hasNext()) return false;
				var e2 : * = it.next();
				if(!f(e1,e2)) return false;
			}
			}}
			if(it.hasNext()) return false;
			return true;
		}
		
		static public function rightsEq(r1 : haxe.rtti.Rights,r2 : haxe.rtti.Rights) : Boolean {
			if(r1 == r2) return true;
			{
				var $e : enum = (r1);
				switch( $e.index ) {
				case 2:
				var m1 : String = $e.params[0];
				{
					{
						var $e2 : enum = (r2);
						switch( $e2.index ) {
						case 2:
						var m2 : String = $e2.params[0];
						return m1 == m2;
						break;
						default:
						break;
						}
					}
				}
				break;
				default:
				break;
				}
			}
			return false;
		}
		
		static public function typeEq(t1 : haxe.rtti.CType,t2 : haxe.rtti.CType) : Boolean {
			{
				var $e : enum = (t1);
				switch( $e.index ) {
				case 0:
				return t2 == haxe.rtti.CType.CUnknown;
				break;
				case 1:
				var params : List = $e.params[1], name : String = $e.params[0];
				{
					{
						var $e2 : enum = (t2);
						switch( $e2.index ) {
						case 1:
						var params2 : List = $e2.params[1], name2 : String = $e2.params[0];
						return name == name2 && haxe.rtti.TypeApi.leq(haxe.rtti.TypeApi.typeEq,params,params2);
						break;
						default:
						break;
						}
					}
				}
				break;
				case 2:
				var params1 : List = $e.params[1], name1 : String = $e.params[0];
				{
					{
						var $e3 : enum = (t2);
						switch( $e3.index ) {
						case 2:
						var params21 : List = $e3.params[1], name21 : String = $e3.params[0];
						return name1 == name21 && haxe.rtti.TypeApi.leq(haxe.rtti.TypeApi.typeEq,params1,params21);
						break;
						default:
						break;
						}
					}
				}
				break;
				case 3:
				var params3 : List = $e.params[1], name3 : String = $e.params[0];
				{
					{
						var $e4 : enum = (t2);
						switch( $e4.index ) {
						case 3:
						var params22 : List = $e4.params[1], name22 : String = $e4.params[0];
						return name3 == name22 && haxe.rtti.TypeApi.leq(haxe.rtti.TypeApi.typeEq,params3,params22);
						break;
						default:
						break;
						}
					}
				}
				break;
				case 4:
				var ret : haxe.rtti.CType = $e.params[1], args : List = $e.params[0];
				{
					{
						var $e5 : enum = (t2);
						switch( $e5.index ) {
						case 4:
						var ret2 : haxe.rtti.CType = $e5.params[1], args2 : List = $e5.params[0];
						return haxe.rtti.TypeApi.leq(function(a : *,b : *) : Boolean {
							return a.name == b.name && a.opt == b.opt && haxe.rtti.TypeApi.typeEq(a.t,b.t);
						},args,args2) && haxe.rtti.TypeApi.typeEq(ret,ret2);
						break;
						default:
						break;
						}
					}
				}
				break;
				case 5:
				var fields : List = $e.params[0];
				{
					{
						var $e6 : enum = (t2);
						switch( $e6.index ) {
						case 5:
						var fields2 : List = $e6.params[0];
						return haxe.rtti.TypeApi.leq(function(a1 : *,b1 : *) : Boolean {
							return a1.name == b1.name && haxe.rtti.TypeApi.typeEq(a1.t,b1.t);
						},fields,fields2);
						break;
						default:
						break;
						}
					}
				}
				break;
				case 6:
				var t : haxe.rtti.CType = $e.params[0];
				{
					{
						var $e7 : enum = (t2);
						switch( $e7.index ) {
						case 6:
						var t21 : haxe.rtti.CType = $e7.params[0];
						{
							if(t == null != (t21 == null)) return false;
							return t == null || haxe.rtti.TypeApi.typeEq(t,t21);
						}
						break;
						default:
						break;
						}
					}
				}
				break;
				}
			}
			return false;
		}
		
		static public function fieldEq(f1 : *,f2 : *) : Boolean {
			if(f1.name != f2.name) return false;
			if(!haxe.rtti.TypeApi.typeEq(f1.type,f2.type)) return false;
			if(f1.isPublic != f2.isPublic) return false;
			if(f1.doc != f2.doc) return false;
			if(!haxe.rtti.TypeApi.rightsEq(f1.get,f2.get)) return false;
			if(!haxe.rtti.TypeApi.rightsEq(f1.set,f2.set)) return false;
			if(f1.params == null != (f2.params == null)) return false;
			if(f1.params != null && f1.params.join(":") != f2.params.join(":")) return false;
			return true;
		}
		
		static public function constructorEq(c1 : *,c2 : *) : Boolean {
			if(c1.name != c2.name) return false;
			if(c1.doc != c2.doc) return false;
			if(c1.args == null != (c2.args == null)) return false;
			if(c1.args != null && !haxe.rtti.TypeApi.leq(function(a : *,b : *) : Boolean {
				return a.name == b.name && a.opt == b.opt && haxe.rtti.TypeApi.typeEq(a.t,b.t);
			},c1.args,c2.args)) return false;
			return true;
		}
		
	}
}
