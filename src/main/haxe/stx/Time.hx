package stx;

using Math;

class Time {

	private var raw (default,null): Float;
	
	public function new() {
		this.ready 	= false;
	}
	public static function now() {
		return new Time().setRaw(haxe.Timer.stamp() * 1000 );
	}
	public function setRaw(v:Float) {
		this.raw 		= v;
		return this;
	}
	/**
	 * Add Times together.
	 * @param	t
	 * @return
	 */
	public function add(t:Time):Time {
		return new Time().setRaw( this.raw + t.raw );
	}
	/**
	 * Subtracts Times.
	 * @param	t
	 * @return
	 */
	public function sub(t:Time):Time {
		return new Time().setRaw( this.raw - t.raw );
	}
	/**
	 * Multiplies Times.
	 * @param	t
	 * @return
	 */
	public function mul(t:Time):Time {
		return new Time().setRaw( this.raw * t.raw );
	}
	/**
	 * Divides Times.
	 * @param	t
	 * @return
	 */
	public function div(t:Time):Time {
		return new Time().setRaw( this.raw * t.raw );
	}
	
	/**
	 * Returns the modulo of two Times.
	 * @param	t
	 * @return
	 */
	public function mod(t:Time):Time {
		return new Time().setRaw( this.raw % t.raw );
	}
	
	private function determine() { 
		var o 	=  this.raw;
		var days 		= ( o / ( 1000 * 60 * 60 * 24 )).floor();
		o	-= (0. + days) * 1000 * 60 * 60 *24;
		var hours 		= (o / ( 1000 * 60 * 60 )).floor();
		o -= (0. + hours) * 1000 * 60 * 60;
		var minutes	= (o / ( 1000 * 60 )).floor();
		o -= (0. + minutes) * 1000 * 60;
		var seconds 	= (o / 1000).floor();
		o -= (0. + seconds) * 1000;
		var milliseconds	= o.floor();
		this.ready = true;
		
		this.days = days;
		this.hours = hours;
		this.minutes = minutes;
		this.seconds = seconds;
		this.milliseconds = milliseconds;
	}
	private var ready : Bool;
	
	public var milliseconds(get_milliseconds, null):Int;
	
	private function get_milliseconds():Int {
		if (!ready) determine();
		return milliseconds;
	}
	
	public var seconds(get_seconds, null):Int;
	
	private function get_seconds():Int {
		if (!ready) determine();
		return seconds;
	} 
	
	public var minutes(get_minutes, null):Int;
	
	private function get_minutes():Int {
		if (!ready) determine();
		return minutes;
	}
	
	public var hours(get_hours, null):Int;
	
	private function get_hours():Int {
		if (!ready) determine();
		return hours;
	}
	
	public var days(get_days, null):Int;
	
	private function get_days():Int {
		if (!ready) determine();
		return days;
	}
	
	public static function day(m:Int = 1) {
		return new Time().setRaw( 1. * 1000 * 60 * 60 * 24 * m);
	}
	public static function hour(m:Int = 1) {
		return new Time().setRaw( 1. * 1000 * 60 * 60 * m);
	}
	public static function minute(m:Int = 1) {
		return new Time().setRaw( 1. * 1000 * 60 * m);
	}
	public static function second(m:Int = 1) {
		return new Time().setRaw( 1. * 1000 * m);
	}
	public static function millisecond(m:Int = 1) {
		return new Time().setRaw( 1. * m);
	}
	public function toString() {
		return '$days:$hours:$minutes:$seconds:$milliseconds';
	}
	public function toDate(){
		return Date.fromTime(this.raw);
	}
}