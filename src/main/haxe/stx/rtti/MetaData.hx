package stx.rtti;

using stx.Prelude;
using stx.Options;
using stx.Functions;

class MetaData{
	@:noUsing
	static public function fromType(n:Class<Dynamic>,s:String):Option<Array<Dynamic>>{
		return 
			Options.create(haxe.rtti.Meta.getType(n))
			.flatMap(
				Reflect.field.p2(s).then( Options.create )
			);
	}
}