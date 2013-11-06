package;

import haxe.PosInfos;

class Prelude{
  
}
typedef Callback<A>   = A->Void;
typedef Thunk<T>      = Void->T;
typedef Endo<T>       = T->T;
typedef Reduce<A,Z>   = A->A->Z;
typedef Semi<T>       = Reduce<T,T>;
typedef Niladic       = Void->Void;
typedef Pair<A>       = Tuple2<A,A>;

typedef Lense<A,B>    = {
  get : A->B,
  set : B->A->A
}
enum Outcome<T>{
  Success(success:T);
  Failure(failure:stx.Fail);
}
enum Unit{
  Unit;
}
enum Traverse {
	Pre;
	In;
	Post;
	Level;
}
enum FieldOrder {
  Ascending;
  Descending;
  Ignore;
}
@doc("Underlies all thrown values in Stax, extensible through the use of `FrameworkError`.")
enum Error{
  Failed(?reason:String,?pos:PosInfos);
  AbstractMethodError(?pos:PosInfos);
  ArgumentError(field:String,?pos:PosInfos);
  AssertionError(is:String,?should:String,?pos:PosInfos);
  ErrorStack(arr:Array<stx.Fail>);
  TypeError(msg:String,?pos:PosInfos);
  NullReferenceError(field:String,?pos:PosInfos);
  OutOfBoundsError(?msg:String,?pos:PosInfos);
  NativeError(err:Dynamic);
  FrameworkError(flag:EnumValue,?pos:PosInfos);
  IllegalOperationError(msg:String,?pos:PosInfos);
  InjectionError(cls:Class<Dynamic>,?err:stx.Fail);
  ConstructorError(cls:Class<Dynamic>,?err:stx.Fail);
}
@doc("
    An option represents an optional value -- the value may or may not be
    present. Option is a much safer alternative to null that often enables
    reduction in code size and increase in code clarity.
")
enum Option<T> {
  None;
  Some(v: T);
}
enum Tuple1<T1> {
    tuple1(t1 : T1);
}
enum Tuple2<T1, T2> {
    tuple2(t1 : T1, t2 : T2);
}
enum Tuple3<T1, T2, T3> {
    tuple3(t1 : T1, t2 : T2, t3 : T3);
}
enum Tuple4<T1, T2, T3, T4> {
    tuple4(t1 : T1, t2 : T2, t3 : T3, t4 : T4);
}
enum Tuple5<T1, T2, T3, T4, T5> {
    tuple5(t1 : T1, t2 : T2, t3 : T3, t4 : T4, t5 : T5);
}
@:funk
enum Wildcard{
  _;
}