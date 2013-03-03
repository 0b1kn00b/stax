package stx.arw;

import stx.Prelude;

using stx.Tuples;
using stx.arw.Arrows;
using stx.Compose;

typedef ArrowState<S,A> = Arrow<S,Tuple2<A,S>>;

abstract StateArrow<S,A>(ArrowState<S,A>) from ArrowState<S,A> to ArrowState<S,A>{
  @:from static public function fromFunction<S,A>(fn:S->A):StateArrow<S,A>{
    return new StateArrow(function(s:S){
      return Tups.t2(fn(s),s);
    }.lift());
  }
  @:from static public function fromArrow<S,A>(arw:Arrow<S,A>):StateArrow<S,A>{
    return new StateArrow(
      function(s:S){
        return arw.apply(s).map(Tups.t2.bind(_,s));
      }.arrowOf()
    );
  }
  @:noUsing
  static public function unit<S,A>():StateArrow<S,A>{
    return new StateArrow(
      function(s:S):Tup2<A,S>{
        return Tups.t2(null,s);
      }.lift()
    );
  }
  public function new(v){
    this = v;
  }
  public function reply():ArrowState<S,A>{
    return this;
  }
  public function mod(a1:Arrow<Tup2<A,S>,S>):StateArrow<S,A>{
    return new StateArrow( this.fan().then(a1.second())
      .then(
        function(l:Tuple2<A,S>,r){
          return Tups.t2(l._1,r);
        }.spread().lift()
      )
    );
  }
  public function change<B>(a1:Arrow<Tup2<A,S>,B>):StateArrow<S,B>{
    return new StateArrow(
      this.join(a1)
      .then(
        function(l:Tup2<A,S>,r:B){
          return Tups.t2(r,l._2);
        }.spread().lift()
      )
    );
  }
  public function map<B>(a1:Arrow<A,B>):StateArrow<S,B>{
    return new StateArrow(
      this.then(
        a1.first()
      )
    );
  }
  public function put(v:S):StateArrow<S,A>{
    return new StateArrow(
      this.then(
        v.pure().second().lift()
      )
    );
  }
  public function ret():StateArrow<S,S>{
    return new StateArrow(
      this.then(
        function(tp:Tup2<A,S>){
          return Tups.t2(tp._2,tp._2);
        }.lift()
      )
    );
  }
  public function withInput(?i : S, cont : Function1<Tup2<A,S>,Void>) : Void{
    this.withInput(i,cont);
  }
  public function apply(?i:S):Future<Tup2<A,S>>{
    return this.apply(i);
  }
}
class StateArrows{
  static public function mod<S,A>(a0:StateArrow<S,A>,fn:Tup2<A,S>->S):StateArrow<S,A>{
    return a0.mod(fn.lift());
  }
  static public function change<S,A,B>(a0:StateArrow<S,A>,fn:Tup2<A,S>->B):StateArrow<S,B>{
    return a0.change(fn.lift());
  }
  static public function map<S,A,B,C>(a0:StateArrow<S,A>,fn:A->B):StateArrow<S,B>{
    return a0.map(fn.lift());
  }
}