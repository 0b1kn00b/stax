package stx.io.log;

using stx.Positions;

class LogItem{
  public var time       : Float;
  public var pos        : haxe.PosInfos;
  public var level      : LogLevel;
  public var value      : Dynamic;

  public function new(level, value, pos) {
    this.time       = Date.now().getTime();
    this.pos        = pos;
    this.level      = level;
    this.value      = value;
  }
  public function toString(){
    var _pos = pos.toString();
    return '$level $time $_pos ${stx.Show.getShowFor(value)(value)}';
  }
  public function toJson(){
    return haxe.Json.stringify(this);
  }
}