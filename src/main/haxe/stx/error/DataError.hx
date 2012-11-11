package stx.error;

using Std;
import haxe.PosInfos;

class DataError<T> extends stx.Error{
	@:noUsing
	static public function create<A>(data:A, ?msg:String, ?pos:PosInfos){
		return new DataError(data,msg,pos);
	}
	public var data(default,null):T;
	public function new(data:T,?msg:String,?pos:PosInfos){
		this.data = data;
		super('DataError: $msg'.format(),pos);
	}
}