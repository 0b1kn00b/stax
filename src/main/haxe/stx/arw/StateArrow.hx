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
  @:from static public function fromFutureConstructor<S,A>(fn:S->Future<A>):StateArrow<S,A>{
    return fromArrow(fn.arrowOf());
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
  public function change(a1:Arrow<Tup2<A,S>,S>):StateArrow<S,A>{
    return new StateArrow( this.fan().then(a1.second())
      .then(
        function(l:Tuple2<A,S>,r){
          return Tups.t2(l.fst(),r);
        }.spread().lift()
      )
    );
  }
  public function use(a:Arrow<S,S>):StateArrow<S,A>{
    return change( this,
      a.second().then(T2s.snd.lift())
    );
  }
  public function drawWith<B,C>(a:Arrow<S,B>,fn:A->B->C):StateArrow<S,C>{
    return access( this,
      a.second().then(fn.spread().lift())
    );
  }
  public function draw<B>(a:Arrow<S,B>):StateArrow<S,Tup2<A,B>>{
    return drawWith(this,a,Tups.t2);
  }
  public function access<B>(a1:Arrow<Tup2<A,S>,B>):StateArrow<S,B>{
    return new StateArrow(
      this.join(a1)
      .then(
        function(l:Tup2<A,S>,r:B){
          return Tups.t2(r,l.snd());
        }.spread().lift()
      )
    );
  }
  public function nextWith<B,C>(a1:StateArrow<S,B>,fn:A->B->C):StateArrow<S,C>{
    return this.then(
      function(v:A,st:S){
        return a1.then(
          function(v0:B,st:S){
            return fn(v,v0).entuple(st);       
          }.spread().lift()
        ).apply(st);
      }.spread().arrowOf()
    );
  }
  public function next<B>(a1:StateArrow<S,B>):StateArrow<S,Tuple2<A,B>>{
    return nextWith(this,a1,Tups.t2);
  }
  public function split<B>(a1:StateArrow<S,B>):StateArrow<S,Tuple2<A,B>>{
    return this.split(a1).then(
      function(l:Tup2<A,S>,r:Tup2<B,S>){
        return Tups.t2(Tups.t2(l.fst(),r.fst()),r.snd());
      }.spread().lift()
    );
  }
  public function edit<B>(a1:Arrow<A,B>):StateArrow<S,B>{
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
          return Tups.t2(tp.snd(),tp.snd());
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
  public function request(?i:S):Future<A>{
    return this.apply(i).map(T2s.fst);
  }
  public function resolve(?i:S):Future<S>{
    return this.apply(i).map(T2s.snd);
  }
  @:to public inline function toArrow(){
    return this;
  }
}