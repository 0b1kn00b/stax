package stx.framework {
	import stx.framework.BindingType;
	public interface InjectorConfig {
		function inPackage(p : String) : * ;
		function inModule(m : String) : * ;
		function inClass(c : Class) : * ;
		function bindF(interf : Class,f : Function,b : stx.framework.BindingType = null) : stx.framework.InjectorConfig ;
		function bind(interf : Class,c : Class,b : stx.framework.BindingType = null) : stx.framework.InjectorConfig ;
	}
}
