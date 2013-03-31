package stx.framework;

using stx.Tuples;
using stx.Prelude;

import haxe.PosInfos;


 
import stx.Maybes; 
using stx.Maybes; 
using stx.Functions;
using stx.Dynamics;


enum BindingType {
  OneToOne;   // Every call to the injector will create a new instance
  OneToMany;  // Every call to the injector will return the same singleton instance
}

typedef Binder<T, S> = {
  /** Binds the interface to the specified implementation class.
   */
  function bind(interf: Class<T>, c: Class<Dynamic>, ?b: BindingType): S;

  /** Binds the interface to the specified factory. The factory will 
   * be used for creating instances of the specified type.
   */  
  function bindF(interf: Class<T>, f: Void -> T, ?b: BindingType): S;
  
}

typedef Bindable<T> = {
 bindToF : Class<T> -> (Void -> T) -> BindingType -> Void , 
 bindTo : Class<T> -> Class<Dynamic> -> BindingType -> Void 
}	

/** An interface used to configure dependencies. */
interface InjectorConfig {
  /** Binds the interface to the specified implementation class.
   */
  public function bind<T>(interf: Class<T>, c: Class<Dynamic>, ?b: BindingType): InjectorConfig;
  
  /** Binds the interface to the specified factory. The factory will 
   * be used for creating instances of the specified type.
   */
  public function bindF<T>(interf: Class<T>, f: Void -> T, ?b: BindingType): InjectorConfig;
  
  /** Retrieves a binder that operates only in the scope of the specified class. 
   * This can be used to provide fine-grained control over implementations in
   * the scope of a particular class.
   */
  public function inClass<T>(c: Class<Dynamic>): Binder<T, InjectorConfig>;

  /** Retrieves a binder that operates only in the scope of the specified module. 
   * This can be used to provide fine-grained control over implementations in
   * the scope of a particular module.
   */
  public function inModule<T>(m: String): Binder<T, InjectorConfig>;
  
  /** Retrieves a binder that operates only in the scope of the specified package. 
   * This can be used to provide fine-grained control over implementations in
   * the scope of a particular package.
   */
  public function inPackage<T>(p: String): Binder<T, InjectorConfig>;
}

/** Featherweight injection library.
 * <pre>
 * import stx.framework.Injector;
 *
 * ...
 *
 * Injector.enter(
 *  function(config) {
 *    config.bind(Clock, SystemClock, OneToMany);
 *    config.inClass(ClockConsumer).bind(Clock, MockClock);
 *
 *    myApp.run();
 *
 *    return Unit;
 *  }
 * );
 * </pre>
 * Interfaces can specify a default implementation by adding the following metadata to the interface itself:
 * <pre>
 * @DefaultImplementation("full.path.to.ImplementationClass")
 * </pre>
 * By default the BindingType is OneToMany but you can specify the desired type as the second parameter:
 * <pre>
 * @DefaultImplementation("full.path.to.ImplementationClass", "OneToOne")
 * </pre>
 * Note that due to limitations in the metadata system both the arguments must be passed as String values.
 */
class Injector {
  /** Injects an implementation of the specified interface. The implementation 
   * will be chosen based on the current bindings.
   */
  public static function inject<T>(interf: Class<T>, ?pos: PosInfos): T {
    return InjectorImpl.inject(interf, pos);
  }
  
  /** The entry point for a module. This is how an application specifies the 
   * configuration.
   *
   * @param f The module, which should specify the configuration and run the
   *          associated code.
   */
  public static function enter<T>(f: InjectorConfig -> T): T {
    return InjectorImpl.enter(f);
  }
  
  public static function forever<T>(f: InjectorConfig -> T): T {
    return InjectorImpl.forever(f);
  }
}

private typedef Bindings = {
  defaultBindings: Map<String,Maybe<Void -> Dynamic>>,
  globalBindings:  Map<String,Void -> Dynamic>,
  packageBindings: Map<String,Map<String,Void -> Dynamic>>,
  moduleBindings:  Map<String,Map<String,Void -> Dynamic>>,
  classBindings:   Map<String,Map<String,Void -> Dynamic>>
}

