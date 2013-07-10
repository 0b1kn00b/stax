package stx;


using stx.Options;
using stx.Tuples;
using stx.Functions;
using stx.Compose;
using stx.Prelude;
using stx.Arrays;

import Type;

/**
  Blob defined as {} is different from Dynamic in that it does not allow closures.
*/
@:note('0b1kn00b','Does this handle reference loops, should it, could it?')
abstract Blob({}) from {} to {} {
  @:noUsing
  static public function unit():Blob{
    return new Blob({});
  }
  public function new(v){
    this = v;
  }
  public function copy(shallow: Bool = true): Blob {
    var res = {};
    copyTo(this, res, shallow);
    return res;
  }
  public function copyDeep(): Blob {
    return copy(this, false);
  }
  public function copyTo(dest: Blob, shallow: Bool = true): Blob {
    function safecopy(d: Dynamic): Dynamic
      return switch (Type.typeof(d)) {
        case TObject: copy(d, shallow);
        
        default: d;
      }
    
    for (field in Reflect.fields(this)) {
      var value = Reflect.field(this, field);
      
      Reflect.setField(dest, field, if (shallow) value else safecopy(value));
    }
    return this;
  }
  public function extendWith(src: Blob, shallow: Bool = true): Blob {
    copyTo(src, this, shallow);    
    return this;
  }
  public function copyExtendedWith(b: Blob, shallow: Bool = true): Blob {
    var res = copy(this, shallow);
    copyTo(b, res, shallow);    
    return res;
  }
  public function extendWithDeep(src: Blob): Blob {
    copyTo(src, this, false);    
    return this;
  }
  public function copyExtendedWithDeep(b: Blob): Blob {
    var res = copy(this, false);
    copyTo(b, res, false);    
    return res;
  }
  public function all(): Array<Dynamic>{
    return Reflect.fields(this).map(function(x) Reflect.field(this,x) );
  }
  public function set(k:String,v:Dynamic):Blob{
    Reflect.setField(this,k, v);
    return this;
  }
  public function with(o: Blob): Blob {
    var fields = o.extract();
    for (field in fields) {
      Reflect.setField(this, field.fst(), field.snd());
    }
    return this;
  }
  public function getO(k: String): Option<Dynamic> {
    return Opt.n(Reflect.field(this,k));
  }
  public function fields(): Array<String> {
    return Reflect.fields(this);
  }
  public function values(): Array<Dynamic> {
    return all(this).filter( function(x) return !Reflect.isFunction(x) );
  }
  public function extract(): Array<Tuple2<String, Dynamic>> {
    return Reflect.fields(this).map(function(name) return tuple2(name,Reflect.field(this, name)));
  }
  public function iterator(): Iterator<Tuple2<String,Dynamic>> {
    return extract(this).iterator();
  }
  @:from static public function fromArray(a:Array<Tuple2<String,Dynamic>>):Blob{
    return new Blob(a.foldl(
      {},
      function(init,el){
        Reflect.setField( init , el.fst(), el.snd() );
        return init;
      }
    ));
  }
}