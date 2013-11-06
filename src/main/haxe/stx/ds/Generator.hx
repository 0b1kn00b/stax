package stx.ds;

import Prelude;
using stx.Option;

@doc("
  An iterable based on values accumulated on a stack by calling a function.
  When the function returns None, the iteration is considered complete.

  Each successive value is pushed onto a stack.
")
class Generator<T>{
  public static function create(fn,stack){
    return new Generator(fn,stack);
  }
  public function new(f:Void -> Option<T>,stack:Array<Option<T>>){
    this.fn       = 
      function(i:Int){
        var o = 
          if (stack[i] == null){
             stack[i] = f();
          }else{
            stack[i];
          }
        return o;
      };
    this.index    = 0;
  }
  private var fn    : Int->Option<T>;
  private var index : Int;

  public function next():T{
    var o =  fn(index).get();
    index++;
    return o;
  }
  public function hasNext():Bool{
    var o = switch (fn(index)) {
      case Some(_)  : true;
      case None     : false;
    }
    return o;
  }
  public function iterator(){
    return 
    {
      next      : next,
      hasNext   : hasNext
    }
  }
  @doc("Creates an Iterable by calling fn until it returns None, caching the results.")
  static public function yield<A>(fn : Void -> Option<A>):Iterable<A>{
    var stack = [];    
    return cast {
      iterator : function() return Generator.create(cast fn,stack).iterator()
    }
  }
}