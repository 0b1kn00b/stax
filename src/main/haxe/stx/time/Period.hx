package stx.time;

using stx.Maths;

class Period{
  
  private var raw (default,null): Float;
  
  public function new() {
    this.ready  = false;
  }
  static public function now() {
    return new Period().setRaw(haxe.Timer.stamp());
  }
  public function setRaw(v:Float){
    this.raw    = v;
    return this;
  }
  public function getRaw(){
    return this.raw;
  }
  @doc("Add Periods together.")
  public function add(t:Period):Period {
    return new Period().setRaw( this.raw + t.raw );
  }
  @doc("Subtracts Periods.")
  public function sub(t:Period):Period {
    return new Period().setRaw( this.raw - t.raw );
  }
  @doc("Multiplies Periods.")
  public function mul(t:Period):Period {
    return new Period().setRaw( this.raw * t.raw );
  }
  @doc("Divides Periods.")
  public function div(t:Period):Period {
    return new Period().setRaw( this.raw * t.raw );
  }
  
  @doc("Returns the modulo of two Periods.")
  public function mod(t:Period):Period {
    return new Period().setRaw( this.raw % t.raw );
  }
  
  private function determine() { 
    var o             =  this.raw;
    var days          = ( o / ( 1000 * 60 * 60 * 24 )).floor();
    o -= (0. + days) * 1000 * 60 * 60 *24;
    var hours         = (o / ( 1000 * 60 * 60 )).floor();
    o -= (0. + hours) * 1000 * 60 * 60;
    var minutes       = (o / ( 1000 * 60 )).floor();
    o -= (0. + minutes) * 1000 * 60;
    var seconds       = (o / 1000).floor();
    o -= (0. + seconds) * 1000;
    var milliseconds  = o.floor();
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
  static public function day(i:Int = 1): Period {
    return hour(i*24);
  }
  static public function hour(i:Int = 1): Period {
    return minute(i*60);
  }
  static public function minute(i:Int = 1): Period {
    return second(i*60);
  }
  static public function second(i:Int = 1): Period {
    return millisecond(i*1000);
  }
  static public function millisecond(i:Int): Period {
    return new Period().setRaw(i);
  }
  public function toString() {
    return '$days#$hours:$minutes:$seconds.$milliseconds';
  }
  public function toDate(){
    return Date.fromTime(this.raw);
  }
}