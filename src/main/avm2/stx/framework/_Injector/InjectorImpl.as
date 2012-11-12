package stx.framework._Injector {
	import stx.framework._Injector.InjectorConfigImpl;
	import stx.Functions1;
	import stx.framework.BindingType;
	import stx.Functions2;
	import stx.Option;
	import stx.Tuple2;
	import haxe.rtti.Meta;
	import stx.Options;
	import stx.Dynamics;
	import stx.Tuples;
	public class InjectorImpl {
		static protected var state : Array = [];
		static protected var classBindingsExtractor : Function = function(b : *) : Hash {
			return b.classBindings;
		}
		static protected var moduleBindingsExtractor : Function = function(b : *) : Hash {
			return b.moduleBindings;
		}
		static protected var packageBindingsExtractor : Function = function(b : *) : Hash {
			return b.packageBindings;
		}
		static public function inject(interf : Class,pos : * = null) : * {
			var binding : stx.Option = stx.framework._Injector.InjectorImpl.getMostSpecificBinding(interf,pos);
			var factory : Function = stx.Options.getOrElse(binding,stx.Functions2.lazy(Prelude.error,"No binding defined for " + Type.getClassName(interf),Stax.here({ fileName : "Injector.hx", lineNumber : 154, className : "stx.framework._Injector.InjectorImpl", methodName : "inject"})));
			return factory();
		}
		
		static public function forever(f : Function) : * {
			stx.framework._Injector.InjectorImpl.state.unshift({ defaultBindings : new Hash(), globalBindings : new Hash(), packageBindings : new Hash(), moduleBindings : new Hash(), classBindings : new Hash()});
			return f(new stx.framework._Injector.InjectorConfigImpl());
		}
		
		static public function enter(f : Function) : * {
			stx.framework._Injector.InjectorImpl.state.unshift({ defaultBindings : new Hash(), globalBindings : new Hash(), packageBindings : new Hash(), moduleBindings : new Hash(), classBindings : new Hash()});
			var result : * = null;
			try {
				result = f(new stx.framework._Injector.InjectorConfigImpl());
				stx.framework._Injector.InjectorImpl.state.shift();
			}
			catch( e : * ){
				stx.framework._Injector.InjectorImpl.state.shift();
				throw e;
			}
			return result;
		}
		
		static public function bindTo(interf : Class,impl : Class,bindingType : stx.framework.BindingType = null) : * {
			stx.framework._Injector.InjectorImpl.globally().bindTo(interf,impl,bindingType);
			return;
		}
		
		static public function bindToF(interf : Class,f : Function,bindingType : stx.framework.BindingType) : * {
			stx.framework._Injector.InjectorImpl.globally().bindToF(interf,f,bindingType);
			return;
		}
		
		static public function globally() : * {
			var internalBind : Function = function(interf : Class,f : Function,bindingType : stx.framework.BindingType) : void {
				{
					var $e : enum = (stx.framework._Injector.InjectorImpl.bindingTypeDef(bindingType));
					switch( $e.index ) {
					case 0:
					stx.framework._Injector.InjectorImpl.addGlobalBinding(interf,f);
					break;
					case 1:
					stx.framework._Injector.InjectorImpl.addGlobalBinding(interf,stx.Dynamics.memoize(f));
					break;
					}
				}
			}
			return { bindToF : internalBind, bindTo : function(interf1 : Class,impl : Class,bindingType1 : stx.framework.BindingType) : void {
				internalBind(interf1,stx.framework._Injector.InjectorImpl.factoryFor(impl),bindingType1);
			}}
		}
		
		static public function inClass(c : Class) : * {
			return { bindToF : function(interf : Class,f : Function,bindingType : stx.framework.BindingType = null) : void {
				stx.framework._Injector.InjectorImpl.bindForSpecificF(stx.framework._Injector.InjectorImpl.classBindingsExtractor,interf,Type.getClassName(c),f,bindingType);
			}, bindTo : function(interf1 : Class,impl : Class,bindingType1 : stx.framework.BindingType = null) : void {
				stx.framework._Injector.InjectorImpl.bindForSpecificF(stx.framework._Injector.InjectorImpl.classBindingsExtractor,interf1,Type.getClassName(c),stx.framework._Injector.InjectorImpl.factoryFor(impl),bindingType1);
			}}
		}
		
		static public function inModule(moduleName : String) : * {
			return { bindToF : function(interf : Class,f : Function,bindingType : stx.framework.BindingType) : void {
				stx.framework._Injector.InjectorImpl.bindForSpecificF(stx.framework._Injector.InjectorImpl.moduleBindingsExtractor,interf,moduleName,f,bindingType);
			}, bindTo : function(interf1 : Class,impl : Class,bindingType1 : stx.framework.BindingType) : void {
				stx.framework._Injector.InjectorImpl.bindForSpecificF(stx.framework._Injector.InjectorImpl.moduleBindingsExtractor,interf1,moduleName,stx.framework._Injector.InjectorImpl.factoryFor(impl),bindingType1);
			}}
		}
		
		static public function inPackage(packageName : String) : * {
			return { bindToF : function(interf : Class,f : Function,bindingType : stx.framework.BindingType) : void {
				stx.framework._Injector.InjectorImpl.bindForSpecificF(stx.framework._Injector.InjectorImpl.packageBindingsExtractor,interf,packageName,f,bindingType);
			}, bindTo : function(interf1 : Class,impl : Class,bindingType1 : stx.framework.BindingType) : void {
				stx.framework._Injector.InjectorImpl.bindForSpecificF(stx.framework._Injector.InjectorImpl.packageBindingsExtractor,interf1,packageName,stx.framework._Injector.InjectorImpl.factoryFor(impl),bindingType1);
			}}
		}
		
		static protected function bindForSpecificF(extractor : Function,interf : Class,specific : String,f : Function,bindingType : stx.framework.BindingType) : void {
			{
				var $e : enum = (stx.framework._Injector.InjectorImpl.bindingTypeDef(bindingType));
				switch( $e.index ) {
				case 0:
				stx.framework._Injector.InjectorImpl.addSpecificBinding(extractor(stx.framework._Injector.InjectorImpl.state[0]),interf,specific,f);
				break;
				case 1:
				stx.framework._Injector.InjectorImpl.addSpecificBinding(extractor(stx.framework._Injector.InjectorImpl.state[0]),interf,specific,stx.Dynamics.memoize(f));
				break;
				}
			}
		}
		
		static protected function getMostSpecificBinding(c : Class,pos : *) : stx.Option {
			var className : String = stx.framework._Injector.InjectorImpl.classOf(pos);
			var moduleName : String = stx.framework._Injector.InjectorImpl.moduleOf(pos);
			var packageName : String = stx.framework._Injector.InjectorImpl.packageOf(pos);
			return stx.Options.orElse(stx.Options.orElse(stx.Options.orElse(stx.Options.orElse(stx.framework._Injector.InjectorImpl.getClassBinding(c,className),stx.Functions2.lazy(stx.framework._Injector.InjectorImpl.getModuleBinding,c,moduleName)),stx.Functions2.lazy(stx.framework._Injector.InjectorImpl.getPackageBinding,c,packageName)),stx.Functions1.lazy(stx.framework._Injector.InjectorImpl.getGlobalBinding,c)),stx.Functions1.lazy(stx.framework._Injector.InjectorImpl.getDefaultImplementationBinding,c));
		}
		
		static protected function getDefaultImplementationBinding(c : Class) : stx.Option {
			if(stx.framework._Injector.InjectorImpl.existsDefaultBinding(c)) return stx.framework._Injector.InjectorImpl.getDefaultBinding(c);
			var f : stx.Option = stx.Options.flatMap(stx.Options.flatMap(stx.Options.flatMap(stx.Options.toOption(haxe.rtti.Meta.getType(c)),function(m : *) : stx.Option {
				return stx.Options.toOption(((Reflect.hasField(m,"DefaultImplementation"))?Reflect.field(m,"DefaultImplementation"):null));
			}),function(p : Array) : stx.Option {
				var cls : Class = null;
				return ((null == p || null == p[0] || null == (cls = Type.resolveClass(p[0])))?stx.Option.None:stx.Option.Some(stx.Tuples.t2(cls,((null != p[1])?Type.createEnum(stx.framework.BindingType,p[1],[]):null))));
			}),function(p1 : stx.Tuple2) : stx.Option {
				return function() : stx.Option {
					var $r : stx.Option;
					{
						var $e2 : enum = (stx.framework._Injector.InjectorImpl.bindingTypeDef(p1._2));
						switch( $e2.index ) {
						case 0:
						$r = stx.Options.toOption(stx.framework._Injector.InjectorImpl.factoryFor(p1._1));
						break;
						case 1:
						$r = stx.Options.toOption(stx.Dynamics.memoize(stx.framework._Injector.InjectorImpl.factoryFor(p1._1)));
						break;
						}
					}
					return $r;
				}();
			});
			stx.framework._Injector.InjectorImpl.addDefaultBinding(c,f);
			return f;
		}
		
		static protected function getGlobalBinding(c : Class) : stx.Option {
			var className : String = Type.getClassName(c);
			return Prelude.SArrays.foldl(stx.framework._Injector.InjectorImpl.state,stx.Option.None,function(a : stx.Option,b : *) : stx.Option {
				return stx.Options.orElseC(a,stx.Options.toOption(b.globalBindings.get(className)));
			});
		}
		
		static protected function getClassBinding(c : Class,className : String) : stx.Option {
			return stx.framework._Injector.InjectorImpl.getSpecificBinding(stx.framework._Injector.InjectorImpl.classBindingsExtractor,c,className);
		}
		
		static protected function getModuleBinding(c : Class,moduleName : String) : stx.Option {
			return stx.framework._Injector.InjectorImpl.getSpecificBinding(stx.framework._Injector.InjectorImpl.moduleBindingsExtractor,c,moduleName);
		}
		
		static protected function getPackageBinding(c : Class,packageName : String) : stx.Option {
			return stx.framework._Injector.InjectorImpl.getSpecificBinding(stx.framework._Injector.InjectorImpl.packageBindingsExtractor,c,packageName);
		}
		
		static protected function addGlobalBinding(c : Class,f : Function) : void {
			stx.framework._Injector.InjectorImpl.state[0].globalBindings.set(Type.getClassName(c),f);
		}
		
		static protected function existsDefaultBinding(c : Class) : Boolean {
			return stx.framework._Injector.InjectorImpl.state[0].defaultBindings.exists(Type.getClassName(c));
		}
		
		static protected function addDefaultBinding(c : Class,f : stx.Option) : void {
			stx.framework._Injector.InjectorImpl.state[0].defaultBindings.set(Type.getClassName(c),f);
		}
		
		static protected function getDefaultBinding(c : Class) : stx.Option {
			return stx.framework._Injector.InjectorImpl.state[0].defaultBindings.get(Type.getClassName(c));
		}
		
		static protected function getSpecificBinding(extractor : Function,c : Class,specific : String) : stx.Option {
			{
				var _g : int = 0, _g1 : Array = stx.framework._Injector.InjectorImpl.state;
				while(_g < _g1.length) {
					var bindings : * = _g1[_g];
					++_g;
					var binding : Hash = extractor(bindings);
					var result : stx.Option = stx.Options.flatMap(stx.Options.toOption(binding.get(Type.getClassName(c))),function(h : Hash) : stx.Option {
						return stx.Options.toOption(h.get(specific));
					});
					if(!stx.Options.isEmpty(result)) return result;
				}
			}
			return stx.Option.None;
		}
		
		static protected function addSpecificBinding(bindings : Hash,c : Class,specific : String,f : Function) : void {
			var h : Hash = bindings.get(Type.getClassName(c));
			if(h == null) {
				h = new Hash();
				bindings.set(Type.getClassName(c),h);
			}
			h.set(specific,f);
		}
		
		static protected function classOf(pos : *) : String {
			return pos.className;
		}
		
		static protected function packageOf(pos : *) : String {
			return pos.className.substr(0,pos.className.lastIndexOf("."));
		}
		
		static protected function moduleOf(pos : *) : String {
			var className : String = stx.framework._Injector.InjectorImpl.classOf(pos);
			var packageName : String = stx.framework._Injector.InjectorImpl.packageOf(pos);
			var moduleName : String = packageName + "." + pos.fileName.substr(0,pos.fileName.lastIndexOf("."));
			return moduleName;
		}
		
		static protected function factoryFor(impl : Class) : Function {
			return function() : * {
				return Type.createInstance(impl,[]);
			}
		}
		
		static protected function bindingTypeDef(bindingType : stx.framework.BindingType) : stx.framework.BindingType {
			return stx.Options.getOrElseC(stx.Options.toOption(bindingType),stx.framework.BindingType.OneToMany);
		}
		
	}
}
