package hx.rct;

import stx.Prelude;

import stx.utl.Selector;

enum VariableChanged<T>{
  VariableChanged(before:T,after:T);
}
class VariableReactor<T> extends DefaultReactor<VariableChanged<T>>{
  private var data : T;

  public function new(?def:T){
    super();
    this.data = def;
  }
  public function put(v:T):Void{
    var prev  = data;
    this.data = v;
    this.emit(VariableChanged(prev,data));
  }
  /**
    Do a put operation without triggering an event.
  */
  public function lay(v:T):Void{
    this.data = v;
  }
  public function get():T{
    return data;
  }
}
class VariableReactors{
  static public function to<A>(from:Reactor<A>,to:Reactor<A>):Void{
    
  }
  static public function from<A>(to:Reactor<A>,from:Reactor<A>):Void{

  }
  static public function link<A>(to:Reactor<A>,from:Reactor<A>):Void{

  }
}