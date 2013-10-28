package stx.ioc;

import Stax.*;
import stx.Compare.*;

import haxe.PosInfos;

import haxe.ds.StringMap;

import stx.ioc.Injector.*;
import stx.ioc.Binder;

using stx.Option;
using stx.Types;
using stx.Arrays;
using stx.ValueTypes;

@doc("
  Represents a collection of interface -> instance bindings
")
interface Module{
  @doc("@see `stx.ioc.Scope`")
  public var scope(default,null) : Scope;
  @doc("Is interface `cls` bound in context `pos`")
  public function bound(cls:Class<Dynamic>,pos:PosInfos):Bool;
  @doc("Returns implementation of `cls`")
  public function injection<T>(cls:Class<T>):Null<T>;
}
@doc("Editable Module")
interface PublicModule extends Module{
  public function bind<T>(cls:Class<T>,imp:Binder<T>):Bool;
  public function unbind<T>(cls:Class<T>):Bool;
}
class CommonModule implements Module{
  public var scope(default,null)  : Scope;
  private var bindings            : Map<String,Binder<Dynamic>>;
  public function new(scope:Scope){
    this.bindings = new Map();
    this.scope    = nl().apply(scope) ? AnyScope : scope; 
    if(Type.getClass(this) != Injector){
      injector.add(this);
    }
  }
  public function bound(cls:Class<Dynamic>,pos:PosInfos):Bool{
    var key     = cls.name();
    var exists  = bindings.exists(key);
    var scoped  = (switch (scope) {
      case GlobalScope,AnyScope   : true;
      case PackageScope(path)     : pos.className.split('.').dropRight(1).join('.')   == path;
      case ClassScope(path)       : pos.className                                     == path;
    });
    //trace('in $scope $key $exists $scoped');
    return exists && scoped;
  }
  public function injection<T>(cls:Class<T>):T{
    var key = cls.name();
    injector.push(this);
    var o : Null<T> = option(bindings.get(key))
    .map(
      function(x){
        return switch (x) {
          case Constructor(type,func) : type.construct(ntnl().apply(func) ? func() : []);
          case Instance(instance)     : instance;
          case Provider(provider)     : provider.reply();
          case Factory(fn)            : fn();
        }
      }
    ).getOrElse(thunk(null));
    injector.pop();
    return o;
  }
}
class DefaultModule implements Module extends CommonModule{
  public function new(scp){
    super(scp);
  }
  private function bind<T>(cls:Class<T>,imp:Binder<Dynamic>):Bool{
    var key = cls.name();
    return if(bindings.exists(key)){
      false;
    }else{
      bindings.set(key,imp);
      true;
    }
  }
  private function unbind<T>(cls:Class<T>):Bool{
    var key = cls.name();
    var o   = bindings.get(key);
    return o == null ? false : { bindings.remove(key); true; }
  }
}
class DefaultPublicModule implements PublicModule extends CommonModule{
  public function bind<T>(cls:Class<T>,imp:Binder<Dynamic>):Bool{
    var key = cls.name();
    return if(bindings.exists(key)){
      false;
    }else{
      bindings.set(key,imp);
      true;
    }
  }
  public function unbind<T>(cls:Class<T>):Bool{
    var key = cls.name();
    var o = bindings.get(key);
    return o == null ? false : { bindings.remove(key); true; }
  } 
}