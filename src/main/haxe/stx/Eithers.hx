package stx;

import stx.Prelude;
using stx.Tuples;
using stx.Eithers;
using stx.Functions;

class Eithers {
  /**
    Creates a Left from any value
  */
  static public function toLeft<A, B>(v: A): Either<A, B> {
    return Left(v);
  }
  /**
    Creates a Right from any value
 */
  static public function toRight<A, B>(v: B): Either<A, B> {
    return Right(v);
  }
  /**
    Flips a Left to a Right or vice-versa.
  */
  static public function flip<A, B>(e: Either<A, B>): Either<B, A> {
    return switch(e) {
      case Left(v): Right(v);
      case Right(v): Left(v);
    }
  }
  /**
    Returns an option which is Some if the either is Left, None otherwise
  */
  static public function left<A, B>(e: Either<A, B>): Option<A> {
    return switch (e) {
      case Left(v): Some(v);
      
      default: None;
    }
  }
  /**
    Returns true if either is Left.
  */
  static public function isLeft<A, B>(e: Either<A, B>): Bool {
    return switch (e) {
      case Left(_):  true;
      case Right(_): false;
    }
  }
  /**
    Returns an option which is Some if the either is Right, none otherwise.
  */
  static public function right<A, B>(e: Either<A, B>): Option<B> {
    return switch (e) {
      case Right(v): Some(v);
      
      default: None;
    }
  }
  /**
    Returns true if either is Right.
  */
  static public function isRight<A, B>(e: Either<A, B>): Bool {
    return switch (e) {
      case Left(_):  false;
      case Right(_): true;
    }
  }
  /**
    Returns the raw value of an Either.
  */
  static public function get<A>(e: Either<A, A>): A {
    return switch (e) {
      case Left(v): v;
      case Right(v): v;
    }
  }
  /**
    Transforms the value of an Either if it is Left.
  */
  static public function mapL<A, B, C>(e: Either<A, B>, f: A -> C): Either<C, B> {
    return switch (e) {
      case Left(v): Left(f(v));
      case Right(v): Right(v);
    }
  }
  /**
    Transforms the value of an Either.
  */
  static public function map<A, B, C, D>(e: Either<A, B>, f1: A -> C, f2: B -> D): Either<C, D> {
    return switch (e) {
      case Left(v): Left(f1(v));
      case Right(v): Right(f2(v));
    }
  }
  /**
    Transforms the value of an Either if it is Right.
  */
  static public function mapR<A, B, D>(e: Either<A, B>, f: B -> D): Either<A, D> {
    return switch (e) {
      case Left(v): Left(v);
      case Right(v): Right(f(v));
    }
  }
  /**
    Creates a new Either with functions that take the value of the either and return a new Either.
  */
  static public function flatMap<A, B, C, D>(e: Either<A, B>, f1: A -> Either<C, D>, f2: B -> Either<C, D>): Either<C, D> {
    return switch (e) {
      case Left(v): f1(v);
      case Right(v): f2(v);
    }
  }
  /**
    Creates a new Either if the original is Right
  */
  static public function flatMapR<A, B, C , D>(e: Either<A, B>,f : B -> Either<C,D>):Either<C,D>{
    return
      flatMap(e,cast Eithers.toLeft,f);
  }
  /**
    Creates a new Either if the original is Left
  */
  static public function flatMapL<A, B, C , D>(e: Either<A, B>,f : A -> Either<C,D>):Either<C,D>{
    return
      flatMap(e,f,cast Eithers.toRight);
  }
  /** 
    Composes two Eithers together. In case of conflicts, "failure" (left) 
    always wins.
   */
  static public function composeLeft<A, B>(e1: Either<A, B>, e2: Either<A, B>, ac: A -> A -> A, bc: B -> B -> B): Either<A, B> {
    return switch (e1) {
      case Left(v1): switch (e2) {
        case Left(v2): Left(ac(v1, v2));
        case Right(v2): Left(v1);
      }
      case Right(v1): switch (e2) {
        case Left(v2): Left(v2);
        case Right(v2): Right(bc(v1, v2));
      }
    }
  }
  
  /** 
    Composes two Eithers together. In case of conflicts, "success" (right) 
    always wins.
   */
  static public function composeRight<A, B>(e1: Either<A, B>, e2: Either<A, B>, ac: A -> A -> A, bc: B -> B -> B): Either<A, B> {
    return switch (e1) {
      case Left(v1): switch (e2) {
        case Left(v2): Left(ac(v1, v2));
        case Right(v2): Right(v2);
      }
      case Right(v1): switch (e2) {
        case Left(v2): Right(v1);
        case Right(v2): Right(bc(v1, v2));
      }
    }
  }
  static public function unzip<A,B,C>(tp:Tuple2<Either<A,B>,Either<A,C>>):Either<A,Tuple2<B,C>>{
    return 
      tp._1.flatMapR(
        function(b:B){
          return tp._2.mapR( Tuples.t2.p1(b) );
        }
      );
  }
  static public function flattenR<A,B,C>(e:Either<A,Either<A,C>>):Either<A,C>{
    return
      switch (e) {
        case Left(v)  : Left(v);
        case Right(v) :
          switch (v) {
            case Left(v)  : Left(v);
            case Right(v) : Right(v);
          }
      }
  }
  static public function flattenL<A,B,C>(e:Either<Either<C,A>,A>):Either<C,A>{
    return
      switch (e) {
        case Right(v)   : Right(v);
        case Left(v)    :
          switch (v) {
            case Left(v)  : Left(v);
            case Right(v) : Right(v);
          }
      }
  }
  static public function either<A>(e:Either<A,A>):A{
    return switch (e) {
      case Left(v)  : v;
      case Right(v) : v;
    }
  }
  static public function foreachR<A,B>(e:Either<A,B>,fn:B->Void):Either<A,B>{
    switch (e){
      case Right(v)       : fn(v);
      default             :
    }
    return e;
  }
}
