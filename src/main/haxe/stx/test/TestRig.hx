package stx.test;

import haxe.rtti.CType;

import stx.Outcome;
import stx.Contract;
import stx.Prelude;
import Stax.*;
import stx.Compare.*;
import stx.rtti.Reflection;
import stx.rtti.RType;
import stx.rtti.RTypes;
import stx.test.*;
import stx.Tuples;
import stx.rtti.Routine;

using stx.UnitTest;
using stx.Compare;
using stx.Arrow;
using stx.Arrays;
using stx.Option;
using stx.Strings;
using stx.Contract;
using stx.Either;

abstract TestRig(Array<Reflection<Dynamic>>) from Array<Reflection<Dynamic>>{
  public function new(?v){
    this = nl().apply(v) ? [] : v;
  }
  public function add(t:TestCase,?prefix:String='test'):TestRig{
    return this.add(parse(t,prefix));
  }
  public function append(arr:Array<TestCase>,?prefix='test'):TestRig{
    return this.append(arr.map(parse.bind(_,prefix)));
  }
  public function reply():Contract<Array<KV<Array<TestResult>>>>{
    return this.bindFold( [],
      function(itm,kv){
        return kv.routines().bindFold( [],
          function(arr,fld){
            return invoke(fld).map(arr.append);
          }
        ).map(tuple2.bind(kv.object())).map(itm.add);
      }
    );
  }
  public function run(){
    reply().map(Printers.print).foreach(
      function(e){
        switch (e){
          case Failure(l)   : trace(l);
          case Success(r)   : trace(r);
        }
      }
    );
  }
  static public function parse(t:TestCase,prefix:String = 'test'):Reflection<Dynamic>{
    var o = t.introspect().reflection(
      function(x:ClassField) {
        return x.name.startsWith(prefix);
      }.and(
      function(x){
        return switch (x.type) {
          case CFunction(args,_) :
            switch (args.first().t) {
              case CAbstract(name, _) if (name == 'stx.UnitArrow')  : true;
              case _                                                : false;
            }
          case _                 : false;
        }
      })
    );
    return o;
  }
  static private function invoke(fld:Routine<Dynamic>){
    var o : Outcome<UnitArrow> = fld.applySecure([UnitArrow.unit()]).retry(
      function(e):Outcome<Dynamic>{
        return Success(UnitArrow.unit().add(TestArrow.unit().val(Some(e))));
      }
    );
    var p : Contract<UnitArrow> = Contract.pure(o);
    return p.flatMap(
      function(arw:UnitArrow):Contract<Array<TestResult>>{
        var o = arw.reply();
        var o0 =  o.map(Success).toContract();
        return o0;
      }
    );
  }
}