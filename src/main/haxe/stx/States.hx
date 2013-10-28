package stx;

import stx.Tuples;
import stx.Prelude;
import stx.ifs.Apply;

using stx.Tuples;
using stx.Functions;
using stx.Compose;
using stx.Anys;
using stx.States;

typedef StateType<S,R> = S -> Tuple2<S,A>;
abstract State<S,R>(StateType<S,R>) from StateType<S,R> to StateType<S,R>{
  @:noUsing static public function unit<S>():State<S,Unit>{
    return function(s:S){
      return tuple2(Unit,s);
    }
  }
  public function new(v){
    this = v;
  }
  @:from static public function fromApply<A,B>(opts:ApplyType<A,Tuple2<B,A>>):State<A,B>{
    return new State(opts.apply);
  }
  public function apply(s:S):Tuple2<S,A>{
    return this(s);
  }
}
class State<S,R>{
  
  @:noUsing static public function toState<S,A>(value:A):State<S,A>{
    return State.pure(
        function(s:S):Tuple2<A,S>{
          return tuple2(value,s);
        }
      );
  }
  @:noUsing static public function pure<A,B>(fn:A->Tuple2<B,A>):State<A,B>{
    return State.create({
        apply : 
          function(a:A){
            return fn(a);
          }
      });
  }
  static public function apply<S,R>(state:State<S,R>,s:S):Tuple2<R,S>{
    return state.apply(s);
  }
  @doc("Run `State` with `s`, dropping the result and returning `s`.")
  static public function exec<S,R>(st:State<S,R>,s:S):S{
    return apply(s).snd();
  }
  @doc("Run `State` with `s`, returning the result.")
  static public function eval(st:State<S,R>,s:S):R{
    return apply(s).fst();
  }
  static public function map<S,R,R1>(st:State<S,R>,fn:R->R1):State<S,R1>{
    var fn2 : Tuple2<R,S> -> Tuple2<R1,S> = fn.first();
    return function(s:S){
      var o = this.apply(s);
      return tuple2(fn(o.fst()),o.snd());
    }
  }
  static public function foreach(st:State<S,R>,fn:R->Void):State<S,R>{
    return map(
      function(x){
        fn(x);
        return x;
      }
    );
  }
  static public function transform<S,R>(st:State<S,R>,fn:S->S):State<S,R>{
    return function(s:S):Tuple2<R,S>{
      var o = apply(s);
      return tuple2( o.fst(), fn(o.snd()) );
    }
  }
  public function flatMap<R1>(st:State<S,R>,fn:R->State<S,R1>):State<S,R1>{
    return apply
      .then( fn.pair(Compose.unit()) )
      .then(
        function(t:Tuple2<State<S,R1>,S>) {
          return t.fst().apply(t.snd());
        }
      )
  }
  public function getSt():State<S,S>{
    return State.pure(
        function(s:S):Tuple2<S,S>{
          var o = apply(s);
          return tuple2(o.snd(),o.snd());
        }
      );
  }
  public function putSt<S,R>(n:S):State<S,R>{
    return State.pure(
        function (s:S){
          return tuple2(null,n);
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
          return tuple2(this,s);
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