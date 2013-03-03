package stx.rtti;

using stx.Prelude;
using stx.Maybes;
using stx.Functions;
using stx.Compose;

class MetaData{
	@:noUsing
	static public function fromType(n:Class<Dynamic>,s:String):Maybe<Array<Dynamic>>{
		return 
			Maybes.create(haxe.rtti.Meta.getType(n))
			.flatMap(
				Reflects.getFieldO.p2(s)
			);
	}
}