package stx;
import haxe.CallStack;
class Util{

}
class StackItems{
	static public function show(s:StackItem){
		return 
			switch (s){
				case CFunction 											: 'function';
				case Module( m ) 										: m;
				case FilePos( si , file, line ) 		: show(si) + ':$file#$line';
				case Method( classname , method ) 	: '$classname.$method';
				case Lambda( v ) 										: '@$v';
			}
	}
}