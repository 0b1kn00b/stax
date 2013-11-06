package hx.sch.run;

import stx.type.*;

import Prelude;

import hx.ifs.Run in IRun;

class AnonymousRun implements IRun{
  private var codeblock : Niladic;
  public function new(codeblock){
    this.codeblock = codeblock;
  }
  public inline function run(){
    this.codeblock();
  }
}