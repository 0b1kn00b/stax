package stx.ds;

using stx.Arrays;

enum LispListType<T>{
  LVal(x:T);
  LSub(xs:Array<LispList<T>>);
}
abstract LispList<T>(LispListType<T>) from LispListType<T> to LispListType<T>{
  public function new(v){ 
    this = v;
  }
  //@:from static public function 
}
class LispLists{
  static public function pure<A>(v:A):LispListType<A>{
    return LVal(v);
  }
  static public function cons<A>(l:LispListType<A>,v:LispListType<A>):LispListType<A>{
    return switch (l) {
      case LVal(x) : 
    }
  }
  static public function foreachD<A>(ls:LispListType<A>,fn:A->Int->Void):LispListType<A>{
    function step (ls:LispListType<A>,fn:A->Int->Void,n:Int){
      switch (ls) {
        case LVal(x)    : fn(x,n);
        case LSub(xs)   : xs.foreach(step.bind(_,fn,n++));  
      }
    }
    step(ls,fn,-1);
    return ls;
  }
}