package stx.arw;

import Stax.*;
import stx.Log.*;
import stx.Compare.*;

import stx.Continuation;
import Prelude;
import stx.Tuples.*;
import stx.Fail;

using stx.Eventual;
import stx.arw.StateArrow;

using stx.Option;
using stx.Arrow;
using stx.Compose;
using stx.Tuples;

import stx.Vouch;

using stx.Chunk;

typedef ArrowWindmill<S,A> = ArrowState<S,Chunk<A>>;

abstract Windmill<S,A>(ArrowWindmill<S,A>) from ArrowWindmill<S,A> to ArrowWindmill<S,A>{
  
  static public function mill<S,A>(?arw:ArrowState<S,Chunk<A>>):Windmill<S,A>{
    return new Windmill(arw);
  }
  @:noUsing static public function unit<S,A>():Windmill<S,A>{
    return new Windmill();
  }
  @:noUsing static public function pure<S,A>(a:A):Windmill<S,A>{
    return function(x){
        return tuple2(Val(a),x);
    };
  }
  @:noUsing static public function seed<S,A>(arw:Arrow<S,Chunk<A>>):Windmill<S,A>{
    var arw : Arrow<S,Tuple2<Chunk<A>,S>> = 
    function(x){
      return arw.apply(x).map(tuple2.bind(_,x));
    }; 
    return new Windmill(arw);
  }
  public function new(?v){
    this = ntnl().apply(v) ? v : 
      StateArrows.edit(StateArrows.unit(),
        function(x:Chunk<A>){
          return x == null ? Nil : x;
        }
      );
  }
  public function apply(s:S){
    return this.apply(s);
  }
  public function access<B>(a1:Arrow<Tuple2<A,S>,Chunk<B>>):Windmill<S,B>{
    return new Windmill(
      function(s:S){
        var vals : Eventual<Tuple2<Chunk<A>,S>> = this.apply(s);
        return vals.flatMap(
          function(e:Chunk<A>,s:S){
            return switch (e){
              case End(l)       : Eventual.pure(tuple2(End(l),s));
              case Val(r)       : a1.apply(tuple2(r,s)).map(tuple2.bind(_,s));
              case Nil          : Eventual.pure(tuple2(Nil,s));
            }
          }.tupled()
        );
      }
    );
  }
  public function accessOption<B>(a1:Arrow<Tuple2<Option<A>,S>,Chunk<B>>):Windmill<S,B>{
    return new Windmill(
      function(s:S){
        var vals : Eventual<Tuple2<Chunk<A>,S>> = this.apply(s);
        return vals.flatMap(
          function(e:Chunk<A>,s:S){
            return switch (e){
              case End(l)       : Eventual.pure(tuple2(End(l),s));
              case Val(r)       : a1.apply(tuple2(Some(r),s)).map(tuple2.bind(_,s));
              case Nil          : a1.apply(tuple2(None,s)).map(tuple2.bind(_,s));
            }
          }.tupled()
        );
      }
    );
  }
  public function change(a1:Arrow<Tuple2<A,S>,S>):Windmill<S,A>{
    return new Windmill(
      this.then(
        function(l:Chunk<A>,s:S){
          return switch (l){
            case End(l)         : Eventual.pure(tuple2(End(l),s));
            case Val(v)         : a1.apply(tuple2(v,s)).map(tuple2.bind(Val(v)));
            case Nil            : Eventual.pure(tuple2(Nil,s));
          }
        }.tupled()
      )
    );
  }
  public function attempt<B>(arw:Arrow<A,Chunk<B>>):Windmill<S,B>{
    return new Windmill(
      this.then(
        function(l:Chunk<A>,s:S){
          return switch (l){
            case End(e)           : Eventual.pure(tuple2(End(e),s));
            case Val(v)           : arw.apply(v).map(tuple2.bind(_,s));
            case Nil              : Eventual.pure(tuple2(Nil,s));
          }
        }.tupled()
      )
    );
  }
  public function recover(arw:Arrow<Fail,Chunk<A>>):Windmill<S,A>{
    return this.then(
      function(e:Chunk<A>,s:S):Eventual<Tuple2<Chunk<A>,S>>{
        return switch (e){
          case End(e)      : arw.apply(e).map(tuple2.bind(_,s));
          case Val(v)      : Eventual.pure(tuple2(Val(v),s));
          case Nil         : Eventual.pure(tuple2(Nil,s));
        }
      }.tupled()
    );
  }
  public function operate(arw:Arrow<A,Option<Fail>>):Windmill<S,A>{
    return access(
      function(e:A,s:S){
        return arw.apply(e).map(
          function(o){
            return switch (o) {
              case Some(v0) : End(v0);
              default       : Val(e);
            }
          });
      }.tupled()
    );
  }
  public function drawWith<B,C>(a:Arrow<S,Chunk<B>>,fn:A->B->C):Windmill<S,C>{
    return access(
      a.second()
      .then(
        function(l:A,v:Chunk<B>):Chunk<C>{
          return switch (v){
            case Nil      : Nil;
            case Val(v)   : Val(fn(l,v));
            case End(err) : End(err);
          }
        }.tupled()
      )
    );
  }
  public function draw<B>(a:Arrow<S,Chunk<B>>):Windmill<S,Tuple2<A,B>>{
    return drawWith(a,tuple2);
  }
  public function exchange<B>(a:Arrow<S,Chunk<B>>):Windmill<S,B>{
    return StateArrows.access(
      this,
      function(v:Chunk<A>,s:S):Eventual<Chunk<B>>{
        return a.apply(s);
      }
    );
  }
  public function edit<B>(a1:Arrow<A,B>):Windmill<S,B>{
    return new Windmill(
      this.then(
        Crank.fromArrow(a1).first()
      )
    );
  }
  public function putState(v:S):Windmill<S,A>{
    return new Windmill(
      this.then(
        Compose.pure(v).second()
      )
    );
  }
  public function state():Windmill<S,S>{
    return new Windmill(
      this.then(
        function(tp:Tuple2<Chunk<A>,S>){
          return tuple2(Val(tp.snd()),tp.snd());
        }
      )
    );
  }
  public function flatMap<B>(fn:A->Windmill<S,B>):Windmill<S,B>{
    return this.then(
      function(a:Chunk<A>,s:S){
        return switch (a){
          case Nil      : Eventual.pure(tuple2(Nil,s));
          case Val(v)   : fn(v).apply(s);
          case End(err) : Eventual.pure(tuple2(End(err),s));
        }
      }.tupled()
    );
  }
  public function withInput(?i : S, cont : Function1<Tuple2<Chunk<A>,S>,Void>):Void{
    this.withInput(i,cont);
  }
}
class Windmills{
  static public function request<S,A>(arw0:Windmill<S,A>,i:S):Eventual<Chunk<A>>{
    var evt : Eventual<Chunk<A>> = StateArrows.request(arw0,i);
    return evt;
  }
  static public function nextWith<S,A,B,C>(arw0:Windmill<S,A>,arw1:Windmill<S,B>,fn:A->B->C):Windmill<S,C>{
    return attemptNextWith(arw0,arw1,fn.then(Val));
  }
  static public function next<S,A,B>(arw0:Windmill<S,A>,arw1:Windmill<S,B>):Windmill<S,Tuple2<A,B>>{
    return nextWith(arw0,arw1,tuple2);
  }
  static public function attemptNextWith<S,A,B,C>(arw0:Windmill<S,A>,arw1:Windmill<S,B>,fn:A->B->Chunk<C>):Windmill<S,C>{
    return arw0.then(
      function(v:Chunk<A>,st:S){
        return switch (v){
          case Nil      : Eventual.pure(tuple2(Nil,st));
          case End(e)   : Eventual.pure(tuple2(End(e),st));
          case Val(v)   : 
            arw1.access(
              function(v0:B,st:S){
                return fn(v,v0);
              }
            ).apply(st);
        }
      }
    );
  }
  static public function orFail<S>(arw:Windmill<S,Bool>,err:Fail):Windmill<S,Bool>{
    return arw.attempt(
      function(b){
        return b ? Val(b) : End(err);
      }
    );
  }
  @:note("#0b1kn00b: can't use with using")
  @:note("#0b1kn00b: why not?")
  static public function toWindmill<S,A>(arw:Arrow<S,Chunk<A>>):Windmill<S,A>{
    var arw1 : Arrow<S,Tuple2<Chunk<A>,S>> 
      = function(s:S):Eventual<Tuple2<Chunk<A>,S>>{
          return arw.apply(s).map(tuple2.bind(_,s));
        };
    return arw1;
  }
  static public function breakout<S,A>(arw:Windmill<S,A>):Arrow<S,Chunk<A>>{
    return arw.then(
      function(a:Chunk<A>,s:S){
        return a;
      }.tupled()
    );
  }
  static public function crank<S,A>(arw:Windmill<S,A>):Crank<S,A>{
    return new Crank().attempt(
      breakout(arw)
    );
  }
}
class Windmills1{
  static public function orFail<A,S>(a:A->Windmill<S,Bool>,e:Fail):A->Windmill<S,Bool>{
    return a.then(
      function(x){
        return Windmills.orFail(x,e);
      }
    );
  }
}
class Windmills2{
  static public function nilFail<A,S>(arw:Windmill<S,A>,e:Fail):Windmill<S,A>{
    return arw.then(
      function(x){
        return switch (x){
          case Nil      : End(e);
          case Val(v)   : Val(v);
          case End(err) : End(err);
        };
      }.first()
    );
  }
}
class Windmills4{
   static public function toWindmill<S,A>(arw:S->Eventual<Chunk<A>>):Windmill<S,A>{
    var arw1 : Arrow<S,Tuple2<Chunk<A>,S>> 
      = function(s:S):Eventual<Tuple2<Chunk<A>,S>>{
          return arw(s).map(tuple2.bind(_,s));
        };
    return arw1;
  }
}
class Windmills3{
   static public function toWindmill<S,A>(arw:S->Chunk<A>):Windmill<S,A>{
    var arw1 : Arrow<S,Tuple2<Chunk<A>,S>> 
      = function(s:S):Tuple2<Chunk<A>,S>{
          return tuple2(arw(s),s);
        };
    return arw1;
  }
}