package stx;

import stx.Fail;
import Stax.*;
import haxe.ds.StringMap;

using stx.Compose;
using stx.Tuples;
using stx.Iterators;
using stx.Prelude;
using stx.Options;

@:note('#0b1kn00b: bubcus')
class Maps {
	/**
		Creates an Iterable of Tuple2<Key,Value> from a Map.
	*/
	/*static public function toIterable<K,V>(h:Map<K,V>):Iterable<Tuple2<K,V>>{
		return h.keys().toIterable().map(
				function(x:K){
					var val : V = h.get(x); 
					return tuple2(x, val);
				}
			);
	}*/
	/*static public function toArray<K,V>(h:Map<K,V>):Array<Tuple2<K,V>>{
		return h.keys().toArray().map(
			function(k){
				return tuple2(k,h.get(k));
			}
		);
	}*/
	/**
		Returns whether all the keys are in the hash
	*/
	/*static public inline function hasAllKeys<K,V>(h:Map<K,V>, keys:Array<K>):Bool {
		var ok = true;
		
		for (val in keys) {
			if ( !h.exists(val) ) {
				ok = false;
				break;
			}
		}
		return ok;
	}*/
	/**
		Returns whether any of the keys are in the Map
	*/
	/*
	static public inline function hasAnyKey<K,V>(h:Map<K,V>, entries:Array<K>):Bool {
		for (val in entries) {
			if ( h.exists(val) ) {
				return true;
			}
		}
		return false;		
	}

	static public inline function getOption<K,V>(map:Map<K,V>,key:K):Option<V>{
	 	return Options.create(map.get(key));
	}
	static public function foreach<K,V>(map0:Map<K,V>,fn:K->V->Void):Map<K,V>{
		toArray(map0).foreach(fn.tupled());
		return map0;
	}
	@:generic static public function mapKeys<K,V,K0>(map0:Map<K,V>,fn:K->K0):Map<K0,V>{
		throw fail(AbstractMethodFail());
		return null;
	}
	@:generic static public function mapVals<K,V,V0>(map0:Map<K,V>,fn:V->V0):Map<K,V0>{
		throw fail(AbstractMethodFail());
		return null;
	}
	@:generic static public function merge<K,V>(map0:Map<K,V>,map1:Map<K,V>):Map<K,V>{
		throw fail(AbstractMethodFail());
		return null;
	}*/
}
class StringMaps{
	/*
	@:non_destructive
	static public function merge<K,V>(map0:Map<String,V>,map1:Map<String,V>):Map<String,V>{
		var map2 : Map<String,V> = new Map();
		Maps.toArray(map0).foreach(
			map2.set.tupled()
		);
		Maps.toArray(map1).foreach(
			map2.set.tupled()
		);
		return map2;
	}
	static public function mapKeys<V,K0>(map0:Map<String,V>,fn:String->K0):Map<K0,V>{
		var map1 = new Map<K0,V>();
		Maps.foreach(map0,
			function(k,v){
				map1.set(fn(k),v);
			}
		);
		return map1;
	}
	static public function mapVals<V,V0>(map0:Map<String,V>,fn:V->V0):Map<String,V0>{
		var map1 = new Map<String,V0>();
		Maps.foreach(map0,
			function(k,v){
				map1.set(k,fn(v));
			}
		);
		return map1;
	}*/
}
/*class IntMaps{
	static public function merge<K,V>(map0:Map<Int,V>,map1:Map<Int,V>):Map<Int,V>{
		var map2 : Map<Int,V> = new Map();
		Maps.toArray(map0).foreach(
			map2.set.tupled()
		);
		Maps.toArray(map1).foreach(
			map2.set.tupled()
		);
		return map2;
	}
}
class EnumValueMaps{
	static public function merge<K,V>(map0:Map<EnumValue,V>,map1:Map<EnumValue,V>):Map<EnumValue,V>{
		var map2 : Map<EnumValue,V> = new Map();
		Maps.toArray(map0).foreach(
			map2.set.tupled()
		);
		Maps.toArray(map1).foreach(
			map2.set.tupled()
		);
		return map2;
	}
}
class ObjectMaps{
	static public function merge<K,V>(map0:Map<{},V>,map1:Map<{},V>):Map<{},V>{
		var map2 : Map<{},V> = new Map();
		Maps.toArray(map0).foreach(
			map2.set.tupled()
		);
		Maps.toArray(map1).foreach(
			map2.set.tupled()
		);
		return map2;
	}	
}*/