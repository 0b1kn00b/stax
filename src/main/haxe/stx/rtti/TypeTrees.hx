package stx.rtti;

import Prelude;

import haxe.rtti.CType;

import stx.Option;

class TypeTrees{
  static public inline function classdef(t:TypeTree):Option<Classdef>{
    return switch (t) {
      case TClassdecl(c)  : Some(c);
      default             : None;
    }
  }
}