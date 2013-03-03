package stx.io.json;

using stx.Prelude;

typedef ExtractorFunction<I, O>  					= Function1<I, O>;
typedef DecomposerFunction<I, O> 					= Function1<I, O>;

typedef JExtractorFunction<T>  						= Function1<JValue, T>;
typedef JDecomposerFunction<T> 						= Function1<T, JValue>;