package stx;

using stx.Arrays;

import haxe.CallStack;

class CallStacks{
  static public function toString(v:StackItem){
    function step(v:StackItem){
      if(v == null){ return '';};
      return switch (v) {
        case CFunction                    : '(function)';
        case Module( m )                  : '($m)';
        case FilePos(s , file, line)      : 
          var nm = file.split("\\").last();
          '${step(s)}($nm:$line)';
        case Method(classname, method)    : '($classname#$method)';
        case LocalFunction( v )           : '(local:$v)';
      }
    }
    return step(v);
  }  
}