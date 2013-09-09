package stx.ioc;

import Stax.*;
import stx.Compare.*;

import hx.ds.MultiMap;

import stx.Compare.*;

using stx.Options;
using stx.Iterables;
using stx.Iterators;
using stx.Arrays;
using stx.plus.Order;
using stx.ValueTypes;
using stx.Types;

import stx.ioc.Module;
using stx.ioc.Scope;

import haxe.PosInfos;

/**
  Either bind globally through Injector, use arbitrary modules (just construct and they are added), or 
  use the class / package mechanisms through inPackage / inClass.
  seek order
  1) Any
  2) Class
  3) Package
  4) Global
*/
@:todo('#0b1kn00b: Resolve ambiguities with nested packages and the any scope, figure out if the scope stack is of any use')
@:final class Injector extends DefaultPublicModule{
  
  @:isVar public static var injector(get,null):Injector;
  @:noUsing static public function get_injector():Injector{
    return nl().apply(injector) ? injector = new Injector() : injector;
  }
  private function new(){
    super(GlobalScope);
    this.modules  = new MultiMap();
    this.scopes   = [];
  }
  private var scopes    : Array<Module>;
  private var modules   : MultiMap<Scope,Module>;

  public var cursor     : Module;

  /**
    Adds a module to the Injector, called automatically by DefaultModule
  */
  public function add(m:Module){
    modules.set(m.scope,m);
  }
  /**
    Removes a module from Injector
  */
  public function rem(m:Module){
    modules.rem(m);
  }
  /**
    Pushes selected module to the scopes stack
  */
  public function push(m:Module){
    cursor = m;
    scopes.push(m);
  }
  /**
    Removes a module from the scopes stack.
  */
  public function pop(){
    scopes.pop();
    cursor = scopes[0];
  }
  /**
    Locates the Module which holds a binding for cls.
  */
  public function locate<T>(cls:Class<T>,pos:PosInfos):Null<Module>{
    modules.sortOnKeyWith(Scopes.compareLevel);

    var ms = ArrayOrder.sortWith(
    modules.vals().toArray().filter(
      function(x){
        return (ntnl().apply(x) && x.bound(cls,pos));
      }
    ),
      function(x,y){
        return Scopes.compareLevel(x.scope,y.scope);
      }
    );

    //trace(ms);

    return nl().apply(ms[0]) ? this : ms[0];
  }
  /**
    Returns module for the package of `cls`
  */
  public function inPackage<T>(cls:Class<T>):PublicModule{
    var key = PackageScope(cls.pack());
    return if(modules.has(key)){
      cast modules.get(key).search(
        function(x:Module){
          return eq(x.scope).apply(key);
        }
      ).getOrElse(thunk(null));
    }else{
      new DefaultPublicModule(key);
    }
  }
  /**
    Returns module for `cls`
  */
  public function inClass<T>(cls:Class<T>):PublicModule{
    var key = ClassScope(cls.name());
    return if(modules.has(key)){
      cast option(modules.get(key)).flatMap(
        function(x){
          return x.search(
            function(x:Module){
              return eq(x.scope).apply(key);
            }
          );
        }
      ).getOrElse(thunk(null));
    }else{
      new DefaultPublicModule(key);
    }
  }
  /**
    Returns whether `cls` is bound in GlobalScope
  */
  override public function bound(cls:Class<Dynamic>,pos:PosInfos):Bool{
    return bindings.exists(cls.name());
  }
}