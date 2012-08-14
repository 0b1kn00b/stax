import stx.Prelude;

#if dev
typedef Accessors           = stx.Accessors;
#end
typedef Arrays              = stx.Arrays;
typedef Bools               = stx.Bools;
typedef Dates               = stx.Dates;
typedef Dynamics            = stx.Dynamics;
typedef Eithers             = stx.Eithers;
typedef Enums               = stx.Enums;
typedef Filters             = stx.Filters;
typedef CodeBlocks          = stx.Functions.CodeBlocks;
typedef Functions0          = stx.Functions.Functions0;
typedef Functions1          = stx.Functions.Functions1;
typedef Functions2          = stx.Functions.Functions2;
typedef Functions3          = stx.Functions.Functions3;
typedef Functions4          = stx.Functions.Functions4;
typedef Functions5          = stx.Functions.Functions5;
typedef Functions6          = stx.Functions.Functions6;
typedef Future<T>           = stx.Future<T>;
typedef Hashes              = stx.Hashes;
typedef Iterables           = stx.Iterables;
typedef Iterators           = stx.Iterators;
typedef Log                 = stx.Log;
typedef Maths               = stx.Maths;
typedef Objects             = stx.Objects;
typedef Options             = stx.Options;
typedef Predicates          = stx.Predicates;
typedef Strings             = stx.Strings;
typedef Tuples              = stx.Tuples;
typedef Tuple2<A,B>         = stx.Tuples.Tuple2<A,B>;
typedef Tuple3<A,B,C>       = stx.Tuples.Tuple3<A,B,C>;
typedef Tuple4<A,B,C,D>     = stx.Tuples.Tuple4<A,B,C,D>;
typedef Tuple5<A,B,C,D,E>   = stx.Tuples.Tuple5<A,B,C,D,E>;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;

using SCore;

class Stx {

  @:macro static public function tup(ethis:Expr,e:Array<Expr>):Expr{
    var fst : Expr = e[0];
    var snd : Expr = e[1];
    var thd : Expr = e[2];
    var frt : Expr = e[3];
    var fth : Expr = e[4];

    var o = switch(e.length){
        case 2 : macro new stx.Tuples.Tuple2($fst,$snd);
        case 3 : macro new stx.Tuples.Tuple3($fst,$snd,$thd);
        case 4 : macro new stx.Tuples.Tuple4($fst,$snd,$thd,$frt);
        case 5 : macro new stx.Tuples.Tuple5($fst,$snd,$thd,$frt,$fth);
      }
    return o;
  }
  @:macro static public function def(ethis:Expr,e:Array<Expr>):Expr{
    return { expr : EFunction( null, mk_fun(mk_args(e[0]), e[1]) ) , pos : Context.currentPos() };
  }
  static private function mk_fun(args:Array<FunctionArg>,e:Expr):haxe.macro.Function{
    return 
      {
        args    : args,
        ret     : null,
        expr    : e,
        params  : gt_prms(e)
      }
  }
  static private function gt_prms(e:Expr){
    return [];
  }
  static private function mk_args(e:Expr):Array<FunctionArg>{
    return 
      switch (e.expr) {
        case EArrayDecl(values) :
          values.flatMap(
            function(x:Expr){
              return  
                switch (x.expr) {
                  case EConst(c)          : 
                    switch (c) {
                      case CIdent(s)      : [mk_fn_arg(s)];
                      default             : [];
                    }
                  case EVars(vars)        : //Array<{ name : String, type : Null<ComplexType>, expr : Null<Expr> }> );
                    vars.map(inline function(x) return mk_fn_arg(x.name,x.type));
                  default                 :   [];
                }
            }
          );
        case EConst(c)          :
          switch (c) {
            case CIdent(s)  : [mk_fn_arg(s)];
            default         : [];
          }
        case EVars(vars)        :
          vars.map( inline function(x) return mk_fn_arg(x.name,x.type) );
        default                 : [];
      }
  }
  static private function mk_fn_arg(name:String,?t:ComplexType):FunctionArg {
    return 
      {
          name  : name
        , opt   : false
        , type  : t
        , value : null
      }
  }
  @:macro static public function enter(e:Expr):Expr{
    return 
      {
        expr :
          EBlock(
            [
                (macro var self = Stx)
              , e
            ]
          )
        , 
        pos : Context.currentPos()
      };
  }
  public function new(){

  }
}