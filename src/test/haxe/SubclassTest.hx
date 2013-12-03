using stx.UnitTest;
import stx.Compare.*;
import stx.Log.*;

/**
  Proves that subclasses can specify type for a Dynamic parameter found in the superclass
*/
class SubclassTest extends Suite{
  public function testSubclass(u:TestCase):TestCase{
    var c = new SomethingSomethingSomething();
    return u.add(it('should compile',always()));
  }
}
private class Something{
  public function new(){

  }
  public function fn(v:Dynamic):Void{

  }
}
private class SomethingSomething<T> extends Something{
  override public function fn(v:T):Void{

  }
}
private class SomethingSomethingSomething extends Something{
  override public function fn(v:Int):Void{

  }
}
private class S4 extends SomethingSomethingSomething{
  override public function fn(v:Float):Void{

  }
}
    