package stx.framework._Injector {
	import stx.framework.InjectorConfig;
	import stx.framework._Injector.InjectorImpl;
	import stx.framework.BindingType;
	public class InjectorConfigImpl implements stx.framework.InjectorConfig{
		public function InjectorConfigImpl() : void {
		}
		
		public function inModule(m : String) : * {
			var self : stx.framework._Injector.InjectorConfigImpl = this;
			return { bind : function(interf : Class,impl : Class,b : stx.framework.BindingType = null) : stx.framework.InjectorConfig {
				stx.framework._Injector.InjectorImpl.inModule(m).bindTo(interf,impl,b);
				return self;
			}, bindF : function(interf1 : Class,f : Function,b1 : stx.framework.BindingType = null) : stx.framework.InjectorConfig {
				stx.framework._Injector.InjectorImpl.inModule(m).bindToF(interf1,f,b1);
				return self;
			}}
		}
		
		public function inPackage(p : String) : * {
			var self : stx.framework._Injector.InjectorConfigImpl = this;
			return { bind : function(interf : Class,impl : Class,b : stx.framework.BindingType = null) : stx.framework.InjectorConfig {
				stx.framework._Injector.InjectorImpl.inPackage(p).bindTo(interf,impl,b);
				return self;
			}, bindF : function(interf1 : Class,f : Function,b1 : stx.framework.BindingType = null) : stx.framework.InjectorConfig {
				stx.framework._Injector.InjectorImpl.inPackage(p).bindToF(interf1,f,b1);
				return self;
			}}
		}
		
		public function inClass(c : Class) : * {
			var self : stx.framework._Injector.InjectorConfigImpl = this;
			return { bind : function(interf : Class,impl : Class,b : stx.framework.BindingType = null) : stx.framework.InjectorConfig {
				stx.framework._Injector.InjectorImpl.inClass(c).bindTo(interf,impl,b);
				return self;
			}, bindF : function(interf1 : Class,f : Function,b1 : stx.framework.BindingType = null) : stx.framework.InjectorConfig {
				stx.framework._Injector.InjectorImpl.inClass(c).bindToF(interf1,f,b1);
				return self;
			}}
		}
		
		public function bindF(_tmp_interf : Class,_tmp_f : Function,b : stx.framework.BindingType = null) : stx.framework.InjectorConfig {
			var interf : Class = _tmp_interf, f : Function = _tmp_f;
			stx.framework._Injector.InjectorImpl.globally().bindToF(interf,f,b);
			return this;
		}
		
		public function bind(_tmp_interf : Class,impl : Class,b : stx.framework.BindingType = null) : stx.framework.InjectorConfig {
			var interf : Class = _tmp_interf;
			stx.framework._Injector.InjectorImpl.globally().bindTo(interf,impl,b);
			return this;
		}
		
	}
}
