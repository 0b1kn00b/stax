package stx;

import stx.Future;
import stx.Prelude;
import stx.Tuples;

//from monax

typedef Cont = Continuations;
class Continuations{
  @:noUsing
  static public function create<R,A>(g:RC<R,A>):RC<R,A>{
    return function(f:A->R) { return g(f); }
  }
  @:noUsing
  static public function pure<A>(a:A):RC<A,A>{
    return 
      function(f:A->A){ return f(a); }
  }
  static public function apply<R,A>(cont:RC<R,A>,fn:A->R):R{
    return cont(fn);
  }
  static public function flatMap<A,B,R>(m:RC<R,A>,k:A -> RC<R,B>):RC<R,B>{
    return 
      function(cont : B -> R){
        return m(function(a){ return k(a)(cont); });
      }
  }
  static public function map<A,B,R>(m:RC<R,A>, k : A -> B):RC<R,B>{
    return 
      function(cont: B->R) {
        return m(
          function(a) {
            return cont(k(a));
          }
        );
      }
  }

  static public function cc<R,A,B>(f:(A->RC<R,B>)->RC<R,A>):RC<R,A>{
    return 
      function(k){
        return 
          f(
            function(a){
            return 
              function(x){
                return k(a);
              }
          }
          )(k);
      };
  }
  static inline public function callcc(f){
    return cc(f);
  }
  
  static public function futureOf<A>(cont:Receive<A>):Future<A>{
    var ft = Future.create();
    cont(
      function(x) ft.deliver(x)
    );
    return ft;
  }
}