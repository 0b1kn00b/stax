package stx.err;

using Std;
import haxe.PosInfos;

class DataError<T> extends stx.Error{
	@:noUsing
	static public function create<A>(data:A, ?msg:String, ?pos:PosInfos){
		return new DataError(data,msg,pos);
	}
	@:noUsing
	static public function build<A>(?msg:String,?pos:PosInfos){
		return 
			function(data:A){
				return new DataError(data,msg,pos);
			}
	}
	public var data(default,null):T;
	public function new(data:T,?msg:String,?pos:PosInfos){
		this.data = data;
		super('DataError: $msg',pos);
	}
}