package stx;

import stx.plus.Show;
import Stax.*;
import stx.Compare.*;
import stx.Log.*;
import stx.rtti.*;

import stx.Future;
import haxe.rtti.CType;
import Type;

import haxe.PosInfos;

import stx.Fail;

import stx.plus.Equal;
import stx.test.*;

using stx.Continuation;
using stx.ValueTypes;
using stx.Compare;
using stx.Strings;
using stx.Option;
using stx.Reflects;
using stx.Either;
using stx.Promise;
using Prelude;
using stx.Contract;
using stx.Arrays;
using stx.Tuples;
using stx.Arrowlet;
using stx.Compose;
using stx.Functions;

class UnitTest{
  static public function rig(){
    return new TestRig();
  }
  static public function isAlike(val0:EnumValue,val1:EnumValue,?pos:PosInfos):Proof{
    return it('should be alike',alike(val0),val1,pos);
  }
  static public function isTrue(val,?pos:PosInfos):Proof{
    return it('should be true',ok(),val,pos);
  }
  static public function isFalse(val,?pos:PosInfos):Proof{
    return it('should be false',no(),val,pos);
  }
  static public function isEqual<T>(val0:T,val1:T,?pos:PosInfos):Proof{
    return it('should be equal',eq(val0),val1,pos);
  }
  static public function isNotEqual<T>(val0:T,val1:T,?pos:PosInfos):Proof{
    return it('should not be equal',eq(val0).not(),val1,pos);
  }
  static public function hasFail(fn:Void->Void,?type:Class<Dynamic> ,?pos:PosInfos):Proof{
    return it('should throw a fail.',throws(type),fn,pos);
  }
  static public function fails(?err:Fail,?pos:PosInfos):Proof{
    err = nl().apply(err) ? fail(AssertionError('fail called',null,pos)) : err;
    return Proof.unit().val(Some(err)).pos(pos);
  }
  static public function it<T>(msg:String,prd:Predicate<T>,?val:T,?pos:PosInfos):Proof{
    var er = fail(AssertionError(Std.string(val),msg,pos));
    return new Proof(Proof.unit()
      .msg(msg)
      .pos(pos)
      .then(
        function(r:TestResult){
          var v = (
            try{
              Assert.assert(val,null,prd,pos);
              None;
            }catch(d:Dynamic){
              Some(switch(Type.typeof(d)){
                case TClass(c) if (stx.Types.descended(c,Fail))  : cast d;
                default                                               : fail(d);
              });
            }
          );
          return new TestResult(v,r.msg,r.pos);
        }
      ));
  }
}
class Printers{
  static public function print(arr:Array<KV<Array<TestResult>>>){
    return arr.foldLeft('',
      function(memo,next){
        return memo.append('\n\t\t').append(next.fst()).append('').append(
          next.snd().foldLeft('\n',
            function(memo0,next0){
              return memo0.append('\t\t\t\t').append(Show.getShowFor(next0)(next0)).append('\n');
            }
        ));
      }
    );
  }
}
class Suite extends Introspect{
  public function new(){super();}
  public function isAlike(val0,val1,?pos:PosInfos):Proof{
    return UnitTest.isAlike(val0,val1,pos);
  }
  public function isTrue(val,?pos:PosInfos):Proof{
    return UnitTest.isTrue(val,pos);
  }
  public function isFalse(val,?pos:PosInfos):Proof{
    return UnitTest.isFalse(val,pos);
  }
  public function isEqual<T>(val0:T,val1:T,?pos:PosInfos):Proof{
    return UnitTest.isEqual(val0,val1,pos);
  }
  public function isNotEqual<T>(val0:T,val1:T,?pos:PosInfos):Proof{
    return UnitTest.isNotEqual(val0,val1,pos);
  }
  public function hasFail(fn:Void->Void,?type:Class<Dynamic> ,?pos:PosInfos):Proof{
    return UnitTest.hasFail(fn,type,pos);
  }
  public function fails(?err:Fail,?pos:PosInfos):Proof{
    return UnitTest.fails(err,pos);
  }
  public function it<T>(msg:String,prd:Predicate<T>,?val:T,?pos:PosInfos):Proof{
    return UnitTest.it(msg,prd,val,pos);
  }
}
abstract TestCase(Arrowlet<Array<Proof>,Array<Proof>>) to Arrowlet<Array<Proof>,Array<Proof>>{
  @:noUsing static public function unit():TestCase{
    return new TestCase();
  }
  /*@:from static public inline function fromEventuaProog(evt:Eventual<Proof>){
    trace('here');
    return new TestCase(new Arrowlet(
      function(arr0:Array<Proof>,cont:Array<Proof>->Void):Void{
        trace('here');
        evt.each(
          function(v){
            cont([v].append(arr0));
          }
        );
      }
    ));
  }*/
  /*
  static public inline function fromFutureTests(arr:Future<Array<Proof>>):TestCase{
    return new TestCase(new Arrowlet(
      function(arr0:Array<Proof>,cont:Array<Proof>->Void):Void{
        arr.map(
          function(arr1){
            return arr0.append(arr1);
          }
        ).each(cont);
      }
    ));
  }
  
  @:bug("Hangs compiler")
  @:from static public inline function fromEventualTests(arr:Eventual<Array<Proof>>){
    return fromFutureTests(arr.each);
  }*/
  public function new(?v){
    this = nl().apply(v) ? Arrowlet.unit() : v;
  }
  public function then(arw:TestCase):TestCase{
    return new TestCase(this.then(arw));
  }
  public function add(t:Proof):TestCase{
    return new TestCase(
      this.then(function(x:Array<Proof>):Array<Proof>{
        return x.add(t);
      })
    );
  }
  public function append(ar:Array<Proof>):TestCase{
    return new TestCase(this.then(Arrays.append.bind(_,ar)));
  }
  public function reply():Future<Array<TestResult>>{
    var prm : Future<Array<Proof>> = this.proceed([]);
    return prm.flatMap(
      function(arr){
        return Futures.bindFold(arr,
          [],
          function(memo:Array<Dynamic>,next:Proof){
            return next.proceed(TestResult.unit()).map(memo.add);
          }
        );
      }
    );
  }
}