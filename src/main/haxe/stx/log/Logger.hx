package stx.log;

import haxe.PosInfos;

interface Logger {
  private function check(v:Dynamic, pos:PosInfos):Bool;
  public function apply(v:Dynamic, ?pos:PosInfos):Void;

  public  var level(default,null)       : LogLevel;
}