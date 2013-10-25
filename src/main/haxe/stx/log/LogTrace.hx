package stx.log;

import haxe.PosInfos;

class LogTrace{
  public static dynamic function trace( v : Dynamic, ?infos : PosInfos ) : Void {
    #if flash
      #if (fdb || native_trace)
        var pstr = infos == null ? "(null)" : infos.fileName + ":" + infos.lineNumber;
        var str = flash.Boot.__string_rec(v, "");
        if( infos != null && infos.customParams != null ) for( v in infos.customParams ) str += "," + flash.Boot.__string_rec(v, "");
        untyped #if flash9 __global__["trace"] #else __trace__ #end(pstr+": "+str);
      #else
        untyped flash.Boot.__trace(v,infos);
      #end
    #elseif neko
      untyped {
        $print(infos.fileName + ":" + infos.lineNumber + ": ", v);
        if( infos.customParams != null ) for( v in infos.customParams ) $print(",", v);
        $print("\n");
      }
    #elseif js
      untyped js.Boot.__trace(v,infos);
    #elseif php
      if (infos!=null && infos.customParams!=null) {
        var extra:String = "";
        for( v in infos.customParams )
          extra += "," + v;
        untyped __call__('_hx_trace', v + extra, infos);
      }
      else
        untyped __call__('_hx_trace', v, infos);    
    #elseif cpp
      if (infos!=null && infos.customParams!=null) {
        var extra:String = "";
        for( v in infos.customParams )
          extra += "," + v;
        untyped __trace(v + extra,infos);
      }
      else
        untyped __trace(v,infos);
    #elseif (cs || java)
      var str:String = null;
      if (infos != null) {
        str = infos.fileName + ":" + infos.lineNumber + ": " + v;
        if (infos.customParams != null)
        {
          str += "," + infos.customParams.join(",");
        }
      } else {
        str = v;
      }
      #if cs
        untyped __cs__("System.Console.WriteLine(str)");
      #elseif java
        untyped __java__("java.lang.System.out.println(str)");
      #end
    #end
  }
}