// Exists to workaround lack of "package" or "module" access specifiers:
private class InjectorImpl {
  

  static var state(get_state,null): Array<Bindings>;
  static public function get_state(){
    return (state == null) ?  state = [] : state;
  }
  static var classBindingsExtractor = function(b: Bindings) { return b.classBindings; }
  static var moduleBindingsExtractor = function(b: Bindings) { return b.moduleBindings; }
  static var packageBindingsExtractor = function(b: Bindings) { return b.packageBindings; }

  public static function inject<T>(interf: Class<T>, ?pos: PosInfos): T {
    var binding = getMostSpecificBinding(interf, pos);
  
    var factory = binding.getOrElse(Prelude.error().lazy('No binding defined for ' + Type.getClassName(interf)));
  
    return factory();
  }
  
  public static function forever<T>(f: InjectorConfig -> T): T {
    state.unshift({
      defaultBindings: new Map(),
      globalBindings:  new Map(),
      packageBindings: new Map(),
      moduleBindings:  new Map(),
      classBindings:   new Map()
    });
    
    return f(new InjectorConfigImpl());
  }
  
  public static function enter<T>(f: InjectorConfig -> T): T {
    state.unshift({
      defaultBindings: new Map(),
      globalBindings:  new Map(),
      packageBindings: new Map(),
      moduleBindings:  new Map(),
      classBindings:   new Map()
    });
    
    var result: T = null;
    
    try {
      result = f(new InjectorConfigImpl());
      
      state.shift();
    }
    catch (e: Dynamic) {
      state.shift();
      
      throw e;
    }
    
    return result;
  }

  /** Globally binds the interface to the specified implementation.
   */
  public static function bindTo<T, S>(interf: Class<T>, impl: Class<S>, ?bindingType: BindingType):Void {
    return globally().bindTo(interf, impl, bindingType);
  }

  /** Globally binds the interface to the specified factory.
   */
  public static function bindToF<T>(interf: Class<T>, f: Void -> T, bindingType: BindingType):Void {
    return globally().bindToF(interf, f, bindingType);
  }

  public static function globally<T>():Bindable<T> {
    var internalBind = function(interf: Class<T>, f: Void -> T, bindingType: BindingType) {
      switch (bindingTypeDef(bindingType)) {
        case OneToOne:
          addGlobalBinding(interf, f);

        case OneToMany:
          addGlobalBinding(interf, f.memoize());
      }
    }
  
    return {
      bindToF: internalBind,
    
      bindTo: function(interf: Class<T>, impl: Class<Dynamic>, bindingType: BindingType) {
        internalBind(interf, factoryFor(impl), bindingType);
      },
    }
  }

  public static function inClass<T>(c: Class<Dynamic>) {
    return {
      bindToF: function(interf: Class<T>, f: Void -> T, ?bindingType: BindingType):Void {
        bindForSpecificF(classBindingsExtractor, interf, Type.getClassName(c), f, bindingType);
      },
    
      bindTo: function(interf: Class<T>, impl: Class<Dynamic>, ?bindingType: BindingType):Void {
        bindForSpecificF(classBindingsExtractor, interf, Type.getClassName(c), factoryFor(impl), bindingType);
      }
    }
  }

  public static function inModule<T>(moduleName: String):Bindable<T> {
    return {
      bindToF: function(interf: Class<T>, f: Void -> T, bindingType: BindingType):Void {
        bindForSpecificF(moduleBindingsExtractor, interf, moduleName, f, bindingType);
      },
    
      bindTo: function(interf: Class<T>, impl: Class<Dynamic>, bindingType: BindingType):Void {
        bindForSpecificF(moduleBindingsExtractor, interf, moduleName, factoryFor(impl), bindingType);
      }
    }
  }

