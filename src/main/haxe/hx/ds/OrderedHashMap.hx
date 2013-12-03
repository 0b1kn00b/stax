package hx.ds;

import Stax.*;
import stx.Compare.*;

import stx.plus.Show;
import stx.plus.Equal;
using stx.plus.Order;

import stx.Tuples;

using stx.Compose;
using stx.Functions;
using Prelude;
using stx.Bools;
using Prelude;
using stx.Iterables;
using stx.Arrays;
using stx.Option;
using stx.Tuples;
using stx.Strings;


@:stability(1)
@:note('#0b1kn00b: How to clone this and maintain equalities?')
class OrderedHashMap<V>{
	private var __key_sort__ 	: Ord<Int>;
	private var __val_sort__ 	: Ord<V>;
	
	private var __val_equal__ : Eq<V>;
	public var impl 					: Array<Tuple2<Int,V>>;
	public function new(){
		impl = [];
	}
	public function set(key:Int,val:V){
		var tp = tuple2(key,val);
		lookup(key)
			.flatMap(
				function(t){
					return impl.findIndexOf(t);
				}
			).each(
				function(idx){
					this.impl = impl.set(idx,tp);
				}	
			).isEmpty()
			 .ifTrue(
			 		function(){
			 			impl.push(tp);
			 			return null;
			 		}
			 	);
	}
	public function has(key:Int){
		return lookup(key).isDefined();
	}
	public function at(i:Int):V{
		return option(impl[i]).map(Tuples2.snd).valOrUse(null);
	}
	public function get(key:Int):V{
		return lookup(key).map(Tuples2.snd).valOrUse(null);
	}
	public function del(key:Int){
		lookup(key)
		 .each(
		 		function(x){
		 			impl.remove(x);
		 		}
		 	);
	}
	public function rem(v:V){
		nl().apply(__val_equal__) ? (__val_equal__ = Equal.getEqualFor(v)) : __val_equal__;
		var val = impl.search(
			function(l:Int,r:V){
				return __val_equal__(v,r);
			}.tupled()
		);
		return impl.remove(val.valOrUse(null));
	}
	public function sort(){
		impl = ArrayOrder.sort(impl);
	}
	public function sortWith(fn:Ord<Tuple2<Int,V>>){
		impl = impl.sortWith(fn);
	}
	public function sortOnKey(){
		var _k = function(x,y) return nl().apply(__key_sort__) ? (__key_sort__ = Order.getOrderFor(x))(x,y) : __key_sort__(x,y);
		impl = ArrayOrder.sortWith(impl,
			function(x:Tuple2<Int,V>,y:Tuple2<Int,V>){
				return _k(x.fst(),y.fst());
			}
		);
	}
	public function sortOnKeyWith(fn:Int->Int->Int){
		impl = ArrayOrder.sortWith(impl,
			function(x:Tuple2<Int,V>,y:Tuple2<Int,V>){
				return fn(x.fst(),y.fst());
			}
		);
	}
	public function sortOnVal(){
		var _v = function(x,y) return nl().apply(__val_sort__) ? (__val_sort__= Order.getOrderFor(x))(x,y) : __val_sort__(x,y);
		impl = ArrayOrder.sortWith(impl,
			function(x:Tuple2<Int,V>,y:Tuple2<Int,V>){
				return _v(x.snd(),y.snd());
			}
		);
	}
	public function sortOnValWith(fn:V->V->Int){
		impl = ArrayOrder.sortWith(impl,
			function(x:Tuple2<Int,V>,y:Tuple2<Int,V>){
				return fn(x.snd(),y.snd());
			}
		);
	}
	public function iterator(){
		return impl.iterator();
	}
	public function vals():Iterator<V>{
		return impl.map(Tuples2.snd).iterator();
	}
	private function lookup(key:Int):Option<Tuple2<Int,V>>{
		return impl.search(function(t){ return t.fst() == key; });
	}
	public function size(){
		return impl.length;
	}
	public function find(v:V):Option<Tuple2<Int,V>>{
		var eq = eq(v);
		return this.search(
			function(x){
				return eq.apply(x);
			}
		);
	}
	public function search(fn:V->Bool):Option<Tuple2<Int,V>>{
		return impl.search(
			function(x){
				return fn(x.snd());
			}
		);
	}
	public function toString():String{
		var shw 	= null;
		var gsh 	= function(x) {return shw == null ? shw = Show.getShowFor(x) : shw;}

		var vals 	= 
			impl.map(
				function(key:Int,val:V){
					return '$key : ${gsh(val)(val)}';
				}.tupled()
			);
		return vals.foldLeft('',
			function(memo:String,next:String){
				return Strings.append(memo,'\n\t').append(next);
			}
		);
	}
}	