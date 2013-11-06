package stx.rtti;

import Type;

import haxe.rtti.CType;

import Stax.*;

import stx.Enums;
import stx.Reflects;

using stx.Compose;
using stx.Strings;
using stx.Tuples;
using stx.Option;
using Prelude;
using stx.Arrays;
using stx.Iterables;

class RTypes {
	static public function typetree(type:Class<Dynamic>):Option<TypeTree> {
		var rtti : String 	= untyped Reflect.field(type, "__rtti");
		var tn 							= (Type.getClassName(type));
		if(rtti == null){ return None; }
		var x 							= Xml.parse(rtti).firstElement();
		return Some(new haxe.rtti.XmlParser().processElement(x));
	}
}