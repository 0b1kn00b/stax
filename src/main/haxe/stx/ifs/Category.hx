package stx.ifs;

using stx.Types;
using stx.Options;
using stx.Prelude;

interface ICategory<A,B>{
  public function dot<Y,Z>(f:ICategory<Y,Z>):ICategory<Y,B>;
  public function next<A,B,C>(g:ICategory<B,C>):ICategory<B,C>;
  public function back<Y,Z>(f:ICategory<Y,Z>):ICategory<Y,B>;
}
/*class Category{
	public function new<Y,Z>(opts){
  	Opt.n(opts)
  		.foreach(
  			function(x){
  				Objects.extractAllAny(x)
  					.foreach(
  						Reflects.setFieldTp
  					);
  			}
  		);
  }
  dynamic public function dot<B,Y,Z>(f:ICategory<Y,Z>):ICategory<Y,B>{
		return null;
  }
  dynamic public function next<A,B,C>(g:ICategory<B,C>):ICategory<B,C>{
  	return null;
  }
  dynamic public function back<B,Y,Z>(f:ICategory<Y,Z>):ICategory<Y,B>{
  	return null;
  }
}*/