package stx {
	import stx.rtti.RTypes;
	import stx.Functions2;
	import stx.Functions3;
	import haxe.rtti.CType;
	public class Pepsi {
		static public function _with(v : *,fns : Class) : * {
			{
				var $e : enum = (stx.rtti.RTypes.typetree(fns));
				switch( $e.index ) {
				case 1:
				var c : * = $e.params[0];
				Prelude.SIterables.foreach(c.statics,function(x : *) : void {
					{
						var $e2 : enum = (x.type);
						switch( $e2.index ) {
						case 4:
						var ret : haxe.rtti.CType = $e2.params[1], args : List = $e2.params[0];
						switch(Prelude.SIterables.size(args)) {
						case 1:
						{
							var f : Function = Reflect.field(fns,x.name);
							Reflect.setField(v,x.name,function() : Function {
								var $r3 : Function;
								var f1 : Function = f, a1 : * = v;
								$r3 = function() : * {
									return f1(a1);
								}
								return $r3;
							}());
						}
						break;
						case 2:
						{
							var f2 : Function = Reflect.field(fns,x.name);
							Reflect.setField(v,x.name,stx.Functions2.p1(f2,v));
						}
						break;
						case 3:
						{
							var f3 : Function = Reflect.field(fns,x.name);
							Reflect.setField(v,x.name,stx.Functions3.p1(f3,v));
						}
						break;
						case 4:
						{
							var f4 : Function = Reflect.field(fns,x.name);
							Reflect.setField(v,x.name,function() : Function {
								var $r4 : Function;
								var f5 : Function = f4, a11 : * = v;
								$r4 = function(a2 : *,a3 : *,a4 : *) : * {
									return f5(a11,a2,a3,a4);
								}
								return $r4;
							}());
						}
						break;
						case 5:
						{
							var f6 : Function = Reflect.field(fns,x.name);
							Reflect.setField(v,x.name,function() : Function {
								var $r5 : Function;
								var f7 : Function = f6, a12 : * = v;
								$r5 = function(a21 : *,a31 : *,a41 : *,a5 : *) : * {
									return f7(a12,a21,a31,a41,a5);
								}
								return $r5;
							}());
						}
						break;
						case 6:
						{
							var f8 : Function = Reflect.field(fns,x.name);
							Reflect.setField(v,x.name,function() : Function {
								var $r6 : Function;
								var f9 : Function = f8, a13 : * = v;
								$r6 = function(a22 : *,a32 : *,a42 : *,a51 : *,a6 : *) : * {
									return f9(a13,a22,a32,a42,a51,a6);
								}
								return $r6;
							}());
						}
						break;
						}
						break;
						default:
						break;
						}
					}
				});
				break;
				default:
				break;
				}
			}
			return v;
		}
		
	}
}
