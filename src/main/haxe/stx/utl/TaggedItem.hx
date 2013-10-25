package stx.utl;

class TaggedItem<T,V>{
  private var __compare__         : OrderFunction<T>;
  private var __equal__           : EqualFunction<T>;
  
  public var data(default,null)   : V;
  public var tag(default,null)    : T;

  public function new(index:T,data:K,?compare:OrderFunction<T>){
    this.data         = data;
    this.index        = index;
    this.__compare__  = Order.get
  }
  public function compare(ot:IndexedItem<T>){
    return __compare__(this,ot);
  }
}