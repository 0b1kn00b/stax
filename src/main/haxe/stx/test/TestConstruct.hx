package stx.test;
import haxe.rtti.CType;

import hx.reactive.Dispatcher;

import stx.async.Future;
import stx.reactive.Rx.*;
import stx.async.Dissolvable;
using  stx.reactive.Observable;
using  stx.reactive.Observer;

import Prelude;
import stx.Chunk;
import Stax.*;
import stx.Types.*;
import stx.Compare.*;
import stx.rtti.Field;
import stx.rtti.Reflection;
import stx.rtti.RType;
import stx.rtti.RTypes;
import stx.test.*;
import stx.Tuples;
import stx.rtti.Routine;
import stx.async.Promise;

using stx.Functions;
using stx.Tuples;
using stx.Strings;
using stx.Iterables;
using stx.Objects;
using stx.Anys;
using stx.Outcome;
using stx.async.Continuation;
using stx.UnitTest;
using stx.Types;
using stx.Compare;
using stx.async.Arrowlet;
using stx.Arrays;
using stx.Option;
using stx.Outcome;
using stx.Strings;
using stx.Either;

using stx.Compose;

class TestConstruct extends Dispatcher<TestResult>{
  static public function create(suite,prefix){
    return new TestConstruct(suite,prefix);
  }
  public var suite(default,null)    : Suite;
  public var prefix(default,null)   : String;

  public function new(suite:Suite,prefix = 'test'){
    super();
    this.suite  = suite;
    this.prefix = prefix;
  }
  private function name():String{
    return definition(this).name();
  }
  static public function parse(c:Suite,prefix='test'):Array<String>{
    return definition(c).locals()
      .map(
        noop1.split(Reflects.getValue.bind(c))
      ).filter(
        Strings.startsWith.bind(_,prefix)
        .pair(Reflect.isFunction)
        .then(Bools.and.tupled())
      ).map(fst);
  }
  static public function apply(suite:Suite,keys:Array<String>):Observable<TestResult>{
    var dispatch : Dispatcher<Chunk<TestResult>>  = new Dispatcher();
    var obs      : Observable<TestResult>         = dispatch.observable().buffer();
    var out = keys.zip(keys.map(
      function(field:String){
        return Reflect.callMethod.bind(suite,Reflect.field(suite,field),[TestCase.unit()]).catching()();
      }
    ).map(
      Outcomes.orUse.bind(_,
        function(f:Fail){
          return TestCase.unit().add(Proof.unit().val(Some(f)));
        }
      )
    )).map(
      function(fld:String,cs:TestCase){
        return cs.reply().map(
          function(arr:Array<TestResult>){
            arr =  arr.map(TestResult.setSuite.bind(_,suite)).map(TestResult.setName.bind(_,fld));
            return arr;
          }
        );
      }.tupled()
    ).each(
      function(ft:Future<Array<TestResult>>){
        ft.apply(
          function(arr:Array<TestResult>){
            for(val in arr){
              dispatch.emit(Val(val));
            }
          }
        );
      }
    );
    Futures.wait(out).apply(
      function(x){
        dispatch.emit(Nil);
      }
    );
    return obs;
  }
  public function reply():Observable<TestResult>{
    return apply(suite,parse(suite));
  }
}