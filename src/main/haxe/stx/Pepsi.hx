package stx;

import haxe.rtti.Infos;
import haxe.rtti.CType;
import stx.Prelude;

using Type;
using stx.Prelude;
using Std;
using Reflect;
using stx.rtti.RTypes;
using stx.Functions;
using stx.Iterables;

@:experimental('No typing, but it works')
class Pepsi{
	static public function with(v:Dynamic,fns:Class<Infos>){
		switch (fns.typetree()) {
			case TClassdecl(c) :
				c.statics.foreach(
					function(x){
						switch (x.type) {
							case CFunction(args,ret) 	:
								switch( args.size() ){
									case 1 :
										var f : Function1<Dynamic,Dynamic> = Reflect.field(fns,x.name);
										v.setField( x.name, callback(f,v) );
									case 2 : 
										var f : Function2<Dynamic,Dynamic,Dynamic> = Reflect.field(fns,x.name);
										v.setField( x.name, f.p1(v) );
									case 3 : 
										var f : Function3<Dynamic,Dynamic,Dynamic,Dynamic> = Reflect.field(fns,x.name);
										v.setField( x.name, f.p1(v) );
									case 4 : 
										var f : Function4<Dynamic,Dynamic,Dynamic,Dynamic,Dynamic> = Reflect.field(fns,x.name);
										v.setField( x.name, callback(f,v) );
									case 5 :
										var f : Function5<Dynamic,Dynamic,Dynamic,Dynamic,Dynamic,Dynamic> = Reflect.field(fns,x.name);
										v.setField( x.name, callback(f,v) );
									case 6 :
										var f : Function6<Dynamic,Dynamic,Dynamic,Dynamic,Dynamic,Dynamic,Dynamic> = Reflect.field(fns,x.name);
										v.setField( x.name, callback(f,v) );
								}
							default 									:
						}
					}
				);
			default 	:
		}
		return v;
	}
}