package hx.sch;

import Stax.*;
import stx.Compare.*;
import stx.Log.*;
import stx.Eventual;

using stx.UnitTest;

import hx.sch.Task;
import stx.Time.*;

class TaskTest extends TestCase{
  public function testTask(u:UnitArrow):UnitArrow{
    var evt = new Eventual();
    var a = new Task(
      function(){
        evt.deliver(isTrue(true));
      },
      second(3)
    );
    a.start();
    return u.add(evt);
  }
}

