package hx.sch;

import stx.Prelude;

import hx.ifs.Run in IRun;
import hx.sch.run.AnonymousRun;

abstract Run(IRun) from IRun to IRun{
  public function new(v){
    this = v;
  }
  @:from static public function fromCodeBlock(cb:CodeBlock):Run{
    return new AnonymousRun(cb);
  }
  public inline function run():Void{
    this.run();
  }
}