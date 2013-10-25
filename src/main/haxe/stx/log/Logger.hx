package stx.log;

import haxe.PosInfos;

interface Logger {
  public function apply(v:Dynamic, ?pos:PosInfos):Void;

  public  var level(default,null)       : LogLevel;
}