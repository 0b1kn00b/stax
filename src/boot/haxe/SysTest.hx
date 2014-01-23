package;

import stx.ioc.Inject.*;

import hx.ifs.Scheduler;

import haxe.Timer;
import haxe.unit.TestCase;

class SysTest extends TestCase{
  public function new(){
    super();
    this.scheduler = inject(Scheduler);
  }
  var scheduler  : Scheduler;

  public function testSleep(){
    var a = Timer.stamp();
    Sys.sleep(2);
    scheduler.run();
    var b = Timer.stamp();
    assertTrue((b-a)>=2);
  }
  /*@:note("Press enter.")
  public function testReadByte(){
    var a = Sys.stdin().readByte();  
    assertEquals(13,a);
  }*/
  public function testExecutablePath(){
    
  }
}