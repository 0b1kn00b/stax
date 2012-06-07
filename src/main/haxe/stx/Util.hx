package stx;
class Util{
	public static function printer<A>(value:A,?pos:haxe.PosInfos):A{
		trace(value,pos);
		return value;
	}
}