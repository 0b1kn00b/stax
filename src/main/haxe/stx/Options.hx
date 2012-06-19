package stx;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.Prelude;
using stx.Options;
using stx.Eithers;
using stx.Dynamics;

class Options {
  /**
   * Produces Option.Some(t) if 't' is not null, Option.None otherwise. 
   * n.b Not safe to use with 'using'
   */
  public static function toOption<T>(t: T): Option<T> {
    return if (t == null) None; else Some(t);
  }
	/**
   * Produces an Array of length 0 if 'o' is None, length 1 otherwise.return
   */
  public static function toArray<T>(o: Option<T>): Array<T> {
    return switch (o) {
      case None:    [];
      case Some(v): [v];
    }
  }
  /**
   * Performs 'f' on the contents of 'o' if o != None
   */
  public static function map<T, S>(o: Option<T>, f: T -> S): Option<S> {
    return switch (o) {
      case None: None;
      case Some(v): Some(f(v));
    }
  }
	/**
   * Swallows 'o1' and produces 'o2'.
   */
  public static function then<T, S>(o1: Option<T>, o2: Option<S>): Option<S> {
    return o2;
  }
  /**
   * Performs 'f' on the contents of 'o' if 'o' != None
   */
  public static function foreach<T>(o: Option<T>, f: T -> Void): Option<T> {
    return switch (o) {
      case None     : o;
      case Some(v)  : f(v); o;
    }
  }
  /**
   * Produces the input if predicate 'f' returns true, None otherwise.
   */
  public static function filter<T>(o: Option<T>, f: T -> Bool): Option<T> {
    return switch (o) {
      case None: None;
      case Some(v): if (f(v)) o else None;
    }
  }
  /**
   * Produces the result of 'f' which takes the contents of 'o' as a parameter.
   */
  public static function flatMap<T, S>(o: Option<T>, f: T -> Option<S>): Option<S> {
    return flatten(map(o, f));
  }
  /** 
   * Produces an Option where 'o1' may contain another Option.
   */
  public static function flatten<T>(o1: Option<Option<T>>): Option<T> {
    return switch (o1) {
      case None: None;
      case Some(o2): o2;
    }
  }
  /**
   * Produces a Tuple2 of 'o1' and 'o2'.
   */
  public static function zip<T, S>(o1: Option<T>, o2: Option<S>) {
    return switch (o1) {
      case None: None;
      case Some(v1): o2.map(callback( stx.Tuples.t2 , v1));
    }
  }
  /**
   * Produces the result of 'f' if both 'o1' and 'o2' are not None.
   */
  public static function zipWith<T, S, V>(o1: Option<T>, o2: Option<S>, f : T -> S -> V) : Option<V> {
    return switch (o1) {
      case None: None;
      case Some(v1):
				switch (o2) {
					case None : None;
					case Some(v2) : Some(f(v1, v2));
				}
    }
  }
  /**
   * Produces the contents of 'o', throwing an error if 'o' is None.
   */
  public static function get<T>(o: Option<T>): T {
    return switch (o) {
      case None: Stax.error("Error: Option is empty"); null;
      case Some(v): v;
    }
  }
  /**
   * Produces 'o1' if it is not None, the result of 'thunk' otherwise.
   */
  public static function orElse<T>(o1: Option<T>, thunk: Thunk<Option<T>>): Option<T> {
    return switch (o1) {
      case None: thunk();
      
      case Some(v): o1;
    }
  }
  /**
   * Produces 'o1' if it is not None, 'o2' otherwise.
   */
  public static function orElseC<T>(o1: Option<T>, o2: Option<T>): Option<T> {
    return Options.orElse(o1, o2.toThunk());
  }
  
  /**
   * Produces an Either where 'o1' is on the left, or if None, the result of 'thunk' on the right.
   */
  public static function orEither<T, S>(o1: Option<T>, thunk: Thunk<S>): Either<S, T> {
    return switch (o1) {
      case None: Eithers.toLeft(thunk());
      case Some(v): Eithers.toRight(v);
    }
  }
  /**
   * Produces an Either where 'o1' is on the left, or if None, 'c'.
   */
  public static function orEitherC<T, S>(o1: Option<T>, c: S): Either<S, T> {
    return Options.orEither(o1, c.toThunk());
  }
  
  /**
   * Produces the value of 'o' if not None, the result of 'thunk' otehrwise.
   */
  public static function getOrElse<T>(o: Option<T>, thunk: Thunk<T>): T {
    return switch(o) {
      case None: thunk();
      case Some(v): v;
    }
  }
  /**
   * Produces the value of 'o' if not None, 'c' otehrwise.
   */
  public static function getOrElseC<T>(o: Option<T>, c: T): T {
    return Options.getOrElse(o, c.toThunk());
  }
  /**
   * Produces true if 'o' is None, false otherwise.
   */
  public static function isEmpty<T>(o: Option<T>): Bool {
    return switch(o) {
      case None:    true;
      case Some(_): false;
    }
  }
  /**
   *^Produces true if 'o' is not None, false otherwise.
   */
  public static function isDefined<T>(o: Option<T>): Bool {
    return switch(o) {
      case None:    false;
      case Some(_): true;
    }
  }
} 
