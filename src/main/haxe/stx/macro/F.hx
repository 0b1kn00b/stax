package stx.macro;

using Lambda;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;

class F{
  private static function flatMap<A,B>(a:Array<A>,fn:A->Array<B>){
    var o = [];
     for(e in a){
      o = o.concat(fn(e));
     }
    return o;
  }
  /**
    Short form function
  */
  @:noUsing
  @:macro static public function n(e:Array<Expr>):Expr{
    return { expr : EFunction( null, mk_fun(mk_args(e[0]), e[1]) ) , pos : Context.currentPos() };
  }
  /**
    Partial Application.
  
  @:macro static public function p(fn:Expre:Array<Expr>):Expr{

  }
  */
  static public function mk_fun(args:Array<FunctionArg>,e:Expr):haxe.macro.Function{
    return 
      {
        args    : args,
        ret     : null,
        expr    : e,
        params  : gt_prms(e)
      }
  }
  static public function gt_prms(e:Expr){
    return [];
  }
  static public function mk_args(e:Expr):Array<FunctionArg>{
    return 
      switch (e.expr) {
        case EArrayDecl(values) :
          flatMap(values,
            function(x:Expr){
              return  
                switch (x.expr) {
                  case EConst(c)          : 
                    switch (c) {
                      case CIdent(s)      : [mk_fn_arg(s)];
                      default             : [];
                    }
                  case EVars(vars)        : //Array<{ name : String, type : Null<ComplexType>, expr : Null<Expr> }> );
                    vars.map(function(x) return mk_fn_arg(x.name,x.type)).array();
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
          vars.map( function(x) return mk_fn_arg(x.name,x.type) ).array();
        default                 : [];
      }
  }
  static public function mk_fn_arg(name:String,?t:ComplexType):FunctionArg {
    return 
      {
          name  : name
        , opt   : false
        , type  : t
        , value : null
      }
  }
}