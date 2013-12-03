package stx.test;

import haxe.rtti.CType;

import Prelude;
import Stax.*;
import stx.Compare.*;
import stx.rtti.Reflection;
import stx.rtti.RType;
import stx.rtti.RTypes;
import stx.test.*;
import stx.Tuples;
import stx.rtti.Routine;
import stx.Promise;

using stx.Outcome;
using stx.Continuation;
using stx.UnitTest;
using stx.Compare;
using stx.Arrowlet;
using stx.Arrays;
using stx.Option;
using stx.Outcome;
using stx.Strings;
using stx.Either;
using stx.ValueTypes;

abstract TestRig(Array<Reflection<Dynamic>>) from Array<Reflection<Dynamic>>{
  public function new(?v){
    this = nl().apply(v) ? [] : v;
  }
  public function add(t:Suite,?prefix:String='test'):TestRig{
    return this.add(parse(t,prefix));
  }
  public function append(arr:Array<Suite>,?prefix='test'):TestRig{
    return this.append(arr.map(parse.bind(_,prefix)));
  }
  public function reply():Promise<Array<KV<Array<TestResult>>>>{
    var o             = Contract.unit();
    var stack         = [];
    var num           = this.length;

    this.each(
      function(kv){
        Promises.bindFold(kv.routines(),[],
          function(arr,fld){
            return invoke(fld).map(arr.append);
          }
        ).map(tuple2.bind(Types.vtype(kv.object()).name()))
         .apply(
          function(v){
            v.onSuccess(stack.push);
            if(stack.length == this.length){
              o.deliver(Success(stack));
            }
          }
        );
      }
    );
    return o;
  }
  
  public function run(){
    reply().reply().map(Printers.print).each(
      function(e){
        switch (e){
          case Failure(l)   : trace(l);
          case Success(r)   : trace(r);
        }
      }
    );
  }
  static public function parse(t:Suite,prefix:String = 'test'):Reflection<Dynamic>{
    var o = t.introspect().reflection(
      function(x:ClassField) {
        return x.name.startsWith(prefix);
      }.and(
      function(x){
        return switch (x.type) {
          case CFunction(args,_) :
            switch (args.first().t) {
              case CAbstract(name, _) if (name == 'stx.TestCase')   : true;
              case _                                                : false;
            }
          case _                 : false;
        }
      })
    );
    return o;
  }
  static private function invoke(fld:Routine<Dynamic>):Promise<Array<TestResult>>{
    var o : Outcome<TestCase> = fld.applySecure([Proof.unit()]).retry(
      function(e:Fail):Outcome<TestCase>{
        return Success(TestCase.unit().add(Proof.unit().val(Some(e))));
      }
    );
    var p : Promise<TestCase> = Promise.pure(o);
    return p.flatMap(
      function(arw:TestCase):Promise<Array<TestResult>>{
        var o : Promise<Array<TestResult>> =  new Promise(arw.reply().map(Success));
        return o;
      }
    );
  }
}