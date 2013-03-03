package stx;

import stx.Prelude;
import stx.ifs.Apply;

using stx.Tuples;
                      using stx.Functions;
                      using stx.Compose;
                      using stx.Dynamics;
                      using stx.States;

class State<S,R>{
  @:noUsing 
  static public function create<A,B>( opts : TApply<A,Tup2<B,A>> ):State<A,B>{
    return new State(opts);
  }
  @:noUsing
  static public function toState<S,A>(value:A):State<S,A>{
    return
      State.pure(
        function(s:S):Tuple2<A,S>{
          return Tuples.t2(value,s);
        }
      );
  }
  @:noUsing
  static public function unit<S>():State<S,Unit>{
    return 
      State.pure(
        function(s:S){
          return Tups.t2(Unit,s);
        }
      );
  }
  @:noUsing
  static public function pure<A,B>(fn:A->Tuple2<B,A>):State<A,B>{
    return 
      State.create({
        apply : 
          function(a:A){
            return fn(a);
          }
      });
  }
  dynamic public function apply(s:S):Tup2<R,S>{return null;}
  public function new(opts:TApply<S,Tup2<R,S>>){
    this.apply = opts.apply;
  }
  /**
  * Run `State` with `s`, dropping the result and returning `s`.
  */
  public function exec(s:S):S{
    return apply(s).second();
  }
  /**
  * Run `State` with `s`, returning the result.
  */
  public function eval(s:S):R{
    return apply(s).first();
  }
  public function map<R1>(fn:R->R1):State<S,R1>{
    var fn2 : Tuple2<R,S> -> Tuple2<R1,S> = fn.first();
    return 
      State.pure(
        function(s:S){
          var o = this.apply(s);
          return fn(o._1).entuple(o._2);
        }
      );
  }
  public function foreach(fn:R->Void):State<S,R>{
    return map(
      function(x){
        fn(x);
        return x;
      }
    );
  }
  public function mapSt(fn:S->S):State<S,R>{
    return
      State.pure(
        function(s:S):Tuple2<R,S>{
          var o = apply(s);
          return Tuples.t2( o._1, fn(o._2) );
        }
      );
  }
  public function flatMap<R1>(fn:R->State<S,R1>):State<S,R1>{
    return 
      State.pure(
        apply
        .then( fn.pair(Compose.unit()) )
        .then(
          function(t:Tuple2<State<S,R1>,S>) {
            return t._1.apply(t._2);
          }
        )
      );
  }
  public function getSt():State<S,S>{
    return 
      State.pure(
        function(s:S):Tuple2<S,S>{
          var o = apply(s);
          return Tuples.t2(o._2,o._2);
        }
      );
  }
  public function putSt<S,R>(n:S):State<S,R>{
    return 
      State.pure(
        function (s:S){
          return Tuples.t2(null,n);
        }
      );
  }
}
class StateRef<S,A>{
  private var value : A;
  public function new(v:A){
    this.value = v;
  }
  public function read():State<S,A> {
    return State.toState(value);
  }
  public function write(a:A):State<S,StateRef<S,A>>{
    return 
      State.pure(
        function(s:S){
          this.value = a;
          return Tuples.t2(this,s);
        }
      );
  }
  public function modify(f:A->A):State<S,StateRef<S,A>> {
    var a = read();
    var v = a.flatMap(f.then(write));
    return v;
  }
  
  public static function newVar<S,A>(v:A):State<WorldState,StateRef<WorldState,A>>{
    return State.toState(new StateRef(v));
  }
  public static function run<A>(v:State<WorldState,StateRef<WorldState,A>>){
    v.apply( new WorldState() );
  }
}
class StateRefs{
  public static function modifier<S,A>(f:A->A,sr:StateRef<S,A>):State<S,StateRef<S,A>>{
    return sr.modify(f);
  }
  public static function reader<S,A>(sr:StateRef<S,A>):State<S,A>{
    return sr.read();
  }
}
private class WorldState{
  public function new(){

  }
}