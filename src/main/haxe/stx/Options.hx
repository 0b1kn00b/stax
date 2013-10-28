package stx;

import Stax.*;
import stx.Outcome;
import stx.Prelude;
import stx.Tuples;

using stx.Functions;
using stx.Options;
using stx.Eithers;
using stx.Anys;


class Options {
  @doc("Produces Option.Some(t) if `t` is not null, Option.None otherwise.")
  @:noUsing static public inline function create<T>(t: T): Option<T> {
    return if (t == null) None; else Some(t);
  }
  @doc("Performs `f` on the contents of `o` if o != None")
  static public function map<T, S>(o: Option<T>, f: T -> S): Option<S> {
    return switch (o) {
      case None   : None;
      case Some(v): Some(f(v));
    }
  }
  @doc("Performs `f` on the contents of `o` if `o` != None")
  static public function foreach<T>(o: Option<T>, f: T -> Void): Option<T> {
    return switch (o) {
      case None     : o;
      case Some(v)  : f(v); o;
    }
  }
  @doc("Produces the result of `f` which takes the contents of `o` as a parameter.")
  static public function flatMap<T, S>(o: Option<T>, f: T -> Option<S>): Option<S> {
    return flatten(map(o, f));
  }
  @doc("Produces the contents of `o`, throwing an error if `o` is None.")
  static public function get<T>(o: Option<T>): T {
    return switch (o) {
      case None   : Prelude.error()("Fail: Option is empty");
      case Some(v): v;
    }
  }
  @doc("Produces the value of `o` if not None, the result of `thunk` otherwise.")
  static public function getOrElse<T>(o: Option<T>, thunk: Thunk<T>): T {
    return switch(o) {
      case None: thunk();
      case Some(v): v;
    }
  }
  @doc("Produces the value of `o` if not None, `c` otherwise.")
  static public function getOrElseC<T>(o: Option<T>, c: T): T {
    return Options.getOrElse(o, c.toThunk());
  }
  @doc("Produces `o1` if it is Some, the result of `thunk` otherwise.")
  static public function orElse<T>(o1: Option<T>, thunk: Thunk<Option<T>>): Option<T> {
    return switch (o1) {
      case None: thunk();
      
      case Some(_): o1;
    }
  }
  @doc("Produces `o1` if it is Some, `o2` otherwise.")
  static public function orElseConst<T>(o1: Option<T>, o2: Option<T>): Option<T> {
    return Options.orElse(o1, o2.toThunk());
  }
  @doc("Produces true if `o` is None, false otherwise.")
  static public function isEmpty<T>(o: Option<T>): Bool {
    return switch(o) {
      case None:    true;
      case Some(_): false;
    }
  }
  @doc("Produces `true` if `o` is not None, `false` otherwise.")
  static public function isDefined<T>(o: Option<T>): Bool {
    return switch(o) {
      case None:    false;
      case Some(_): true;
    }
  }
	@doc("Produces an Array of length 0 if `o` is None, length 1 otherwise.")
  static public function toArray<T>(o: Option<T>): Array<T> {
    return switch (o) {
      case None:    [];
      case Some(v): [v];
    }
  }
	@doc("Swallows `o1` and produces `o2`.")
  static public function then<T, S>(o1: Option<T>, o2: Option<S>): Option<S> {
    return o2;
  }
  @doc("Produces the input if predicate `f` returns true, None otherwise.")
  static public function filter<T>(o: Option<T>, f: T -> Bool): Option<T> {
    return switch (o) {
      case None: None;
      case Some(v): if (f(v)) o else None;
    }
  }
  @doc("Produces an Option where `o1` may contain another Option.")
  static public function flatten<T>(o1: Option<Option<T>>): Option<T> {
    return switch (o1) {
      case None: None;
      case Some(o2): o2;
    }
  }
  @doc("Produces a Tuple2 of `o1` and `o2`.")
  static public function zip<T, S>(o1: Option<T>, o2: Option<S>):Option<Tuple2<T,S>> {
    return switch (o1) {
      case None     : None;
      case Some(v1) : o2.map(tuple2.bind(v1));
    }
  }
  @doc("Produces the result of `f` if both `o1` and `o2` are not None.")
  static public function zipWith<T, S, V>(o1: Option<T>, o2: Option<S>, f : T -> S -> V) : Option<V> {
    return switch (o1) {
      case None: None;
      case Some(v1):
				switch (o2) {
					case None : None;
					case Some(v2) : Some(f(v1, v2));
				}
    }
  }
  @doc('Produces one or other value if only one is defined, or calls `fn` on the two and returns the result')
  static public function oneOrOtherOrBothWith<A>(o1:Option<A>,o2:Option<A>,fn : A -> A -> A):Option<A>{
    return switch (o1){
      case Some(v)  :
        switch (o2){
          case Some(v0)  : Some(fn(v,v0));
          case None      : Some(v);
        }
      case None     :
        switch (o2){
          case Some(v)  : Some(v);
          case None     : None;
        }
    }
  }
  @doc("Produces an Either where `o1` is on the right, or if None, the result of  `thunk`  on the left.")
  static public function orEither<T, S>(o1: Option<S>, thunk: Thunk<T>): Either<T, S> {
    return switch (o1) {
      case None: Eithers.toLeft(thunk());
      case Some(v): Eithers.toRight(v);
    }
  }
  @doc("If `o1` is None, produce the result of `thunk`.")
  static public function orSuccess<T>(o1:Option<Fail>,thunk:Thunk<T>):Outcome<T>{
    return switch (o1) {
      case None     : Success(thunk());
      case Some(v)  : Failure(v);
    }
  }
  @doc("If `o1` is None, produce the result of `thunk`.")
  static public function orFailure<T>(o1:Option<T>,thunk:Thunk<Fail>):Outcome<T>{
    return switch (o1) {
      case None     : Failure(thunk());
      case Some(v)  : Success(v);
    } 
  }
  @doc("Produces an Either where `o1` is on the left, or if None, `c`.")
  static public function orEitherC<T, S>(o1: Option<T>, c: S): Either<S, T> {
    return Options.orEither(o1, c.toThunk());
  }
  static public function orSuccessC<T>(o0:Option<Fail>,v:T):Outcome<T>{
    return orSuccess(o0,thunk(v));
  }
  static public function orFailureC<T>(o0:Option<T>,v:Fail):Outcome<T>{
    return orFailure(o0,thunk(v));
  }
  public static function toBool<T>(option : Option<T>) : Bool {
    return switch (option) {
      case Some(_): true;
      case _: false;
    }
  }
} 
