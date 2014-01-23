package stx.ces;

import Prelude;
import Stax.*;
import stx.UnitTest;

import stx.ds.LazyList;
import stx.ces.CES.*;


import stx.ces.Entity;
import stx.ces.Component;

import stx.ces.ifs.Behaviour;
import stx.ces.ifs.System;

#if flash9
 import stx.ces.flash.EntitySprite;
 import stx.ces.flash.component.Position;
#end
class CESTest extends Suite{
  public function testBoot(u:TestCase):TestCase{
    return u.add(isTrue(true));
  }
  #if flash9
  public function testEntitySprite(){
    var es = new EntitySprite();
    var ot = es.model(Positions.unit);
  }
  #end
}
private typedef RenderType = {
  >ComponentType,
  function render():Void;
}