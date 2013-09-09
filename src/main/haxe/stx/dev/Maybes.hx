package stx;

import stx.Prelude;

using stx.Functions;
using stx.Maybes;
using stx.Eithers;
using stx.Dynamics;

typedef Opt = Maybes;

class Maybes {
  /**
    Produces Maybe.Some(t) if 't' is not null, Maybe.None otherwise. 
    n.b Not safe to use with 'using'
   */
  @:noUsing
  static public function create<T>(t: T): Maybe<T> {
    return if (t == null) None; else Some(t);
  }
  static public function n<T>(t:T):Maybe<T>{
    return create(t);
  }
  static public function toMaybe<A>(v:A):Maybe<A>{
    return create(v);
  }
  @:noUsing
  static public function orDefault<A>(p0:A,p1:A){
    return create(p0).getOrElseC(p1);
  }
    /**
      Performs 'f' on the contents of 'o' if o != None
     */
    static public function map<T, S>(o: Maybe<T>, f: T -> S): Maybe<S> {
      return switch (o) {
        case None: None;
        case Some(v): Some(f(v));
      }
    }
  /**
    Performs 'f' on the contents of 'o' if 'o' != None
   */
  static public function foreach<T>(o: Maybe<T>, f: T -> Void): Maybe<T> {
    return switch (o) {
      case None     : o;
      case Some(v)  : f(v); o;
    }
  }
  /**
    Produces the result of 'f' which takes the contents of 'o' as a parameter.
   */
  static public function flatMap<T, S>(o: Maybe<T>, f: T -> Maybe<S>): Maybe<S> {
    return flatten(map(o, f));
  }
  /**
   Produces the contents of 'o', throwing an error if 'o' is None.
  */
  static public function get<T>(o: Maybe<T>): T {
    return switch (o) {
      case None   : Prelude.error()("Fail: Maybe is empty");
      case Some(v): v;
    }
  }
  /**
    Produces the value of 'o' if not None, the result of 'thunk' otehrwise.
   */
  static public function getOrElse<T>(o: Maybe<T>, thunk: Thunk<T>): T {
    return switch(o) {
      case None: thunk();
      case Some(v): v;
    }
  }
  /**
    Produces the value of 'o' if not None, 'c' otehrwise.
   */
  static public function getOrElseC<T>(o: Maybe<T>, c: T): T {
    return Maybes.getOrElse(o, c.toThunk());
  }
   /**
    Produces `o1` if it is Some, the result of `thunk` otherwise.
   */
  static public function orElse<T>(o1: Maybe<T>, thunk: Thunk<Maybe<T>>): Maybe<T> {
    return switch (o1) {
      case None: thunk();
      
      case Some(_): o1;
    }
  }
  /**
    Produces `o1` if it is Some, `o2` otherwise.
   */
  static public function orElseC<T>(o1: Maybe<T>, o2: Maybe<T>): Maybe<T> {
    return Maybes.orElse(o1, o2.toThunk());
  }
  /**
   Produces true if `o` is None, false otherwise.
   */
  static public function isEmpty<T>(o: Maybe<T>): Bool {
    return switch(o) {
      case None:    true;
      case Some(_): false;
    }
  }
  /**
   Produces true if `o` is not None, false otherwise.
   */
  static public function isDefined<T>(o: Maybe<T>): Bool {
    return switch(o) {
      case None:    false;
      case Some(_): true;
    }
  }
	/**
    Produces an Array of length 0 if 'o' is None, length 1 otherwise.return
   */
  static public function toArray<T>(o: Maybe<T>): Array<T> {
    return switch (o) {
      case None:    [];
      case Some(v): [v];
    }
  }
	/**
    Swallows 'o1' and produces 'o2'.
   */
  static public function then<T, S>(o1: Maybe<T>, o2: Maybe<S>): Maybe<S> {
    return o2;
  }
  /**
    Produces the input if predicate 'f' returns true, None otherwise.
   */
  static public function filter<T>(o: Maybe<T>, f: T -> Bool): Maybe<T> {
    return switch (o) {
      case None: None;
      case Some(v): if (f(v)) o else None;
    }
  }
  /** 
    Produces an Maybe where ´o1´ may contain another Maybe.
   */
  static public function flatten<T>(o1: Maybe<Maybe<T>>): Maybe<T> {
    return switch (o1) {
      case None: None;
      case Some(o2): o2;
    }
  }
  /**
   Produces a Tuple2 of ´o1´ and ´o2´.
   */
  static public function zip<T, S>(o1: Maybe<T>, o2: Maybe<S>) {
    return switch (o1) {
      case None: None;
      case Some(v1): o2.map(stx.Tuples.t2.p1(v1));
    }
  }
  /**
    Produces the result of ´f´ if both 'o1' and 'o2' are not None.
   */
  static public function zipWith<T, S, V>(o1: Maybe<T>, o2: Maybe<S>, f : T -> S -> V) : Maybe<V> {
    return switch (o1) {
      case None: None;
      case Some(v1):
				switch (o2) {
					case None : None;
					case Some(v2) : Some(f(v1, v2));
				}
    }
  }
  static public function oneOrOtherOrBothWith<A>(o1:Maybe<A>,o2:Maybe<A>,fn : A -> A -> A):Maybe<A>{
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
    Produces an Either where 'o1' is on the left, or if None, the result of 'thunk' on the right.
   */
  static public function orEither<T, S>(o1: Maybe<T>, thunk: Thunk<S>): Either<S, T> {
    return switch (o1) {
      case None: Eithers.toLeft(thunk());
      case Some(v): Eithers.toRight(v);
    }
  }
  /**
    Produces an Either where 'o1' is on the left, or if None, 'c'.
   */
  static public function orEitherC<T, S>(o1: Maybe<T>, c: S): Either<S, T> {
    return Maybes.orEither(o1, c.toThunk());
  }
} 
