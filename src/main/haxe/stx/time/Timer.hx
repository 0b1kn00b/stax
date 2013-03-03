package stx.time;
import stx.reactive.Reactive;
#if neko
import neko.vm.Thread;
#end
class Timer{
	#if neko
	private static var time_stream 			: Stream<Dynamic>;
	private static var time_thread 			: Thread;
	private static var time_id 					: Int;

	public static function __init__(){
		time_stream  	= stx.reactive.Streams.pure();
		time_id 		 	= 0;
		var intervals = new IntMap();
		var last : Float;
		time_thread = Thread.create(
			function(){
				while (true){
					switch( Thread.current().readMessage(Lambda.count(intervals) > 0) ){
						case Start(id,interval) :
							intervals.set(id, { started : haxe.Timer.stamp(), interval : interval} );
						case Stop(id) 					:
							intervals.remove(id);
					}
					var now = haxe.Timer.stamp();
					var delta = 
					var set = [];
					for (key in intervals.keys() ){
						var data 			= intervals.get(key);
						var next 			= now - data.started % data.interval;
					}
				}
			}
		);
	}
	private var interval : Int;

	public function new(interval:Int,?repeat = 0){
		this.interval = interval;
	}
	public function start(){

	}
	public function stop(){

	}
	#end
}
enum TimeInstruction{
	Start(id:Int,interval:Int);
	Stop(id:Int);
}
typedef TimeData = {
	started 	: Float,
	interval 	: Int
}