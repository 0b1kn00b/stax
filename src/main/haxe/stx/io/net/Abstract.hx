package stx;

import Stax.*;
using stx.Compose;

using stx.Chunk;

@doc("
  Represents a value that can have it's fields modified depending on context, 
  configured by using the `using` mechanism. Eg:
  ```
    static public function someval(r:Abstract):SomeType{
      return r.native().someval;
    }
    static public function getsetSomething(r:Abstract){
      return {
        get : function(){ return r.native().something; }
        set : function(v){ r.native().something = v; return r; }
      }
    }
  ```
")
abstract Abstract(Dynamic) from Dynamic{
  @:arrayAccess function getByString(str:String){
    return get(str);
  }
  @:arrayAccess function setByString(str:String,val:Dynamic){
    return set(str,val);
  }
  public function new(?v:Dynamic){
    this = v == null ? {} : v;
  }
  public function set(key:String,val:Dynamic):Abstract{
    kwv.Anys.set(this,key,val);
    return this;
  }
  public function get(key:String):Dynamic{
    var o = kwv.Anys.diveOption(key,this).fold(
      Compose.unit(),
      Compose.pure(null),
      function() return null
    );
    return o;
  }
  public function has(key:String):Bool{
    return kwv.Anys.has(this,key);
  }
  public function native():Dynamic{
    return this;
  }
}