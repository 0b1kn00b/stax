package haxe.unit;

import stx.plus.Equal;

import Prelude;
import haxe.PosInfos;

class TestCases{
  static public function isEqualWith<T>(t:TestCase,should:T,is:T,with:Eq<T>,?pos:PosInfos){
    return t.assertTrue(with(should,is),pos);
  }
  static public function isEqual<T>(t:TestCase,should:T,is:T,?pos:PosInfos){
    return isEqualWith(t,should,is,Equal.getEqualFor(should));
  }
}