package stx;

import Prelude;
import Stax.*;
import stx.Compare.*;
import stx.ds.Map;

using stx.Option;
using stx.Tuples;
using stx.Compose;

        typedef PFMethod<A,Z>  = Tuple2<Method<A,Bool>,Method<A,Z>>;
        typedef PartialFunctionType<A,Z>  = Array<PFMethod<A,Z>>;
private typedef PF<A,Z>               = PartialFunctions<A,Z>;

class PFMethods{
  static public function unit<A>():PFMethod<A,A>{
    var m : Method<A,A>     = Compose.unit();
    var p : Method<A,Bool>  = never().toMethod();
    return tuple2(p,m);
  }
}
@:note("#0b1kn00b: terminology of orAlways is inconsistent with rest of library")
abstract PartialFunction<A,Z>(PartialFunctionType<A,Z>) from PartialFunctionType<A,Z> to PartialFunctionType<A,Z>{
  public function new(v){
    this = v;
  }
  public function isDefinedAt(a: A): Bool {
    return PF.isDefinedAt(this,a);
  }
  public function orElse(that: PartialFunctionType<A, Z>): PartialFunctionType<A, Z> {
    return PF.orElse(this,that);
  }
  public function orAlways(f: A ->  Z): PartialFunctionType<A, Z> {
    return PF.orAlways(this,f);
  }
  public function orAlwaysC(pf:PF<A,Z>,z: Thunk<Z>): PartialFunctionType<A, Z> {
    return PF.orAlwaysC(this,z);
  }
  public function iterator():Iterator<PFMethod<A,Z>>{
    return this.iterator();
  }
  public function apply(a: A): Z {
    return PF.apply(this,a);
  } 
  @:to public function toFunction():A -> Option<Z>{
    var self = this;
    return function(a) {
      return if (PF.isDefinedAt(self,a)){
        Some(PF.apply(self,a));
      }else{
        None;
      }
    }
  }
  @:from static public function fromMap<K,V>(map:Map<K,V>):PartialFunction<K,V>{
    return [tuple2(
      method1(map.containsKey),
      method1(function(k) {
        return switch(map.get(k)) {
          case Some(v): v;
          case None:    except()(IllegalOperationError("No value for this key"));
        }
      })
    )];
  }
} 
class PartialFunctions<A, Z>{
  @:noUsing static public function unit<A,Z>():PartialFunctionType<A,Z>{
    return create([tuple2(never().toMethod(),cast noop)]);
  }  
  static public function toPartialFunctionType<A, Z>(def: Array<Tuple2<Method<A,Bool>, Method<A,Z>>>):PartialFunctionType<A, Z> {
    return def;
  }
  @:noUsing static public function create<A, Z>(def: Array<Tuple2<Method<A,Bool>, Method<A,Z>>>):PartialFunctionType<A, Z> {
    return def;
  }
  static public function isDefinedAt<A,Z>(pf:PartialFunctionType<A,Z>,a: A): Bool {
    for (d in pf) {
      if (d.fst().apply(a)) return true;
    }
    return false;
  }
  static public function orElse<A,Z>(pf:PartialFunctionType<A,Z>,that: PartialFunctionType<A, Z>): PartialFunctionType<A, Z> {
    return create(pf.concat(
      [tuple2(method1(isDefinedAt.bind(that)), method1(apply.bind(that)))]
    ));
  }
  static public function orAlways<A,Z>(pf:PartialFunctionType<A,Z>,f: A ->  Z): PartialFunctionType<A, Z> {
    return create(pf.concat([
      tuple2(method1(function(a) { return true; }),method1(f))
    ]));
  }
  static public function orAlwaysC<A,Z>(pf:PartialFunctionType<A,Z>,z: Thunk<Z>): PartialFunctionType<A, Z> {
    return create(pf.concat([
      tuple2(method1(function(a) { return true; }),method1(function(a) { return z(); }))
    ]));
  }
  static public function apply<A,Z>(pf:PartialFunctionType<A,Z>,a: A): Z {
    for (d in pf) {
      if (d.fst().apply(a)) return d.snd().apply(a);
    }
    return except()(IllegalOperationError("Function undefined at " + a));
  } 
  static public function toFunction<A,Z>(pf:PartialFunctionType<A,Z>): A -> Option<Z> {
    var self = pf;
    return function(a) {
      return if (isDefinedAt(self,a)) Some(apply(self,a));
             else None;
    }
  }
}