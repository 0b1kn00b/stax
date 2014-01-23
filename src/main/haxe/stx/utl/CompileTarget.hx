package stx.utl;

import stx.Equal;

enum CompileTarget{
  Avm1;
  Avm2(?vrs:Int,?sub:String);
  Js;
  Neko;
  Php;
  Cpp;
  Java;
  Cs;
  Other;
}
class CompileTargets{
  @:noUsing static public function get():CompileTarget{
    return (
      #if flash11_3
        Avm2(11)
      #elseif flash11
        Avm2(11,'3')
      #elseif flash10
        Avm2(10)
      #elseif flash9
        Avm2(9)
      #elseif flash
        Avm1
      #elseif neko
        Neko
      #elseif php
        Php
      #elseif cpp
        Cpp
      #elseif java
        Java
      #elseif cs
        Cs
      #elseif js
        Js
      #else
        Other
      #end
    );
  }
  @:noUsing static public function is(c:CompileTarget):Bool{
    return switch (c) {
      case Avm2(vsr,sub) if (vsr == null) : stx.Enums.alike(get(),c);
      default                             : stx.Equal.getEqualFor(c)(c,get());
    }
  }
  @:noUsing static public function typed():Bool{
    return switch (get()) {
      case Avm1,Php,Cpp,Java,Cs           : true;
      case Avm2(v,_) if (v>8)             : true;
      default                             : false;
    }
  }
}