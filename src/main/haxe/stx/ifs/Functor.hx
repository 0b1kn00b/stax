package stx.ifs;

interface IFunctor<T>{
	public dynamic function fmap<A,B>(fn:A->B):IFunctor<A> -> IFunctor<B>;	
}
class Functor<T>{
	public function new<A,B>(opts:{ fmap : (A->B)->(IFunctor<A>->IFunctor<B>) }){
		if(opts!=null){
			this.fmap = opts.fmap;
		}
	}
	public dynamic function fmap<A,B>(fn:A->B):IFunctor<A> -> IFunctor<B>{
		return null;
	}
}