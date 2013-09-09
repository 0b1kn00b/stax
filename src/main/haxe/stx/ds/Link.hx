package stx.ds;

class Link<C,P>{
  public function new(c:C,?p:P){
    this.current  = c;
    this.previous = p;
  }
  public function then<N>(n:N):Link<N,Link<C,P>>{
    return new Link(n,this);
  }
  public function back():P{
    return this.previous;
  }
  public function isRoot():Bool{
    return previous == null;
  }
  public var current(default,null)  : C;
  public var previous(default,null) : P;
}
class FunctionLink<A,B,P> extends Link<A->B,P>{
  
}
class FunctionLinks{
  static public function map<A,B,C,P>(lnk:FunctionLink<A,B,P>,fn:B->C):FunctionLink<B,C,FunctionLink<A,B,P>>{
    return new FunctionLink(fn,lnk);
  }
}