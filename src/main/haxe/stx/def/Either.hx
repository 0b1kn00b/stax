package stx.def;
/** 
  Either represents a type that is either a "left" value or a "right" value,
  but not both. Either is often used to represent success/failure, where the
  left side represents failure, and the right side represents success.
 */
enum Either<A, B> {
  Left(v: A);
  Right(v: B);
}