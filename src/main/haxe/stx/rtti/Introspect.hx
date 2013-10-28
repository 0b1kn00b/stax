package stx.rtti;

using stx.Tuples;
using stx.Options;

using Type;

import stx.rtti.*;  

using stx.rtti.RTypes;

@doc("
  calling introspect on any subclass produces the `RClass` for this Type.
")
@:rtti @:keepSub class Introspect{
  public function new(){}

  public function introspect():RClass<Dynamic>{
    var rtype : RType<Dynamic> = cast new RType(tuple2(this,Type.getClass(this).typetree().get()));
    return rtype.getClass().get();
  }
}
class Introspects{
  
}