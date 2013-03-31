/****
 HaXe library written by John A. De Goes <john@socialmedia.com>
 Contributed by Social Media Networks

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the
 distribution.

 THIS SOFTWARE IS PROVIDED BY SOCIAL MEDIA NETWORKS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SOCIAL MEDIA NETWORKS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
****/
package stx.io.json;

import stx.Prelude;
using stx.Tuples;

import stx.error.AbstractMethodError;

typedef ExtractorFunction<I, O>  					= Function<I, O>;
typedef DecomposerFunction<I, O> 					= Function<I, O>;

typedef JExtractorFunction<T>  						= Function<JValue, T>;
typedef JDecomposerFunction<T> 						= Function<T, JValue>;

typedef JExtractorFunction2<A,B>					= Tuple2<JValue,JValue> 											-> Tuple2<A,B>;
typedef JExtractorFunction3<A,B,C>				= Tuple3<JValue,JValue,JValue> 								-> Tuple3<A,B,C>;
typedef JExtractorFunction4<A,B,C,D>			= Tuple4<JValue,JValue,JValue,JValue> 				-> Tuple4<A,B,C,D>;
typedef JExtractorFunction5<A,B,C,D,E>		= Tuple5<JValue,JValue,JValue,JValue,JValue> 	-> Tuple5<A,B,C,D,E>;

interface Transcode<T,E>{
	public function decompose(v:T):JValue;
	public function extract(v: JValue):T;	
	public function extractWith(v:JValue,ex:E):T
}
class AbstractTranscode<T,E> implements Transcode<T,E>{
	public function decompose(v:T):JValue{
		throw new AbstractMethodError();
		return null;
	}
	public function extract(v:JValue,?ex:E):T{
		throw new AbstractMethodError();
		return null;	
	}
}
class Transcodes{
	static public var transcoders(default,null)  : Map<Transcode<Dynamic,Dynamic>>;

	private static function __init__(){
		transcoders = new Map();
		transcoders.set( Std.string(Type.typeof(Array))		, new stx.io.json.types.ArrayJValue() );
		transcoders.set( Std.string(Type.typeof(Bool)) 		, new stx.io.json.types.BoolJValue() );
		transcoders.set( Std.string(Type.typeof(Date)) 		, new stx.io.json.types.DateJValue() );
		transcoders.set( Std.string(Type.typeof(Float)) 	, new stx.io.json.types.FloatJValue() );
		transcoders.set( Std.string(Type.typeof(Int)) 		, new stx.io.json.types.IntJValue() );
		transcoders.set( Std.string(Type.typeof(String)) 	, new stx.io.json.types.StringJValue() );

		transcoders.set( Std.string(Type.getEnumName(stx.Maybe)) 					, new stx.io.json.types.stx.MaybeJValue() );
		transcoders.set( Std.string(Type.getEnumName(stx.io.json.JValue)) 	, new stx.io.json.types.stx.io.json.JValue() );
	}

}