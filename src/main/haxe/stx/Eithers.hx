package stx;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.Prelude;
using stx.Tuples;

class Eithers {
  static public function toTuple<A,B>(e:Either<A,B>):Tuple2<A,B>{
    return 
      switch(e){
        case Left(v)  : Tuples.t2(v,null);
        case Right(v) : Tuples.t2(null,v);
        default       : throw 'Either is neither Left not Right';null;
      };
  }
  static public function toTupleO<A,B>(e:Either<A,B>):Tuple2<Option<A>,Option<B>>{
    return 
      switch(e){
        case Left(v)  : Tuples.t2(Some(v),None);
        case Right(v) : Tuples.t2(None,Some(v));
        default       : throw 'Either is neither Left not Right';
      };
  }
  static public function toLeft<A, B>(v: A): Either<A, B> {
    return Left(v);
  }
  
  static public function toRight<A, B>(v: B): Either<A, B> {
    return Right(v);
  }
  
  static public function flip<A, B>(e: Either<A, B>): Either<B, A> {
    return switch(e) {
      case Left(v): Right(v);
      case Right(v): Left(v);
    }
  }
  
  static public function left<A, B>(e: Either<A, B>): Option<A> {
    return switch (e) {
      case Left(v): Some(v);
      
      default: None;
    }
  }
    
  static public function isLeft<A, B>(e: Either<A, B>): Bool {
    return switch (e) {
      case Left(_):  true;
      case Right(_): false;
    }
  }
  
  static public function isRight<A, B>(e: Either<A, B>): Bool {
    return switch (e) {
      case Left(_):  false;
      case Right(_): true;
    }
  }
  
  static public function right<A, B>(e: Either<A, B>): Option<B> {
    return switch (e) {
      case Right(v): Some(v);
      
      default: None;
    }
  }
  
  static public function get<A>(e: Either<A, A>): A {
    return switch (e) {
      case Left(v): v;
      case Right(v): v;
    }
  }
  
  static public function mapLeft<A, B, C>(e: Either<A, B>, f: A -> C): Either<C, B> {
    return switch (e) {
      case Left(v): Left(f(v));
      case Right(v): Right(v);
    }
  }
  
  static public function map<A, B, C, D>(e: Either<A, B>, f1: A -> C, f2: B -> D): Either<C, D> {
    return switch (e) {
      case Left(v): Left(f1(v));
      case Right(v): Right(f2(v));
    }
  }
  
  static public function mapRight<A, B, D>(e: Either<A, B>, f: B -> D): Either<A, D> {
    return switch (e) {
      case Left(v): Left(v);
      case Right(v): Right(f(v));
    }
  }
  
  static public function flatMap<A, B, C, D>(e: Either<A, B>, f1: A -> Either<C, D>, f2: B -> Either<C, D>): Either<C, D> {
    return switch (e) {
      case Left(v): f1(v);
      case Right(v): f2(v);
    }
  }
  static public function flatMapR<A, B, C , D>(e: Either<A, B>,f : B -> Either<C,D>):Either<C,D>{
    return
      flatMap(e,cast Eithers.toLeft,f);
  }
  /** Composes two Eithers together. In case of conflicts, "failure" (left) 
   * always wins.
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
   * Composes two Eithers together. In case of conflicts, "success" (right) 
   * always wins.
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
}
