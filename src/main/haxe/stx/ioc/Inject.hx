package stx.ioc;

import haxe.PosInfos;

import Prelude;
import Stax.*;

import stx.Fail;

using stx.Types;
using stx.Option;


import stx.ioc.Injector.*;

class Inject{
  /*
    Injection algorithm.
    1) check the scopes
      i)    AnyScope
      ii)   ClassScope
      iii)  PackageScope
      iii)  GlobalScope
    2) wig out.
  */
  @:bug('#0b1kn00b: Javascript will happily build an interface, returning what looks like an empty object, so no default create atm.')
  @:noUsing static public function inject<T>(cls:Class<T>,?pos:PosInfos):T{
    var inj = injector();
    return option(inj.cursor)
      .flatMap(
        function(x){
          return option(x.injection(cls));
        }
      ).orElse(
        function(){
          return option(inj.locate(cls,pos)).flatMap(
            function(x){
              return option(x.injection(cls));
            }
          );
        }
      ).valOrTry(
        function(){
          except()(MatchError(cls));
          return null;
        }
      );
  }
  @:noUsing static public function injector(){
    return Injector.injector;
  }
}