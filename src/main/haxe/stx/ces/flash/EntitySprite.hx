package stx.ces.flash;

using stx.Strings;
using stx.Arrays;

import Prelude;
import stx.ds.LazyList;

import stx.ces.flash.component.*;

import stx.ces.ifs.Entity;

import flash.display.Sprite;

class EntitySprite extends Sprite implements Entity{
  public function new(){
    super();
  }
  public function hasTrait(key:String):Bool{
    return ["position"].any(key.equals);
  }
  public function model<T:{name : Void -> String}>(unit:Void->T,?plus:T->T->T):Option<T>{
    plus = plus == null ? function(x,y) return y : plus;
    var mdl = unit();
    return switch (mdl.name()) {
      case "position", "size" : return Some(plus(mdl,cast this));
      default         : None;
    }
  }
}