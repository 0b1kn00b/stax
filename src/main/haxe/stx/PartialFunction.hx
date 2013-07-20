package stx;

using stx.PartialFunction;
using stx.Prelude;
using stx.Tuples;
using stx.Compose;

        typedef PredicateMethod<A,Z>  = Tuple2<Method<A,Bool>,Method<A,Z>>;
        typedef PartialFunction<A,Z>  = Array<PredicateMethod<A,Z>>;
private typedef PF<A,Z>               = PartialFunction<A,Z>;

class PredicateMethods{
  static public function unit<A>():PredicateMethod<A,A>{
    return tuple2(Predicates.zero(),Compose.unit());
  }
}
class PartialFunctions<A, Z>{
  @:noUsing static public function unit<A,Z>():PartialFunction<A,Z>{
    return create([tuple2(Compose.pure(false),null)]);
  }  
  static public function toPartialFunction<A, Z>(def: Array<Tuple2<Method<A,Bool>, Method<A,Z>>>):PartialFunction<A, Z> {
    return def;
  }
  @:noUsing static public function create<A, Z>(def: Array<Tuple2<Method<A,Bool>, Method<A,Z>>>):PartialFunction<A, Z> {
    return def;
  }
  static public function isDefinedAt<A,Z>(pf:PF<A,Z>,a: A): Bool {
    for (d in pf) {
      if (d.fst().apply(a)) return true;
    }
    return false;
  }
  
  static public function orElse<A,Z>(pf:PF<A,Z>,that: PartialFunction<A, Z>): PartialFunction<A, Z> {
    return create(pf.concat(
      [tuple2(that.isDefinedAt, that.apply)]
    ));
  }
  
  static public function orAlways<A,Z>(pf:PF<A,Z>,f: A ->  Z): PartialFunction<A, Z> {
    return create(pf.concat([
      tuple2(function(a) { return true; },f)
    ]));
  }
  
  static public function orAlwaysC<A,Z>(pf:PF<A,Z>,z: Thunk<Z>): PartialFunction<A, Z> {
    return create(pf.concat([
      tuple2((function(a) { return true; }),function(a) { return z(); })
    ]));
  }
  
  static public function apply<A,Z>(pf:PF<A,Z>,a: A): Z {
    for (d in pf) {
      if (d.fst().apply(a)) return d.snd().apply(a);
    }
    return Prelude.error()("Function undefined at " + a);
  }
    
  static public function toFunction<A,Z>(pf:PF<A,Z>): A -> Option<Z> {
    var self = pf;
    return function(a) {
      return if (self.isDefinedAt(a)) Some(self.apply(a));
             else None;
      }
    }
}