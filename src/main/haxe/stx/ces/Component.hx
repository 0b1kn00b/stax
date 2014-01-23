package stx.ces;

import Type;
import Prelude;

import stx.ces.ifs.Component in IComponent;
import stx.ces.component.*;

typedef ComponentType = {  
  function model<T>(unit:Void->T):Option<T>;
  function name():String;
};
abstract Component(ComponentType) from ComponentType to ComponentType{
  public function new(v){
    this = v;
  }
  public function model<T>(unit:Void->T):Option<T>{
    return this.model(unit);
  }
  public function name(){
    return this.name();
  }
  @:from static public function fromString<T>(s:String):Component{
    var t : ComponentType = new DynamicComponent(s);
    return t;
  }
  @:from static public function fromT<T:IComponent>(v:T):Component{
    return v;
  }
}