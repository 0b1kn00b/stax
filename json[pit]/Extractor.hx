package stx.io.json;

import Type;

import stx.Prelude;
import stx.io.json.Transcode;

using stx.Prelude;
using stx.Anys;
using stx.Enums;
using stx.Types;
using stx.Options;

using stx.io.json.JValue;


class Extractor{
  public static function extractFieldValue<T>(j: JValue, n: String, e: JExtractorFunction<T>, def: JValue) {
    var fieldValue = j.getOrElse(n, def.toThunk());

    try {
      return e(fieldValue);
    }
    catch (err: Dynamic) {
      return e(def);
    }
  }
  static function _createExtractorImpl<T>(impl : JExtractorFunction<Dynamic>) return function(v : JValue) if(null == v) return null else return impl(v)

  @:noUsing
  static public function getExtractorFor<T>(v:T):JExtractorFunction<T>{
    return getExtractorForType(Type.typeof(v));
  }
  static public function getExtractorForType<T>(valueType: ValueType, ?args: Array<Dynamic>): JExtractorFunction<T> {
    var data  = Transcodes.transcoders;
    var f     = Std.string(valueType);

    return switch (valueType){
      case TBool , TInt , TFloat, TObject :
        _createExtractorImpl(data.get(f).extract);
      case TUnknown:
        _createExtractorImpl(function(v) return except()("Can't extract TUnknown: " + v));
      case TClass(c):
        var cname = Type.getClassName(c);
        var fst = stx.Types.resolveClass('stx.io.json.types.' + cname);
          while(None.alike(fst)){
            var tmp = c.getSuperClass();
            if(None.alike(tmp)){
              break;
            }else{
              fst = stx.Types.resolveClass('stx.io.json.types' + tmp.map( Type.getClassName ).get() );
            }
          }
          if( None.alike(fst) ){
            except()("Extract function cannot be created. " + valueType);
          }else{
            fst
              .map(
                function(x):Transcode<T,Dynamic>{
                  return Type.createInstance(x,[]);
                }
              ).foreach(
                function(x){
                  Transcodes.transcoders.set(cname,x);
                }
            ).get().extract;
          }
      case TEnum(e)         :
        var ename = Type.getEnumName(e);
        if(Transcodes.transcoders.exists(ename)){
          Transcodes.transcoders.get(ename).extract;
        }else{
          _createExtractorImpl(function(v){
              switch(v){
                case JArray(arr): {
                  var name        = stx.io.json.types.StringJValue.extractor()(arr[0]);
                  var constructor = stx.io.json.types.StringJValue.extractor()(arr[1]);
                  var parameters  = switch (arr[2]){
                      case JArray(a):
                        if (args == null)
                          args = [];
                        Arrays.zip(a, args).map(function(t){return t._2(t._1);});
                      default: except()("Expected JArray but was: " + v);
                    }
                  return Type.createEnum(Type.resolveEnum(name), constructor, parameters);
                };
                default: except()("Expected JArray but was: " + v); return null;
              }
           });
        }
      case TFunction:
        _createExtractorImpl(function(v) {except()("Can't extract function."); return JNull;});
      case TNull:
        function(v) return null;
      default:
        _createExtractorImpl(function(v) {except()("Can't extract unknown type."); return JNull;});
    }
  }
}