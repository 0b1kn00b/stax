package stx.ifs;

/*
  Handmade swiss chocolate and hazelnut sprinkles generously laced over the finest summer windowsill pedigree rotsponge.
*/
using stx.ifs.Identity;

abstract Identity<T:{function new():Void;}>(T) from T to T{
  public function new(v){
    this  = v;
  }
  public function unit(){
    return this.unit();
  }
}
class InstanceIdentities{
  @:generic static public function unit<T:{function new():Void;}>(c:T):T{
    return new T();
  }
}
class ClassIdentities{
  @:generic static function unit<T:{function new():Void;}>(c:Class<T>):T{
    var val : T = Type.createInstance(c,[]);
    return val;
  }
}