  public static function inPackage<T>(packageName: String):Bindable<T> {
    return {
      bindToF: function(interf: Class<T>, f: Void -> T, bindingType: BindingType) {
        bindForSpecificF(packageBindingsExtractor, interf, packageName, f, bindingType);
      },
    
      bindTo: function(interf: Class<T>, impl: Class<Dynamic>, bindingType: BindingType) {
        bindForSpecificF(packageBindingsExtractor, interf, packageName, factoryFor(impl), bindingType);
      }
    }
  }

  private static function bindForSpecificF<T>(extractor: Bindings -> Map<String,Map<String,Void -> Dynamic>>, interf: Class<T>, specific: String, f: Void -> T, bindingType: BindingType):Void {
    switch (bindingTypeDef(bindingType)) {
      case OneToOne:
        addSpecificBinding(extractor(state[0]), interf, specific, f);
    
      case OneToMany:
        addSpecificBinding(extractor(state[0]), interf, specific, f.memoize());
    }
  }

  private static function getMostSpecificBinding(c: Class<Dynamic>, pos: PosInfos): Maybe<Void -> Dynamic> {
    var className   = classOf(pos);
    var moduleName  = moduleOf(pos);
    var packageName = packageOf(pos);
  
    return getClassBinding(c, className).orElse(getModuleBinding.lazy(c, moduleName)).orElse(getPackageBinding.lazy(c, packageName)).orElse(getGlobalBinding.lazy(c)).orElse(getDefaultImplementationBinding.lazy(c));
  }
  
  private static function getDefaultImplementationBinding(c: Class<Dynamic>): Maybe<Void -> Dynamic> {
    if(existsDefaultBinding(c))
      return getDefaultBinding(c);
    var f = Maybes.create(haxe.rtti.Meta.getType(c))
      .flatMap(function(m : Dynamic) { 
        return Maybes.create((Reflect.hasField(m, "DefaultImplementation") ? Reflect.field(m, "DefaultImplementation") : null)); })
      .flatMap(function(p) {
        var cls = null;
        return cast if(null == p || null == p[0] || null == (cls = Type.resolveClass(p[0]))) None else Some(Tuples.t2(cls, null != p[1] ? Type.createEnum(BindingType, p[1], []) : null)); })
      .flatMap(function(p : Tuple2<Class<Dynamic>, BindingType>) {
        return switch(bindingTypeDef(p.snd())) {
          case OneToOne:
            factoryFor(p.fst()).toMaybe();
          case OneToMany:
            factoryFor(p.fst()).memoize().toMaybe();
        };
      });
    try{
      addDefaultBinding(c, f);  
    }catch(e:Dynamic){
      throw 'No Injector context, use stx.framework.Injector.enter';
    }
    
    return f;    
  }

  private static function getGlobalBinding(c: Class<Dynamic>): Maybe<Void -> Dynamic> {
    var className = Type.getClassName(c);
  
    return state.foldl(None, function(a: Maybe<Void -> Dynamic>, b: Bindings): Maybe<Void -> Dynamic> {
      return a.orElseC(b.globalBindings.get(className).toMaybe());
    });
  }

  private static function getClassBinding(c: Class<Dynamic>, className: String): Maybe<Void -> Dynamic> {
    return getSpecificBinding(classBindingsExtractor, c, className);
  }

  private static function getModuleBinding(c: Class<Dynamic>, moduleName: String): Maybe<Void -> Dynamic> {
    return getSpecificBinding(moduleBindingsExtractor, c, moduleName);
  }

  private static function getPackageBinding(c: Class<Dynamic>, packageName: String): Maybe<Void -> Dynamic> {
    return getSpecificBinding(packageBindingsExtractor, c, packageName);
  }

  private static function addGlobalBinding(c: Class<Dynamic>, f: Void -> Dynamic):Void {
    state[0].globalBindings.set(Type.getClassName(c), f);
  }
  
  private static function existsDefaultBinding(c : Class<Dynamic>):Bool {
    return state[0] == null ? false : state[0].defaultBindings.exists(Type.getClassName(c));
  }
  
  private static function addDefaultBinding(c : Class<Dynamic>, f: Maybe<Void -> Dynamic>):Void {
    state[0].defaultBindings.set(Type.getClassName(c), f);
  }
  
