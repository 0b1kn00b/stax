package stx;

import stx.Tuples.*;

using stx.Tuples;
using stx.Functions;
using stx.Compose;
using stx.Prelude;
using stx.Arrays;

import Type;

typedef Object = {};

/**
  Object defined as {} is different from Dynamic in that it does not allow closures.
*/
@:note('0b1kn00b','reference loops')
class Objects {
  @:noUsing
  @:note('#0b1kn00b: could throw an error')
  static public function asObject(d:Dynamic):Object{
    return cast d;
  }
  @:noUsing
  static public function create():Object{
    return {};
  }
  inline static public function copyDeep(d: Object): Object return 
    copy(d, false);
  
  /**
    Generic copy function
    @param d
    @param shallow   specifies depth of copy
    @return
   */ 
  static public function copy(d: Object, shallow: Bool = true): Object {
    var res = { };
    copyTo(d, res, shallow);
    return res;
  }

  inline static public function copyTypedDeep<T>(d: T): T return 
    cast copy(untyped d, false);
    
  inline static public function copyTyped<T>(d: T, shallow: Bool = true): T return
    cast copy(untyped d, shallow);
  
  static public function copyTo(src: Object, dest: Object, shallow: Bool = true): Object {
    function safecopy(d: Dynamic): Dynamic
      return switch (Type.typeof(d)) {
        case TObject: copy(d, shallow);
        
        default: d;
      }
    
    for (field in Reflect.fields(src)) {
      var value = Reflect.field(src, field);
      
      Reflect.setField(dest, field, if (shallow) value else safecopy(value));
    }
    return src;
  }
  
  static public function extendWith(dest: Object, src: Object, shallow: Bool = true): Object {
    copyTo(src, dest, shallow);    
    return dest;
  }

  static public function copyExtendedWith(a: Object, b: Object, shallow: Bool = true): Object {
    var res = copy(a, shallow);
    copyTo(b, res, shallow);    
    return res;
  }

  static public function extendWithDeep(dest: Object, src: Object): Object {
    copyTo(src, dest, false);    
    return dest;
  }

  static public function copyExtendedWithDeep(a: Object, b: Object): Object {
    var res = copy(a, false);
    copyTo(b, res, false);    
    return res;
  }
  
  static public function fields(d: Object): Array<String> {
    return Reflect.fields(d);
  }
  
  static public function mapValues<T, S>(d: Dynamic<T>, f: T -> S): Dynamic<S> {
    return setAll({}, Reflect.fields(d).map(function(name) {
      return tuple2(name,f(Reflect.field(d, name)));
    }));
  }
  
  static public function set<T>(d: Dynamic<T>, k: String, v: T): Dynamic<T> {
    Reflect.setField(d, k, v);
    
    return d;
  }
  
  static public function setAny(d: Object, k: String, v: Dynamic): Object {
    Reflect.setField(d, k, v);
    
    return d;
  }
  
  static public function setAll<T>(d: Dynamic<T>, fields: Iterable<Tuple2<String, T>>): Dynamic<T> {
    for (field in fields) {
      Reflect.setField(d, field.fst(), field.snd());
    }
    
    return d;
  }
  
  static public function replaceAll<T>(d1: Dynamic<T>, d2: Dynamic<T>, def: T): Object {
    var names: Array<String> = Reflect.fields(d2);
    
    var oldValues = extractValues(d1, names, def);
    
    extendWith(cast d1, cast d2);
    
    return names.zip(oldValues).foldl({}, function(o, t) {
      Reflect.setField(o, t.fst(), t.snd());
      
      return o;
    });
  }
  
  static public function setAllAny(d: Object, fields: Iterable<Tuple2<String, Dynamic>>): Object {
    for (field in fields) {
      Reflect.setField(d, field.fst(), field.snd());
    }
    
    return d;
  }
  
  static public function replaceAllAny(d1: Object, d2: Object, def: Dynamic): Object {
    var names: Array<String> = Reflect.fields(d2);
    
    var oldValues = extractValues(d1, names, def);
    
    extendWith(d1, d2);
    
    return names.zip(oldValues).foldl({}, function(o, t) {
      Reflect.setField(o, t.fst(), t.snd());
      
      return o;
    });
  }
  
  static public function getO<T>(d: Dynamic<T>, k: String): Option<T> {
    return if (Reflect.hasField(d, k)) Some(Reflect.field(d, k)); else None;
  }
  
  static public function getAnyO(d: Object, k: String): Option<Dynamic> {
    return if (Reflect.hasField(d, k)) Some(Reflect.field(d, k)); else None;
  }
  
  static public function extractFieldValues(obj: Dynamic, field: String): Array<Dynamic> {
    return Reflect.fields(obj).foldl([], function(a, fieldName): Array<Dynamic> {
      var value = Reflect.field(obj, fieldName);
      return if (fieldName == field) {
        a.append(value);
      } else if (Type.typeof(value) == TObject) {
        a.concat(Objects.extractFieldValues(value, field));
      } else a;
    });
  }
  
  static public function extractAll<T>(d: Dynamic<T>): Array<Tuple2<String, T>> {
    return Reflect.fields(d).map(function(name) return tuple2(name,Reflect.field(d, name)));
  }
  static public function extractObject<A>(d:Dynamic<A>,fieldnames:Array<String>):Array<Tuple2<String, Dynamic>>{
    return 
      extractAll(d)
        .filter(
          Predicates.isOneOf(fieldnames).first().fstOf()
        );
  }
  static public function extractAllAny(d: Object): Array < Tuple2 < String, Dynamic >> {
    return extractAll(d);
  }
  
  static public function extractValuesAny(d: Object, names: Iterable<String>, def: Dynamic): Array<Dynamic> {
    return extractValues(d, names, def);
  }
  static public function extractValues<T>(d: Dynamic<T>, names: Iterable<String>, def: T): Array<T> {
    var result: Array<T> = [];
    
    for (field in names) {
      var value = Reflect.field(d, field);
      
      result.push(if (value != null) cast value else def);
    }
    
    return result;
  }
  
  static public function iterator(d: Object): Iterator<String> {
    return Reflect.fields(d).iterator();
  }
  static public function toObject<A>(a:Array<Tuple2<String,A>>):Object{
    return a.foldl(
      {},
      function(init,el){
        Reflect.setField( init , el.fst(), el.snd() );
        return init;
      }
    );
  }
  static public function hasFields(d:Object,fields:Array<String>):Bool{
    var vals   = extractAllAny(d);
    var names  = vals.map( T2s.fst );

    return 
      fields.forAll(
        function(x){
          return names.forAny( function(y) return x == y );
        }
      );
  }
  static public function hasAllFields(d:Object,fields:Array<String>):Option<String>{
    return 
      fields.foldl(
        None,
        function(memo,next){
          return switch (memo){
            case None     : Reflect.hasField(d,next) ? None : Some(next) ;
            case Some(v)  : Some(v);
          }
        }
      );
  }
  static public function definedFields(d:Object,fields:Array<String>):Bool{
    return 
      extractValues(d,fields,null)
      .forAll( function(x) return x != null );
  }
}