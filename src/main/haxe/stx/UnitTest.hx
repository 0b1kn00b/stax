package stx;

import stx.plus.Show;
import Stax.*;
import stx.Compare.*;
import stx.Log.*;
import stx.rtti.*;

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
using stx.Arrow;
using stx.Compose;
using stx.Functions;

class UnitTest{
  static public function rig(){
    return new TestRig();
  }
  static public function isAlike(val0:EnumValue,val1:EnumValue,?pos:PosInfos):TestArrow{
    return it('should be alike',alike(val0),val1,pos);
  }
  static public function isTrue(val,?pos:PosInfos):TestArrow{
    return it('should be true',ok(),val,pos);
  }
  static public function isFalse(val,?pos:PosInfos):TestArrow{
    return it('should be false',no(),val,pos);
  }
  static public function isEqual<T>(val0:T,val1:T,?pos:PosInfos):TestArrow{
    return it('should be equal',eq(val0),val1,pos);
  }
  static public function isNotEqual<T>(val0:T,val1:T,?pos:PosInfos):TestArrow{
    return it('should not be equal',eq(val0).not(),val1,pos);
  }
  static public function hasFail(fn:Void->Void,?type:Class<Dynamic> ,?pos:PosInfos):TestArrow{
    return it('should throw a fail.',throws(type),fn,pos);
  }
  static public function fails(?err:Fail,?pos:PosInfos):TestArrow{
    err = nl().apply(err) ? fail(AssertionError('fail called',null,pos)) : err;
    return TestArrow.unit().val(Some(err)).pos(pos);
  }
  static public function it<T>(msg:String,prd:Predicate<T>,?val:T,?pos:PosInfos):TestArrow{
    var er = fail(AssertionError(Std.string(val),msg,pos));
    return TestArrow.unit()
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
      );
  }
}
class MusterPromises0{
  static public function flatten(arr:Promise<Array<TestArrow>>):UnitArrow{
    return new UnitArrow(
      Arrows.then(UnitArrow.unit(),
      function(arr0:Array<TestArrow>){
        return arr.map(
          function(arr1){
            return arr0.append(arr1);
          }
        );
      }
    ));
  }
}
class MusterPromises{
  static public function flatten(t:Promise<TestArrow>):TestArrow{
    var arw = TestArrow.unit().then( 
        function(r:TestResult){
          return t.flatMap(
            function(x:TestArrow){
              var o = x.apply(r);
              return o;
            }
          );
        }.lift()
      );
    return arw;
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
class TestCase extends Introspect{
  public function new(){super();}
  public function isAlike(val0,val1,?pos:PosInfos):TestArrow{
    return UnitTest.isAlike(val0,val1,pos);
  }
  public function isTrue(val,?pos:PosInfos):TestArrow{
    return UnitTest.isTrue(val,pos);
  }
  public function isFalse(val,?pos:PosInfos):TestArrow{
    return UnitTest.isFalse(val,pos);
  }
  public function isEqual<T>(val0:T,val1:T,?pos:PosInfos):TestArrow{
    return UnitTest.isEqual(val0,val1,pos);
  }
  public function isNotEqual<T>(val0:T,val1:T,?pos:PosInfos):TestArrow{
    return UnitTest.isNotEqual(val0,val1,pos);
  }
  public function hasFail(fn:Void->Void,?type:Class<Dynamic> ,?pos:PosInfos):TestArrow{
    return UnitTest.hasFail(fn,type,pos);
  }
  public function fails(?err:Fail,?pos:PosInfos):TestArrow{
    return UnitTest.fails(err,pos);
  }
  public function it<T>(msg:String,prd:Predicate<T>,?val:T,?pos:PosInfos):TestArrow{
    return UnitTest.it(msg,prd,val,pos);
  }
}
abstract UnitArrow(Arrow<Array<TestArrow>,Array<TestArrow>>) from Arrow<Array<TestArrow>,Array<TestArrow>> to Arrow<Array<TestArrow>,Array<TestArrow>>{
  @:noUsing static public function unit():UnitArrow{
    return new UnitArrow();
  }
  public function new(?v){
    this = nl().apply(v) ? Arrow.unit() : v;
  }
  public function then(arw:UnitArrow):UnitArrow{
    return this.then(arw);
  }
  public function add(t:TestArrow):UnitArrow{
    return this.then(Arrays.add.bind(_,t));
  }
  public function append(ar:Array<TestArrow>):UnitArrow{
    return this.then(Arrays.append.bind(_,ar));
  }
  public function reply(){
    return this.proceed([]).flatMap(
      function(arr){
        return Continuation.bindFold(arr,
          [],
          function(memo:Array<Dynamic>,next){
            return next.proceed(TestResult.unit()).map(memo.add);
          }
        );
      }
    );
  }
}