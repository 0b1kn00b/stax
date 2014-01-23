package stx.test;

import Stax.*;
import haxe.PosInfos;

import Prelude;

import stx.test.TestErrors;

import stx.Fail;
import stx.UnitTest;

using stx.Types;

class TestResult{

  public var val(default,null)      : Option<Fail>;
  public var pos(default,null)      : PosInfos;
  public var msg(default,null)      : String;

  public var suite(default,null)    : String;
  public var name(default,null)     : String;

  public function new(?suite,?name,?val,?msg,?pos){
    this.suite        = suite;
    this.name         = name;
    this.val          = val == null ? Some(fail(FrameworkError(PendingTestError))) : val;
    this.msg          = msg == null ? "" : msg;
    this.pos          = pos;
  }
  static public function setSuite(rs:TestResult,s:Suite){
    return new TestResult(definition(s).name(),rs.name,rs.val,rs.msg,rs.pos);
  }
  static public function setName(rs:TestResult,name:String){
    return new TestResult(rs.suite,name,rs.val,rs.msg,rs.pos);
  }
  static public function setVal(rs:TestResult,v:Option<Fail>){
    return new TestResult(rs.suite,rs.name,v,rs.msg,rs.pos);
  }
  static public function setPos(rs:TestResult,p:PosInfos){
    return new TestResult(rs.suite,rs.name,rs.val,rs.msg,p);
  }
  static public function setMsg(rs:TestResult,m:String){
    return new TestResult(rs.suite,rs.name,rs.val,m,rs.pos);
  }
  public function toString(){
    return (switch (val){
      case Some(l)  : msg + ' : ' + stx.Show.getShowFor(l)(l);
      case None     : 'OK';// + msg + ' ' + Positions.toString(pos);
    });
  }
}