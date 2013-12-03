package stx.test;

import Stax.*;
import stx.Compare.*;

using stx.Arrowlet;

abstract Proof(Arrowlet<TestResult,TestResult>) to Arrowlet<TestResult,TestResult>{
  @:noUsing static public function unit():Proof{
    return new Proof(function(r:TestResult){ return r;});
  }
  @:from static public inline function fromEventualTest(evt:Eventual<Proof>):Proof{
    var arw = new Proof(Proof.unit().then( 
        function(r:TestResult,cont:TestResult->Void){
          evt.flatMap(
            function(x:Proof){
              return x.apply(r);
            }
          ).each(cont);
        }
      ));
    return arw;
  }
  @:from static public inline function fromFutureTest(t:Future<Proof>):Proof{
    var evt : Eventual<Proof> = t;
    return fromEventualTest(evt);
  }
  public function new(?v){
    this = nl().apply(v) ? Arrowlet.unit() : v;
  }
  public function val(v):Proof{
    return new Proof(this.then(TestResult.setVal.bind(_,v)));
  }
  public function pos(p):Proof{
    return new Proof(this.then(TestResult.setPos.bind(_,p)));
  }
  public function msg(m):Proof{
    return new Proof(this.then(TestResult.setMsg.bind(_,m)));
  }
}