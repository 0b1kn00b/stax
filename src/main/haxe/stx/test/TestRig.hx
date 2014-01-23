package stx.test;

import haxe.rtti.CType;

import hx.reactive.Dispatcher;

import stx.async.Future;
import stx.reactive.Rx.*;
import stx.async.Dissolvable;

using  stx.reactive.Observable;
using  stx.reactive.Observer;

import Prelude;

import hx.ds.MultiMap;

import Stax.*;
import stx.Compare.*;
import stx.rtti.Field;
import stx.rtti.Reflection;
import stx.rtti.RType;
import stx.rtti.RTypes;
import stx.test.*;
import stx.Tuples;
import stx.rtti.Routine;
import stx.async.Promise;
import stx.test.TestErrors;
import stx.Stringify;

using stx.Enums;
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
using stx.ValueTypes;
using stx.Compose;

typedef TestRigType = Array<TestConstruct>;
abstract TestRig(TestRigType) from TestRigType{
  public function new(?v){
    this = nl().apply(v) ? [] : v;
  }
  public function add(t:Suite,?prefix:String='test'):TestRig{
    return this.add(new TestConstruct(t,prefix));
  }
  public function append(arr:Array<Suite>,?prefix='test'):TestRig{
    return this.append(arr.map(TestConstruct.create.bind(_,prefix)));
  }
  public function reply():Observable<TestResult>{
    var observable : Observable<TestResult>         = Observable.empty();
    var o : Observable<TestResult> =  this.foldLeft(
      observable,
      function(memo:Observable<TestResult>,next:TestConstruct){
        var o : Observable<TestResult> = next.reply();
        return memo.merge(o);
      }
    ).buffer();
    return o;
  }
  public function run(){
    #if (sys || hx_node)
      var prints  = Sys.print;
    #else
      var marks   = [];
      var prints  = function(x) marks.push(x);
    #end
    var error_stack = new MultiMap();
    reply().subscribe(
      function(chk:Chunk<TestResult>){
        switch(chk){
          case Val(v) : 
            switch (v.val) {
              case Some(e) : 
                error_stack.set('${v.suite}.${v.name}',v);
                var err : ErrorType = cast e.cde;
                switch(err){
                  case FrameworkError(e)   if(PendingTestError.equals(e)) : prints('P');
                  default                                                 : prints('E');
                }
              default : prints('.');
            }          
          case End(e) : 
          case Nil    : 
            #if (!sys && !hx_node)
              prints = function(x) stx.io.log.LogTrace.trace(x);
              prints(marks.foldLeft('',Strings.append));
            #else
              prints("\n");
            #end

            if(error_stack.size() > 0){
              prints(
              error_stack
                .zip(error_stack.vals())
                .map(
                  function(l,r){
                    return '${Show.show(l)} ${Show.show(r)}';
                  }.tupled()
                ).map(Show.show)
                .map('\n'.append)
                .foldLeft('',Strings.append)
              );
            }else{
              prints('ok\n');
            }
        }
      }
    );
  }
  static public function parse(t:Suite,prefix:String = 'test'):Tuple2<Suite,Field<Array<Tuple2<Suite,Field<Endo<TestCase>>>>>>{
    var o : Field<Array<Tuple2<Suite,Field<Endo<TestCase>>>>> =
    tuple2(
      vtype(t).name(),
      definition(t).locals().map(
        noop1.split(Reflects.getValue.bind(t))
      ).filter(
        Strings.startsWith.bind(_,prefix)
        .pair(Reflect.isFunction)
        .then(Bools.and.tupled())
      ).toArray()
      .map(
        function(l:String,r:Dynamic):Tuple2<Suite,Field<Endo<TestCase>>>{
          return tuple2(t,(tuple2(l,r):Field<Endo<TestCase>>));
        }.tupled()
      )
    );
    return tuple2(t,o);
  }
}