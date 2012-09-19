package stx.io.json;

using stx.Prelude;

typedef ExtractorFunction<I, O>  					= Function<I, O>;
typedef DecomposerFunction<I, O> 					= Function<I, O>;

typedef JExtractorFunction<T>  						= Function<JValue, T>;
typedef JDecomposerFunction<T> 						= Function<T, JValue>;