package stx;

import haxe.ds.StringMap;

import stx.plus.Order;
import stx.plus.Equal;
import stx.Prelude;

using stx.Iterables;
using stx.Arrays;
using stx.Options;
using stx.Compose;
using stx.Tuples;

typedef Table<T> = Dynamic<T>;

class Tables{
  //to make sense, this needs to use clone.
  /*static public function map<T, S>(d: Table<T>, f: T -> S): Table<S> {
    return setAll({}, Reflect.fields(d).map(function(name) {
      return tuple2(name,f(Reflect.field(d, name)));
    }));
  }*/
  static public function fields<T>(d: Table<T>): Array<KV<T>> {
    var keys = Reflect.fields(d);
    return keys.zip(keys).map(Reflect.field.bind(d).second());
  }
  static public function vals<T>(d: Table<T>):Array<T>{
    return Reflect.fields(d).map(Reflects.getValue.bind(d));
  }
  /**
    Returns the values of the names
  */
  static public function select<T>(d: Table<T>, names: Many<String>): Array<T> {
    var result: Array<T> = [];
    
    for (field in names) {
      var value = Reflect.field(d, field);
      
      result.push(value);
    }
    
    return result;
  }
  /**
    Report fields missing.
  */
  static public function missing<T>(d:Table<T>,fields:Many<String>):Option<Array<String>>{
    return fields.foldl(
        None,
        function(memo:Option<Array<String>>,next:String){
          var hs = Reflect.hasField(d,next);
          return switch (memo){
            case None     : hs ? None     : Some([next]);
            case Some(v)  : hs ? Some(v)  : Some(v.add(next));
          }
        }
      );
  }
  static public function has<T>(d:Table<T>,keys:Many<String>):Bool{
    return missing(d,keys).isEmpty();
  }
  static public function only<T>(d:Table<T>,keys:Many<String>):Bool{
    var fields  = Reflect.fields(d);
        fields  = ArrayOrder.sort(fields);
    var keys0 : Array<String> = keys;
        keys0   = ArrayOrder.sort(keys0);

    return Equal.getEqualFor(fields)(fields,keys0);
  }
  static public function getOption<T>(d: Table<T>, k: String): Option<T> {
    return if (Reflect.hasField(d, k)) Some(Reflect.field(d, k)); else None;
  }
  static public function replace<T>(d: Table<T>, fields: Many<KV<T>>): Table<T> {
    for (field in fields) {
      Reflect.setField(d, field.fst(), field.snd());
    }
    return d;
  }
  /**
    Merges the first level of object keys into a new Table, right hand override.
  */
  @:non_destructive
  static public function merge<T>(d0:Table<T>,d1:Table<T>):Table<T>{
    var o : Table<T> = {};
    var l = fields(d0);
    var r = fields(d1);
        l.append(r).foreach(Reflects.setFieldTuple.bind(o));
    return o;
  }
  static public function toMap<T>(o:Table<T>):StringMap<T>{
    var map = new StringMap();
    fields(o).foreach(map.set.tupled());
    return map;
  }
}