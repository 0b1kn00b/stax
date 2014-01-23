package stx.ces;

import Stax.*;
import stx.ds.LazyList;
import stx.ces.ifs.Entity in IEntity;

import stx.ces.entity.DefaultEntity;

typedef EntityType = { 
  function hasTrait(key:String):Bool;
};

abstract Entity(EntityType) from EntityType to EntityType{
  public function new(v){
    this = v;
  }
  public function hasTrait(key):Bool{
    return this.hasTrait(key);
  }
  @:from static public function fromIEntity(e:IEntity):Entity{
    var e0 : EntityType = cast e;
    return new Entity(e0);
  }
}