  private static function getDefaultBinding(c : Class<Dynamic>) : Maybe<Void->Dynamic> {
    return state[0].defaultBindings.get(Type.getClassName(c));
  }

  private static function getSpecificBinding(extractor: Bindings->Map<String, Map<String,Void->Dynamic>> , c: Class<Dynamic>, specific: String): Maybe < Void -> Dynamic > {
		//trace(state);
    for (bindings in state) {
      var binding = extractor(bindings);
      
      var result = binding.get(Type.getClassName(c)).toMaybe().flatMap(function(h) return h.get(specific).toMaybe());
    
      if (!result.isEmpty()) {
        return result;
      }
    }   
  
    return None;
  }

  private static function addSpecificBinding(bindings: Map<String,Map<String,Void -> Dynamic>>, c: Class<Dynamic>, specific: String, f: Void -> Dynamic) {
    var h = bindings.get(Type.getClassName(c));
  
    if (h == null) {
      h = new Map();
    
      bindings.set(Type.getClassName(c), h);
    }
  
    h.set(specific, f);
  }

  private static function classOf(pos: PosInfos) {
    return pos.className;
  }

  private static function packageOf(pos: PosInfos) {
    return pos.className.substr(0, pos.className.lastIndexOf('.'));
  }

  private static function moduleOf(pos: PosInfos) {
    var className   = classOf(pos);
    var packageName = packageOf(pos);
    var moduleName  = packageName + '.' + pos.fileName.substr(0, pos.fileName.lastIndexOf('.'));
  
    return moduleName;
  }

  private static function factoryFor<T>(impl: Class<T>): Void -> T {
    return function() { 
      return Type.createInstance(impl, []);
    }
  }

  private static function bindingTypeDef(bindingType: BindingType) {
    return bindingType.toMaybe().getOrElseC(OneToMany);
  }
}

// Exists to workaround lack of inner classes:
private class InjectorConfigImpl implements InjectorConfig {
  public function new() {
  }
  
  public function bind<T>(interf: Class<T>, impl: Class<Dynamic>, ?b: BindingType): InjectorConfig {
    InjectorImpl.globally().bindTo(interf, impl, b);
    
    return this;
  }
      
  public function bindF<T>(interf: Class<T>, f: Void -> T, ?b: BindingType): InjectorConfig {
    InjectorImpl.globally().bindToF(interf, f, b);
        
    return this;
  }
  
  public function inClass<T>(c: Class<Dynamic>): Binder<T, InjectorConfig> {
    var self = this;
    
    return {
      bind: function(interf: Class<T>, impl: Class<Dynamic>, ?b: BindingType): InjectorConfig {
        InjectorImpl.inClass(c).bindTo(interf, impl, b);
        
        return self;
      },
      
      bindF: function(interf: Class<T>, f: Void -> T, ?b: BindingType): InjectorConfig {
        InjectorImpl.inClass(c).bindToF(interf, f, b);
        
        return self;
      }
    }
  }
  
  public function inPackage<T>(p: String): Binder<T, InjectorConfig> {
    var self = this;
    
    return {
      bind: function(interf: Class<T>, impl: Class<Dynamic>, ?b: BindingType): InjectorConfig {
        InjectorImpl.inPackage(p).bindTo(interf, impl, b);
        
        return self;
      },
      
      bindF: function(interf: Class<T>, f: Void -> T, ?b: BindingType): InjectorConfig {
        InjectorImpl.inPackage(p).bindToF(interf, f, b);
        
        return self;
      }
    }
  }
  
  public function inModule<T>(m: String): Binder<T, InjectorConfig> {
    var self = this;
    
    return {
      bind: function(interf: Class<T>, impl: Class<Dynamic>, ?b: BindingType): InjectorConfig {
        InjectorImpl.inModule(m).bindTo(interf, impl, b);
        
        return self;
      },
      
      bindF: function(interf: Class<T>, f: Void -> T, ?b: BindingType): InjectorConfig {
        InjectorImpl.inModule(m).bindToF(interf, f, b);
        
        return self;
      }
    }
  }
}