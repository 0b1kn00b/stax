package stx.ioc;

import stx.ioc.Inject.*;
import stx.ioc.Module;

import stx.Muster;
import stx.Muster.*;
import stx.Compare.*;
import stx.Log.*;

class IocTest extends TestCase{
  public function testIoc(u:UnitArrow):UnitArrow{
                injector().bind(M0,new M1());
    var tst1 =  inject(M0).huzzah();

    var m = new DefaultPublicModule(AnyScope);
    m.bind(M0,function() return new M2());

    var tst2 =  inject(M0).huzzah();

    return u.append([
      it('should match',eq('no wait, what?'),tst1),
      it('should match',eq('A-roo-gaah'),tst2),
    ]);
  }
  public function testIoc2(u:UnitArrow):UnitArrow{
    var m0 =    injector().inPackage(IocTest);
        m0.bind(N0,function():N0 return new N1());

    var tst0  =  
      it(
        'should return package binding',
        eq(0),
        inject(N0).query()
      );

    injector().bind(N0,function():N0 return new N());
    var tst1  = 
      it(
        'should still return package binding',
        eq(0),
        inject(N0).query()
      );
    
    var m1    = injector().inClass(IocTest);
        m1.bind(N0,function():N0 return new N2());

    var tst2  =  
      it(
        'should return class binding',
        eq(1),
        inject(N0).query()
      );
    
    var m2    =    injector().inClass(IocTest);
    var tst3  =
      it(
        'should return already constructed class module',
        eq(m2),
        m1
      );

    var tst4  = 
      it(
        'should fail to bind already bound class',
        eq(false),
        m2.bind(N0,function():N0 return new N3())
      );

    var tst5  =  
      it(
        'should continue to return class binding',
        eq(1),
        inject(N0).query()
      );


    var tst6  = 
      it(
        'should successfully unbind',
        eq(true),
        m2.unbind(N0)
      );

    var tst7 = 
      it(
        'should produce package binding',
        eq(0),
        inject(N0).query()
      );

    var tst8 = 
      it(
        'should bind',
        eq(true),
        m2.bind(N0,function():N0 return new N3())
      );

    var tst9 =
      it(
        'should produce new class binding',
        eq(2),
        inject(N0).query()
      );
    
    m2.unbind(N0);
    m0.unbind(N0);

    var tst10 = 
      it(
        'should produce global binding',
        eq(-1),
        inject(N0).query()
      );

    injector().unbind(N0);

    var tst11 = 
      it(
        'should throw an error',
        throws(),
        function(){
          inject(N0);
        }
      );
    return u.append([
      tst0,tst1,tst2,tst3,tst4,tst5,tst6,tst7,tst8,tst9,tst10,tst11
    ]);
  }
}
class M0{
  public var a : String;
  public function new(){
    a = 'a0';
  }
  public function huzzah(){
    return 'huzzah';
  }
}
class M1 extends M0{
  override public function huzzah(){
    return 'no wait, what?';
  }
}
class M2 extends M0{
  override public function huzzah(){
    return 'A-roo-gaah';
  }
}
interface N0 {
  public var b : String;
  public function query():Int;
}
class N implements N0{
  public var b : String;
  public function new(){
    this.b = "b1";
  }
  public function query(){
    return -1;
  }
}
class N1 extends N {
  override public function query(){
    return 0;
  }
}
class N2 extends N1{
  override public function query(){
    return 1;
  }
}
class N3 extends N1{
  override public function query(){
    return 2;
  }
}
