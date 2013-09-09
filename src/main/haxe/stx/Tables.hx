package stx;

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
    var r = fields(d0);
        l.append(r).foreach(Reflects.setFieldTuple.bind(o));
    return o;
  }
}