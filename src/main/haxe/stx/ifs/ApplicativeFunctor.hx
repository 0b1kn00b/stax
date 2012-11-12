package stx.ifs;
import stx.ifs.Functor;

interface IApplicativeFunctor<T> {
	function pure<A>(v:A):IApplicativeFunctor<A>;
}