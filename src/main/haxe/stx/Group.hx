package stx;

import stx.ds.Map;
import stx.ds.ifs.Foldable;


using Prelude;
using stx.Arrays;
using stx.Iterables;

using stx.Group;

class Group {
	
}
class IterableGroup {
	public static function groupBy<T, K>(iter: Iterable<T>, grouper: T -> K) : Map<K, Iterable<T>> { 
    return cast iter.toArray().groupBy(grouper);
  }
}
class ArrayGroup {
  public static function groupBy<T, K>(arr: Array<T>, grouper: T -> K) : Map<K, Array<T>> { 
    return arr.foldLeft(Map.create(), function(map, e) {
      var key = grouper(e);
      var result = map.getOrElse(key, function() return []);
      result.push(e);
      return map.set(key, result);
    });
  }
}
class FoldableGroup {
  public static function groupBy<C, T, K>(foldable: Foldable<C, T>, grouper: T -> K) : Map<K, C> { 
    var def = foldable.unit();
    return cast foldable.foldLeft(Map.create(), function(map, e) {
      var key = grouper(e);
      var result = map.getOrElseC(key, def);
      return map.set(key, cast result.add(e));
    });
  }
}