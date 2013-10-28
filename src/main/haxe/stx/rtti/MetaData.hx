package stx.rtti;

using stx.Prelude;
using stx.Option;
using stx.Functions;
using stx.Compose;

class MetaData{
	@:noUsing static public function fromType(n:Class<Dynamic>,s:String):Option<Array<Dynamic>>{
		return Options.create(haxe.rtti.Meta.getType(n))
			.flatMap(
				Reflects.getFieldO.p2(s)
			);
	}
}