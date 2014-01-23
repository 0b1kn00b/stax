package;

import stx.utl.CompileTarget;
import Prelude;
import Stax.*;
import stx.Compare.*;
import stx.io.Log.*;

using stx.Arrays;

using stx.UnitTest;

abstract Nullish(Null<Dynamic>) from Null<Dynamic> to Null<Dynamic>{
  public function new(v){
    this = v;
  }
}
class HaxeTest extends Suite{
  /*@:note('#0b1kn00b: Would like general or operators.')
  public function testOr(u:TestCase):TestCase{
    var a = null;
    var b = "1";
    var c = "2";    
    return u;
  }*/
  public function testReflectCopy(u:TestCase):TestCase{
    var a       = new CopyTarget();
    var tsts    = [];
    try{
      var b = Reflect.copy(a);
      b.c.c = 'unk';
      b.b   = 3;
      tsts = tsts.append([
        isEqual(a.c.c,'unk'),
        isEqual(a.b,1974),
        isEqual(b.b,3)
      ]);
    }catch(e:Dynamic){ 
      if(!CompileTargets.is(Avm2())){
        throw(e);
      }else{
        tsts.add(isTrue(true));
      }
    }
    return u.append(tsts);
  }
  public function testReflectionAndTypedIntrospection(u:TestCase):TestCase{
    var a = new CopyTarget();
    var type_fields     = Type.getInstanceFields(Type.getClass(a));
    var reflect_fields  = Reflect.fields(a);
    return u;
  }
}
private class CopyTarget{
  public var a : String;
  public var b : Int;
  public var c : CopyTargetInner;
  public var f : Niladic;

  public function new(){
    a = 'something';
    b = 1974;
    c = new CopyTargetInner();
    f = noop;
  }
}
private class CopyTargetInner{
  public function new(){
    c = 'unimaginative variable names';
  }
  public var c : String;
}

