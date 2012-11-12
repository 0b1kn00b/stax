package stx;

//from monax
typedef RC<R,A> = (A -> R) -> R

class Cont{
  static public function ret<A,R>(i:A):RC<R,A>{
    return function(cont) return cont(i);
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
}