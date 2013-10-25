package stx.test;

import Stax.*;
import haxe.PosInfos;

import stx.Prelude;
import stx.Fail;
class TestResult{
  @:noUsing static public function unit(){
    return create();
  }
  @:noUsing
  static public function create(){
    return new TestResult();
  }
  public var val(default,null)      : Option<Fail>;
  public var pos(default,null)      : PosInfos;
  public var msg(default,null)      : String;

  public function new(?val,?msg,?pos){
    this.val         = val == null ? Some(fail(IllegalOperationFail('TestResult not set'))) : val;
    this.msg         = msg;
    this.pos         = pos;
  }
  static public function setVal(rs:TestResult,v){
    return new TestResult(v,rs.msg,rs.pos);
  }
  static public function setPos(rs:TestResult,p){
    return new TestResult(rs.val,rs.msg,p);
  }
  static public function setMsg(rs:TestResult,m){
    return new TestResult(rs.val,m,rs.pos);
  }
  public function toString(){
    return (switch (val){
      case Some(l)  : msg + ' : ' + Std.string(l);
      case None     : 'OK';// + msg + ' ' + Positions.toString(pos);
    });
  }
}