package haxe {
	import flash.Lib;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import haxe.Log;
	import flash.Boot;
	public class Timer {
		public function Timer(time_ms : int = 0) : void { if( !flash.Boot.skip_constructor ) {
			if(this.run == null) this.run = function() : void {
			}
			var me : haxe.Timer = this;
			this.id = flash.utils.setInterval(function() : void {
				me.run();
			},time_ms);
		}}
		
		public var run : Function;
		public function stop() : void {
			if(this.id == null) return;
			flash.utils.clearInterval(this.id);
			this.id = null;
		}
		
		protected var id : *;
		static public function delay(f : Function,time_ms : int) : haxe.Timer {
			var t : haxe.Timer = new haxe.Timer(time_ms);
			t.run = function() : void {
				t.stop();
				f();
			}
			return t;
		}
		
		static public function measure(f : Function,pos : * = null) : * {
			var t0 : Number = haxe.Timer.stamp();
			var r : * = f();
			haxe.Log._trace(haxe.Timer.stamp() - t0 + "s",pos);
			return r;
		}
		
		static public function stamp() : Number {
			return flash.Lib._getTimer() / 1000;
		}
		
	}
}
