package stx.test;

import Stax.*;
import stx.Compare.*;

using stx.Arrow;

abstract TestArrow(Arrow<TestResult,TestResult>) from Arrow<TestResult,TestResult> to Arrow<TestResult,TestResult>{
  @:noUsing static public function unit():TestArrow{
    return new TestArrow(function(r:TestResult){ return r;});
  }
  /*@:from */static public inline function fromFutureTestArrow(t:Future<TestArrow>):TestArrow{
    var arw = TestArrow.unit().then( 
        function(r:TestResult,cont:TestResult->Void){
          t.flatMap(
            function(x:TestArrow){
              var o = x.proceed(r);
              return o;
            }
          ).each(cont);
        }
      );
    return arw;
  }
  @:from static public inline function fromEventualTestArrow(evt:Eventual<TestArrow>):TestArrow{
    return fromFutureTestArrow(evt.each);
  }
  public function new(?v){
    this = nl().apply(v) ? Arrow.unit() : v;
  }
  public function val(v):TestArrow{
    return this.then(TestResult.setVal.bind(_,v));
  }
  public function pos(p):TestArrow{
    return this.then(TestResult.setPos.bind(_,p));
  }
  public function msg(m):TestArrow{
    return this.then(TestResult.setMsg.bind(_,m));
  }
}