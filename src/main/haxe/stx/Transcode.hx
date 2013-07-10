package stx;

import stx.Prelude;

using stx.Error;
using stx.Functions;
using stx.Compose;
using stx.Eithers;

import haxe.Serializer;
import haxe.Unserializer;

class Transcode{
  static public function encode<T>(v:T):String{
    var o : String = null;

    switch (Type.typeof(v)){
      case TNull,TInt,TFloat,TBool  :
        o = haxe.Serializer.run(Right(v));
      case TObject,TClass(_)        :
        o = encodeSafe(v);
      case TFunction                :
        o = encodeSafe(Left(new Error('Cannot transcode a function')));
      case TEnum( e ) if ( Type.enumEq(e,Either) ) : //can only assume this is an Outcome, no other way to check.
        var m : Outcome<Dynamic> = cast v;
        switch (m){
          case Left(l)  : o   = haxe.Serializer.run(Left(l));
          case Right(_) : o   = encodeSafe(v);
        }
      default                       : o = encodeSafe(v);
    }
    return o;
  }
  static private function encodeSafe<T>(v:T):String{
    return haxe.Serializer.run.catching()
      .then(Eithers.mapL.bind(_,haxe.Serializer.run))
      .then(Eithers.either)(v);
  }
  static public function decode<T>(v:String):Outcome<T>{
    return haxe.Unserializer.run.catching()(v)
    .flatMapR(
      function(v0){
        return switch (Type.typeof(v0)){
          case TEnum( e ) if (Type.enumEq(e,Either)) :
            var m : Outcome<T> = cast v0; m;
          case _                                  :
            Right(v0);
        }
      }
    );
  }
}