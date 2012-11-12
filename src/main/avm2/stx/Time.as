package stx {
	import haxe.Timer;
	import flash.Boot;
	public class Time {
		public function Time() : void { if( !flash.Boot.skip_constructor ) {
			this.ready = false;
		}}
		
		public function toString() : String {
			return [this.get_days(),":",this.get_hours(),":",this.get_minutes(),":",this.get_seconds(),":",this.get_milliseconds()].join("");
		}
		
		public function get_days() : int {
			if(!this.ready) this.determine();
			return this.$days;
		}
		
		public function get days() : int { return get_days(); }
		protected function set days( __v : int ) : void { $days = __v; }
		protected var $days : int;
		public function get_hours() : int {
			if(!this.ready) this.determine();
			return this.$hours;
		}
		
		public function get hours() : int { return get_hours(); }
		protected function set hours( __v : int ) : void { $hours = __v; }
		protected var $hours : int;
		public function get_minutes() : int {
			if(!this.ready) this.determine();
			return this.$minutes;
		}
		
		public function get minutes() : int { return get_minutes(); }
		protected function set minutes( __v : int ) : void { $minutes = __v; }
		protected var $minutes : int;
		public function get_seconds() : int {
			if(!this.ready) this.determine();
			return this.$seconds;
		}
		
		public function get seconds() : int { return get_seconds(); }
		protected function set seconds( __v : int ) : void { $seconds = __v; }
		protected var $seconds : int;
		public function get_milliseconds() : int {
			if(!this.ready) this.determine();
			return this.$milliseconds;
		}
		
		public function get milliseconds() : int { return get_milliseconds(); }
		protected function set milliseconds( __v : int ) : void { $milliseconds = __v; }
		protected var $milliseconds : int;
		protected var ready : Boolean;
		protected function determine() : void {
			var o : Number = this.raw;
			var days : int = Math.floor(o / 86400000);
			o -= (0. + days) * 1000 * 60 * 60 * 24;
			var hours : int = Math.floor(o / 3600000);
			o -= (0. + hours) * 1000 * 60 * 60;
			var minutes : int = Math.floor(o / 60000);
			o -= (0. + minutes) * 1000 * 60;
			var seconds : int = Math.floor(o / 1000);
			o -= (0. + seconds) * 1000;
			var milliseconds : int = Math.floor(o);
			this.ready = true;
			this.days = days;
			this.hours = hours;
			this.minutes = minutes;
			this.seconds = seconds;
			this.milliseconds = milliseconds;
		}
		
		public function mod(t : stx.Time) : stx.Time {
			return new stx.Time().setRaw(this.raw % t.raw);
		}
		
		public function div(t : stx.Time) : stx.Time {
			return new stx.Time().setRaw(this.raw * t.raw);
		}
		
		public function mul(t : stx.Time) : stx.Time {
			return new stx.Time().setRaw(this.raw * t.raw);
		}
		
		public function sub(t : stx.Time) : stx.Time {
			return new stx.Time().setRaw(this.raw - t.raw);
		}
		
		public function add(t : stx.Time) : stx.Time {
			return new stx.Time().setRaw(this.raw + t.raw);
		}
		
		public function setRaw(v : Number) : stx.Time {
			this.raw = v;
			return this;
		}
		
		public var raw : Number;
		static public function now() : stx.Time {
			return new stx.Time().setRaw(haxe.Timer.stamp() * 1000);
		}
		
		static public function day(m : int = 1) : stx.Time {
			return new stx.Time().setRaw(86400000. * m);
		}
		
		static public function hour(m : int = 1) : stx.Time {
			return new stx.Time().setRaw(3600000. * m);
		}
		
		static public function minute(m : int = 1) : stx.Time {
			return new stx.Time().setRaw(60000. * m);
		}
		
		static public function second(m : int = 1) : stx.Time {
			return new stx.Time().setRaw(1000. * m);
		}
		
		static public function millisecond(m : int = 1) : stx.Time {
			return new stx.Time().setRaw(1. * m);
		}
		
	}
}
