package stx.mcr;

import stx.Muster;
import stx.Muster.*;
import stx.Log.*;

import stx.mcr.Self;

class SelfTest extends TestCase{
  public function testSelf(u:UnitArrow):UnitArrow{
    var a = new Extends2();
    $type(a.me());
    var b = new IntTest();
    $type(b.me());
    var c = new WithVl();
    $type(c.me());
    var d = new ExtendsWithVl();
    $type(d.me());
    return u;
  }
}
private class A{
  public function new(){}
}
private class B extends A{

}
class ImplementsSelf implements SelfSupport{
  var a : String;
  public function new(){}

  public function me():Self{
    return this;
  }
  public function you<A>(a:A):Self{
    return this;
  }
}
//nope
/*abstract V2(ImplementsSelf){
  public function new(){

  }
  function sum():Self{
    return this;
  }
}*/
private interface Ext extends SelfSupport{
  public function me():Self;
}
private class IntTest implements Ext{
  public function new(){}
  public function me():Self{
    return this;
  }
}
class ExtendsImplementsSelf extends ImplementsSelf{

}
class Extends2 extends ExtendsImplementsSelf{

}
class WithVl<T> implements SelfSupport{
  var v : T;
  public function new(){

  }
  public function me():Self{
    return this;
  }
}
class ExtendsWithVl<T> extends WithVl<T>{

}
class Testing{
  public function new(){

  }
  //does not compile
  /*public function me<T:Testing>():T{
    return this;
  }*/
}
class Testing1{
  public function new(){

  }
  public function me():Testing1{
    return this;
  }
}
class Testing1SubClass extends Testing1{
  //compiles when perhaps it shouldn't if the rules were consistent
  @metas('ok')
  override public function me():Testing1SubClass{
    return this;
  }
}
class Testing2{
  public function me(v:Testing2):Testing2{
    return this;
  }   
}
class Testing2SubClass extends Testing2{
  //does not compile
  /*override public function me(v:Testing2SubClass):Testing2SubClass{
    return this;
  } */
}
class Testing3{
  public function me<T:Testing3>(v:T):Testing3{
    return this;
  }
}
class Testing3SubClass extends Testing3{
  override public function me<T:Testing3>(v:T):Testing3SubClass{
    return this;
  }
}
class Testing4{
  public function new(){

  }
  public var a : Testing4;
}