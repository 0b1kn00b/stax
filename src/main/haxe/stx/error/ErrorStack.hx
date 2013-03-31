package stx.error;

using Std;

using stx.Arrays;

import haxe.PosInfos;

class ErrorStack<T> extends DataError<Iterable<T>>{
	@:noUsing
	static public function create<A>(data:Iterable<A>, ?msg:String, ?pos:PosInfos){
		return new ErrorStack(data,msg,pos);
	}
	@noUsing
	static public function build<A>(?msg:String,?pos:PosInfos){
		return 
			function(iterable:Iterable<A>){
				return create(iterable,msg,pos);
			}
	}
	public function new(data:Iterable<T>,msg:String = 'Stack of Errors: ',?pos:PosInfos){
		super(data,'$msg: $data',pos);
	}
}
class ErrorStacks{
	public function merge(e0:Error,e1:Error){
		var o = [];
		if( Types.hasSuperClass(Type.getClass(e0),ErrorStack) ){
			o = o.append( cast(e0).data.toArray() );
		}else{
			o.push(e0);
		}
		if( Types.hasSuperClass(Type.getClass(e1),ErrorStack) ){
			o = o.append( cast(e1).data.toArray() );
		}else{
			o.push(e1);
		}
		return new ErrorStack(o);
	}
}