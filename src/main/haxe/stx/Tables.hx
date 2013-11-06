package stx;

import haxe.ds.StringMap;

import stx.plus.Order;
import stx.plus.Equal;
import Prelude;
import stx.rtti.Field;

using stx.Iterables;
using stx.Option;
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
  static public inline function fields<T>(d: Table<T>): Iterable<Field<T>> {
    return cast Reflects.fields(d);
  }
  static public function vals<T>(d: Table<T>):Array<T>{
    return Reflect.fields(d).map(Reflects.getValue.bind(d));
  }
  
  @:doc("Returns the values of the names.")
  static public function select<T>(d: Table<T>, names: Array<String>): Array<T> {
    var result: Array<T> = [];
    
    for (field in names) {
      var value = Reflect.field(d, field);
      
      result.push(value);
    }
    
    return result;
  }
  @:doc("Report fields missing.")
  static public function missing<T>(d:Table<T>,fields:Array<String>):Option<Array<String>>{
    return fields.foldLeft(
        None,
        function(memo:Option<Array<String>>,next:String){
          var hs = Reflect.hasField(d,next);
          return switch (memo){
            case None     : hs ? None     : Some([next]);
            case Some(v)  : hs ? Some(v)  : Some(Arrays.add(v,next));
          }
        }
      );
  }
  static public function has<T>(d:Table<T>,keys:Array<String>):Bool{
    return missing(d,keys).isEmpty();
  }
  static public function only<T>(d:Table<T>,keys:Array<String>):Bool{
    var fields  = Reflect.fields(d);
        fields  = ArrayOrder.sort(fields);
    var keys0 : Array<String> = keys;
        keys0   = ArrayOrder.sort(keys0);

    return Equal.getEqualFor(fields)(fields,keys0);
  }
  @:doc("Merges the first level of object keys into a new Table, right hand override.")
  static public function merge<T>(d0:Table<T>,d1:Table<T>):Table<T>{
    var o : Table<T> = {};
    var l = fields(d0);
    var r = fields(d1);
        l.append(r).each(Reflects.setFieldTuple.bind(o));
    return o;
  }
  static public function toMap<T>(o:Table<T>):StringMap<T>{
    var map = new StringMap();
    fields(o).each(map.set.tupled());
    return map;
  }
}