package stx.ifs;

using stx.ifs.Pure;
using stx.ifs.Identity;

typedef PureType<T> = {
  function pure<A>(v:A) : T;
}
abstract Pure<S,T:{function new(?v:S):Void;}>(T) from T to T{
  public function new(v){
    this  = v;
  }
  public function pure(v:S):T{
    return this.pure(v);
  }
}
class InstancePure{
  @:generic static public function pure<S,T:{function new(?v:S):Void;}>(c:T,v:S):T{
    return new T(v);
  }
}
class ClassPure{
  @:generic static function pure<S,T:{function new(?v:S):Void;}>(c:Class<T>,v:S):T{
    return new T(v);
  }
  @:note('#0b1kn00b: A Dynamic v gets typed to first input, a Typed one cannot be found')
  /*@:generic static function unit<S,T:{function new(?v:S):Void;}>(c:Class<T>):T{
    return Type.createInstance(c,[]);
  }*/
}