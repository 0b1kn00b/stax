package stx.io.json;

import Type;

import stx.Prelude;
import stx.io.json.Transcode;
import stx.io.json.JValue;

using stx.Prelude;
using stx.Enums;
using stx.Types;
using stx.Options;

class Decomposer{
	static function _createDecomposeImpl<T>(impl : JDecomposerFunction<Dynamic>):JDecomposerFunction<Dynamic> {
		return function(v : T) {
				return 
					if (null == v) {					
						JNull; 
					}else{
						impl(v);
					}
		}
	}
	@:noUsing
  static public function getDecomposerFor<T>(v:T):JDecomposerFunction<T>{
    return getDecomposerForType(Type.typeof(v));
  }
	@:note('#0bk1kn00b: I don´t understand why TObject can´t be decomposed, so I hacked it in')
  public static function getDecomposerForType<T>(v: ValueType):JDecomposerFunction<T>{
    var data  = Transcodes.transcoders;
    var f     = Std.string(v);
    return switch (v){
      case TBool , TInt , TFloat, TObject :
        _createDecomposeImpl(data.get(f).decompose);
      case TUnknown   :
        _createDecomposeImpl(function(v) return except()("Can't decompose TUnknown: " + v));
      case TClass(c)  :
      	var cname : String = Type.getClassName(c);
      	return 
          if( Transcodes.transcoders.exists(cname)){
        	 Transcodes.transcoders.get(cname).decompose;
        	}else{
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
        			except()("Decompose function cannot be created. " + v);
        		}else{
        			fst.map(
                function(x):Transcode<Dynamic,Dynamic>{
                  return Type.createInstance(x,[]);
                }
              ).foreach(
        				function(x){
        					Transcodes.transcoders.set(cname,x);
        				}
        			).get().extract;
        		}
      	}
      case TEnum(e) :
        var ename = Type.getEnumName(e);
        if(Transcodes.transcoders.exists(ename)){
          Transcodes.transcoders.get(ename).decompose;
        }else{
          _createDecomposeImpl(
            function(v) {
               var name        = stx.io.json.types.StringJValue.decomposer()(Type.getEnumName(e));
               var constructor = stx.io.json.types.StringJValue.decomposer()(Type.enumConstructor(v));
                
               var parameters  = JArray(Type.enumParameters(v).map(function(v) { return Decomposer.getDecomposerFor(Type.typeof(v))(v); } ));
               return JArray([name, constructor, parameters]);
            }
           );
        }
      case TFunction:
        _createDecomposeImpl(function(v) {except()("Can't decompose function."); return JNull;});
      case TNull:
        cast function(v) return JNull;
      default:
        _createDecomposeImpl(function(v) {except()("Can't decompose unknown type."); return JNull;});
    }
  }
}