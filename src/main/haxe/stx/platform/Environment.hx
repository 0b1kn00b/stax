package stx.platform;

import haxe.StringMap;

#if sys
class Environment{
  static public function set(key:String,val:Dynamic){

  }
  static public function get(key:String){

  }
  static public function all():StringMap<Dynamic>{

  }
}
#else if #flash
import flash.Lib;

class Environment{
  static public function set(key:String,val:Dynamic){
    Reflect.setField(current.stage.loaderInfo.parameters,key,val);
  }
  static public function get(key:String){
    return Reflect.field(current.stage.loaderInfo.parameters,key);
  }
  static public function all():StringMap<Dynamic>{
    var sm  = new StringMap();
    var v   = current.stage.loaderInfo.parameters;
    var flds = Reflect.fields(v);
    for (fld in flds){
      sm.set(fld,Reflect.field(v,fld));
    }
    return sm;
  } 
}
#else if js
class Environment{
  //js.html.sessionStorage
}