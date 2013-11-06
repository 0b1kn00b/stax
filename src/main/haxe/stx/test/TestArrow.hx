package stx.test;

import Stax.*;
import stx.Compare.*;

using stx.Arrow;

abstract TestArrow(Arrow<TestResult,TestResult>) from Arrow<TestResult,TestResult> to Arrow<TestResult,TestResult>{
  @:noUsing static public function unit():TestArrow{
    return new TestArrow(function(r:TestResult){ return r;});
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