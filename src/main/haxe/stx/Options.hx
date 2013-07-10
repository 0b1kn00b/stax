package stx;

import stx.Prelude;
import stx.Tuples;

using stx.Functions;
using stx.Options;
using stx.Eithers;
using stx.Anys;


class Options {
  /**
    Produces Option.Some(t) if 't' is not null, Option.None otherwise. 
    n.b Not safe to use with 'using'
   */
  @:noUsing static public inline function create<T>(t: T): Option<T> {
    return if (t == null) None; else Some(t);
  }
  static public function toOption<A>(v:A):Option<A>{
    return create(v);
  }
  @:noUsing
  static public function orDefault<A>(p0:A,p1:A){
    return create(p0).getOrElseC(p1);
  }
  static public function dflt<A>(def:Void->A,possibly:A){
    return Options.create(possibly).getOrElse(def);
  }
  /**
    Performs 'f' on the contents of 'o' if o != None
   */
  static public function map<T, S>(o: Option<T>, f: T -> S): Option<S> {
    return switch (o) {
      case None   : None;
      case Some(v): Some(f(v));
    }
  }
  /**
    Performs 'f' on the contents of 'o' if 'o' != None
   */
  static public function foreach<T>(o: Option<T>, f: T -> Void): Option<T> {
    return switch (o) {
      case None     : o;
      case Some(v)  : f(v); o;
    }
  }
  /**
    Produces the result of 'f' which takes the contents of 'o' as a parameter.
   */
  static public function flatMap<T, S>(o: Option<T>, f: T -> Option<S>): Option<S> {
    return flatten(map(o, f));
  }
  /**
   Produces the contents of 'o', throwing an error if 'o' is None.
  */
  static public function get<T>(o: Option<T>): T {
    return switch (o) {
      case None   : Prelude.error()("Error: Option is empty");
      case Some(v): v;
    }
  }
  /**
    Produces the value of 'o' if not None, the result of 'thunk' otehrwise.
   */
  static public function getOrElse<T>(o: Option<T>, thunk: Thunk<T>): T {
    return switch(o) {
      case None: thunk();
      case Some(v): v;
    }
  }
  /**
    Produces the value of 'o' if not None, 'c' otehrwise.
   */
  static public function getOrElseC<T>(o: Option<T>, c: T): T {
    return Options.getOrElse(o, c.toThunk());
  }
   /**
    Produces `o1` if it is Some, the result of `thunk` otherwise.
   */
  static public function orElse<T>(o1: Option<T>, thunk: Thunk<Option<T>>): Option<T> {
    return switch (o1) {
      case None: thunk();
      
      case Some(_): o1;
    }
  }
  /**
    Produces `o1` if it is Some, `o2` otherwise.
   */
  static public function orElseConst<T>(o1: Option<T>, o2: Option<T>): Option<T> {
    return Options.orElse(o1, o2.toThunk());
  }
  /**
   Produces true if `o` is None, false otherwise.
   */
  static public function isEmpty<T>(o: Option<T>): Bool {
    return switch(o) {
      case None:    true;
      case Some(_): false;
    }
  }
  /**
   Produces true if `o` is not None, false otherwise.
   */
  static public function isDefined<T>(o: Option<T>): Bool {
    return switch(o) {
      case None:    false;
      case Some(_): true;
    }
  }
	/**
    Produces an Array of length 0 if 'o' is None, length 1 otherwise.return
   */
  static public function toArray<T>(o: Option<T>): Array<T> {
    return switch (o) {
      case None:    [];
      case Some(v): [v];
    }
  }
	/**
    Swallows 'o1' and produces 'o2'.
   */
  static public function then<T, S>(o1: Option<T>, o2: Option<S>): Option<S> {
    return o2;
  }
  /**
    Produces the input if predicate 'f' returns true, None otherwise.
   */
  static public function filter<T>(o: Option<T>, f: T -> Bool): Option<T> {
    return switch (o) {
      case None: None;
      case Some(v): if (f(v)) o else None;
    }
  }
  /** 
    Produces an Option where ´o1´ may contain another Option.
   */
  static public function flatten<T>(o1: Option<Option<T>>): Option<T> {
    return switch (o1) {
      case None: None;
      case Some(o2): o2;
    }
  }
  /**
   Produces a Tuple2 of ´o1´ and ´o2´.
   */
  static public function zip<T, S>(o1: Option<T>, o2: Option<S>) {
    return switch (o1) {
      case None: None;
      case Some(v1): o2.map(tuple2.p1(v1));
    }
  }
  /**
    Produces the result of ´f´ if both 'o1' and 'o2' are not None.
   */
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
  /**
    Produces an Either where 'o1' is on the right, or if None, the result of 'thunk' on the left.
   */
  static public function orEither<T, S>(o1: Option<T>, thunk: Thunk<S>): Either<S, T> {
    return switch (o1) {
      case None: Eithers.toLeft(thunk());
      case Some(v): Eithers.toRight(v);
    }
  }
  /**
    Produces an Either where 'o1' is on the left, or if None, 'c'.
   */
  static public function orEitherC<T, S>(o1: Option<T>, c: S): Either<S, T> {
    return Options.orEither(o1, c.toThunk());
  }

  public static function toBool<T>(option : Option<T>) : Bool {
    return switch (option) {
      case Some(_): true;
      case _: false;
    }
  }
} 
