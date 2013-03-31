package stx.plus;

using stx.Tuples;

using stx.Prelude;
using stx.Objects;
using stx.plus.Order;

class Meta {
	@:stx_deprecate('0b1kn00b','thx')
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
	@:stx_deprecate('0b1kn00b','thx')
  public static function _fieldsWithMeta(c : Class<Dynamic>, name : String) {   
    var i = 0;   
    return Type.getInstanceFields(c).map(function(v){ 
      var fieldMeta = _getMetaDataField(c, v);     
      var inc : Bool = (fieldMeta == null || !Reflect.hasField(fieldMeta, name) || Reflect.field(fieldMeta, name)); 
      return Tuples.t3(v, inc, if(fieldMeta != null && Reflect.hasField(fieldMeta, "index")) Reflect.field(fieldMeta, "index"); else i++);                
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
	
}