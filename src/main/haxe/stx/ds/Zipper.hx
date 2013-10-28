package stx.ds;

using Lambda;

enum ZipperType<R,I,O,P>{
  Zipped(root:R,current:I->O,rest:P);
}
@doc("
  Typed navigation of arbitrary structures, calling `dn` with a function produces a Zipper holding a new value,
  calling `up` produces a Zipper holding the previous value. All historical type information is maintained in the 
  type annotation `<P>` for each step. Immutable structure, supports pattern-matching.
")
abstract Zipper<R,I,O,P>(ZipperType<R,I,O,P>) from ZipperType<R,I,O,P> to ZipperType<R,I,O,P>{
  @:noUsing static public function pure<R,P>(v:R):Zipper<R,R,R,P>{
    return new Zipper(Zipped(v,function(r:R) return r,null));
  }
  @:noUsing static public function create<R,P>(v:R):Zipper<R,R,R,P>{
    return pure(v);
  }
  public function new(v){
    this = v;
  }
  public function dn<Q>(fn:O->Q):Zipper<R,O,Q,Zipper<R,I,O,P>>{
    return switch(this){
      case Zipped(root,fn0,_) : new Zipper(Zipped(root,fn,this));
    }
  }
  public var root(get,never):R;
  private function get_root():R{
    return switch (this) {
      case Zipped(rt,_,_) : rt;
    }
  }
  public var current(get,never):I->O;
  private function get_current():I->O{
    return switch (this) {
      case Zipped(_,fn,_)   : fn;
    }
  }
  public function up():P{
    return switch (this) {
      case Zipped(_,_,rest) : rest;
    }
  }
  @:bug("#0b1kn00b: cast throws an error in Js.")
  public function value():O{
    var l     : Dynamic                                          = up();
    var stack : Array<Zipper<Dynamic,Dynamic,Dynamic,Dynamic> >  = [this];
    while(l!=null){
      stack.push(l);
      l = l.previous;
    }
    stack.reverse(); 
    var out     = stack.fold(
      function(next:Zipper<Dynamic,Dynamic,Dynamic,Dynamic>,memo:Dynamic):Dynamic{
        var o : Dynamic = next.current(memo);
        return o;
      }
    ,root);
    return untyped out;
  }
}