package stx.async;

import Prelude;
import stx.async.ifs.Dissolvable in IDissolvable;
import stx.async.dissolvable.*;

abstract Dissolvable(IDissolvable) from IDissolvable to IDissolvable{
  @:noUsing static public function unit():Dissolvable{
    return new NullDissolvable();
  }
  public function new(v){
    this = v;
  }
  public function dissolve(){
    this.dissolve();
  }
  /*@:from static public function fromNiladic(d:Niladic):Dissolvable{
    return new AnonymousDissolvable(d);
  }*/
  @:to public function toFunction():Niladic{
    return this.dissolve;
  }
  public var dissolved(get,never) : Bool;
  
  private function get_dissolved(){
    return this.dissolved;
  }
}
class Dissolvables{
  static public function dissolve(d:Dissolvable):Void{
    d.dissolve();
  }
}