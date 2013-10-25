package kwv.rct;

import stx.Eventual;

import stx.Muster;
import Stax.*;
import stx.Muster.*;
import stx.Compare.*;
import stx.Log.*;

import kwv.rct.*;

using kwv.rct.Reactors;

class VariableReactorTest extends TestCase{
  public function testVariableReactor(u:UnitArrow):UnitArrow{
    var ft  = Eventual.unit();
    var a   = new VariableReactor(1);
    a.all(
      function(x){
        switch (x) {
          case VariableChanged(bf,af) :
            ft.deliver(
              [
                  it(
                  'should be `1` before',
                  eq(1),
                  bf
                ),
                it('should be `2` after',
                    eq(2),
                    af
                )
              ]
            );
        }
      }
    );
    a.put(2);

    return u.then(MusterEventuals0.flatten(ft));
  }
}

    