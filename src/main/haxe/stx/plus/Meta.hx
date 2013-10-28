package stx.plus;

import haxe.ds.StringMap;

import Stax.*;
import stx.Tuples;

using stx.Tuples;

using stx.Maps;
using stx.Option;
using stx.Prelude;
using stx.Objects;
using stx.plus.Order;
using stx.Reflects;

import haxe.rtti.Meta in HaxeMeta;

class Meta {
	public static function _hasMetaDataClass(c : Class<Dynamic>) {
    var m = haxe.rtti.Meta.getType(c); 
    return null != m && Reflect.hasField(m, "DataClass");
  }
  public static function _getMetaDataField(c : Class<Dynamic>, f : String) {
    var m = haxe.rtti.Meta.getFields(c);  
    if(null == m || !Reflect.hasField(m, f)) 
      return null;
    var fm = Reflect.field(m, f);
    if(!Reflect.hasField(fm, "DataField"))
      return null;
    return cast(Reflect.field(fm, "DataField"),Array<Dynamic>).copy().pop();
  }              
  public static function _fieldsWithMeta(c : Class<Dynamic>, name : String) {   
    var i = 0;   
    return Type.getInstanceFields(c).map(function(v){ 
      var fieldMeta = _getMetaDataField(c, v);     
      var inc : Bool = (fieldMeta == null || !Reflect.hasField(fieldMeta, name) || Reflect.field(fieldMeta, name)); 
      return tuple3(v, inc, if(fieldMeta != null && Reflect.hasField(fieldMeta, "index")) Reflect.field(fieldMeta, "index"); else i++);                
    }).filter(function(l) {
      return l.snd();
    }).sortWith(function(a, b) {
      var c = a.thd() - b.thd();
      if(c != 0)
        return c;
      return Strings.compare(a.fst(), b.fst());
    }).map(function(v) {
      return v.fst();
    });
  }	
/*  @:noUsing static public function metadata<T>(v:T):MetaObjectContainer{
    return Maps.merge(
      Reflects.fields(HaxeMeta.getStatics(v)).toMap(),
      Reflects.fields(HaxeMeta.getFields(v)).toMap()
    ).mapVals(
      function(v:Table<Array<Dynamic>>):StringMap<Array<Dynamic>>{
        var o : StringMap<Array<Dynamic>> = cast Tables.toMap(v);
        return o;
      }
    );
  }*/
}
typedef MetaObjectContainer = Map<String,MetaObject>;
typedef MetaObject          = StringMap<Array<Dynamic>>;
class ClassMeta{
  static public function metadata(k:Kind):MetaObject{
    return null;
    /*return switch (k) {
      case KClass(v,_), KEnum(v)     : HaxeMeta.getType(v).fields().toMap();
      default                        : new StringMap();
    }*/
  }
}