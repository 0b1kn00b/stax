package stx.macro;

using stx.Prelude;
using stx.Arrays;
using stx.Compose;

#if macro
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;

import tink.macro.tools.Printer;
import tink.macro.tools.ExprTools;
import tink.macro.tools.TypeTools;
#end

class UnitMacro{
  macro static public function build():Array<Field>{
    var local   = Context.getLocalClass().get();
    var fields  = Context.getBuildFields();
    var params  = local.params.map(
      function(x:{ t : haxe.macro.Type, name : String }):TypeParamDecl{
        return {
          name : x.name
        };
      }
    );
    var field   = fields.find(
      function(x){
        return x.name == 'new';
      }
    );
    field.foreach(
      function(x){
        switch (x.kind) {
          case FFun(f) if (f.args.length == 0 || (f.args.length == 1 && Options.create(f.args[0]).map(function(x) return x.opt).getOrElseC(false))) :
            var arg   = f.args[0];
            var expr  = Context.parse('{return new ${local.name}(${arg.name});}',Context.currentPos());
            var fld = {
              name    : 'unit',
              access  : [APublic,AStatic],
              kind : FFun({
                args    : f.args,
                ret     : null,//TypeTools.toComplex(local,params),
                expr    : expr,
                params  : params,
              }),
              pos : Context.currentPos()
            };
            fields.push(fld);
          default :
        }
      }
    );
    return fields;
  }
}
@:autoBuild(stx.macro.UnitMacro.build()) interface Unit{

}