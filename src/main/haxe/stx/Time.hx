package stx;

using Math;

abstract Time(TimeInstance) from TimeInstance to TimeInstance{
  public function new(v){
    this = v;
  }
  @:from static public function fromDate(dt:Date):Time{
  	return new TimeInstance().setRaw(dt.getTime());
  }
  @:to public function toDate():Date{
  	return this.toDate();
  }
  @:to public function toFloat():Float{
  	return this.getRaw();
  }
  public function getRaw():Float{
  	return this.getRaw();
  }
  public function add(t:Time):Time {
		return this.add(t);
	}
	@doc("Subtracts Times.")
	public function sub(t:Time):Time {
		return this.sub(t);
	}
	@doc("Multiplies Times.")
	public function mul(t:Time):Time {
		return this.mul(t);
	}
	@doc("Divides Times.")
	public function div(t:Time):Time {
		return this.div(t);
	}
	public function mod(t:Time):Time {
		return this.mod(t);
	}
	public function compare(t:Time):Int{
		return stx.Maths.Floats.compare(getRaw(),t.getRaw());
	}
	static public function now():Time {
		return TimeInstance.now();
	}
	static public function day(m:Int = 1):Time {
		return TimeInstance.day(m);
	}
	static public function hour(m:Int = 1):Time {
		return TimeInstance.hour(m);
	}
	static public function minute(m:Int = 1):Time {
		return TimeInstance.minute(m);
	}
	static public function second(m:Int = 1):Time {
		return TimeInstance.second(m);
	}
	static public function millisecond(m:Int = 1):Time {
		return TimeInstance.millisecond(m);
	}
}
class TimeInstance {

	private var raw (default,null): Float;
	
	public function new() {
		this.ready 	= false;
	}
	static public function now() {
		return new TimeInstance().setRaw(haxe.Timer.stamp() * 1000 );
	}
	public function setRaw(v:Float) {
		this.raw 		= v;
		return this;
	}
	public function getRaw(){
		return this.raw;
	}
	@doc("Add Times together.")
	public function add(t:TimeInstance):Time {
		return new TimeInstance().setRaw( this.raw + t.raw );
	}
	@doc("Subtracts Times.")
	public function sub(t:TimeInstance):Time {
		return new TimeInstance().setRaw( this.raw - t.raw );
	}
	@doc("Multiplies Times.")
	public function mul(t:TimeInstance):Time {
		return new TimeInstance().setRaw( this.raw * t.raw );
	}
	@doc("Divides Times.")
	public function div(t:TimeInstance):Time {
		return new TimeInstance().setRaw( this.raw * t.raw );
	}
	
	@doc("Returns the modulo of two Times.")
	public function mod(t:TimeInstance):Time {
		return new TimeInstance().setRaw( this.raw % t.raw );
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
	static public function week(){
		return day(7);
	}
	static public function day(m:Int = 1) {
		return new TimeInstance().setRaw( 1. * 1000 * 60 * 60 * 24 * m);
	}
	static public function hour(m:Int = 1) {
		return new TimeInstance().setRaw( 1. * 1000 * 60 * 60 * m);
	}
	static public function minute(m:Int = 1) {
		return new TimeInstance().setRaw( 1. * 1000 * 60 * m);
	}
	static public function second(m:Int = 1) {
		return new TimeInstance().setRaw( 1. * 1000 * m);
	}
	static public function millisecond(m:Int = 1) {
		return new TimeInstance().setRaw( 1. * m);
	}
	public function toString() {
		return '$days#$hours:$minutes:$seconds.$milliseconds';
	}
	public function toDate(){
		return Date.fromTime(this.raw);
	}
}