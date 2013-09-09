package stx;

import haxe.CallStack;
import haxe.PosInfos;

import stx.plus.Show;

using stx.Options;
using stx.Eithers;
using stx.Arrays;
using stx.Prelude;
using stx.Enums;
using stx.Compose;
using stx.Positions;
using stx.Functions;

enum StaxFail{
  AbstractMethodFail(?pos:PosInfos);
  ArgumentFail(field:String,?pos:PosInfos);
  AssertionFail(is:String,?should:String,?pos:PosInfos);
  FailStack(arr:Array<Fail>);
  TypeFail(msg:String,?pos:PosInfos);
  NullReferenceFail(field:String,?pos:PosInfos);
  OutOfBoundsFail(?pos:PosInfos);
  NativeFail(err:Dynamic);
  FrameworkFail(flag:EnumValue,?pos:PosInfos);
  IllegalOperationFail(msg:String,?pos:PosInfos);
  InjectionFail(cls:Class<Dynamic>,?err:Fail);
  ConstructorFail(cls:Class<Dynamic>,?err:Fail);
}

class Fail{
	static public function fail(cde:EnumValue){
		return new Fail(cde);
	}
	static public inline function asFail<E:Fail>(e:E):Fail{
		return e;
	}

	public var cde(default,null) 	: EnumValue;

	public function new(cde:EnumValue) {
		//fixes for Dynamics in catch
		cde = (switch ((Type.typeof(cde))) {
					case TObject 										: NativeFail(cde);
					case TClass(c) if (c == String)	: NativeFail(cde);
					default 												: cde;
				});
		this.cde 				= cde;
	}
	public function msg():String{
		var prm = cde.params().foldl1(
			function(memo,next){
				return '${Show.getShowFor(memo)(memo)},${Show.getShowFor(next)(next)}';
			}
		);
		return prm;
	}
	public function toString():String{
		var enm = cde.toEnum().name();
		var val = cde == null ? 'none' : cde.constructor();
		var shw0 = Show.getShowFor(enm);
		var shw1 = Show.getShowFor(val);
		return '${shw0(enm)}:${shw1(val)}:"${msg()}"';
	}
	public function equals(e:Fail){
		return Enums.alike(cde,e.cde);
	}
	public function append(e:Fail):Fail{
		return fail(switch ([cde,e.cde]) {
			case [FailStack(errs),FailStack(errs0)] 	: FailStack(errs.append(errs0));
			case [FailStack(errs),er] 								: FailStack(errs.add(fail(er)));
			case [er,FailStack(errs)]									: FailStack([fail(er)].append(errs));
			case [er0,er1] 														: FailStack([fail(er0),fail(er1)]);
		});
	}
}