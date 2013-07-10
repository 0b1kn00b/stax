package stx;

import haxe.CallStack;
import haxe.PosInfos;

import stx.StaxError;

using stx.Arrays;
using stx.Prelude;
using stx.Enums;
using stx.Compose;
using stx.Positions;
using stx.Functions;

class Error{
	static public function err(?cde:EnumValue){
		return new Error(cde);
	}
	static public inline function asError<E:Error>(e:E):Error{
		return e;
	}

	public var cde(default,null) 	: EnumValue;

	public function new(cde:EnumValue) {
		this.cde 				= cde;
	}
	public function msg():String{
		var prm = cde.params().foldl('',
			function(memo,next){
				return '$memo,${Std.string(next)}';
			}
		);
		return prm;
	}
	public function toString():String{
		var enm = cde.toEnum().key();
		var val = cde.value();
		return '$enm:$val:${msg()}';
	}
	public function equals(e:Error){
		return Enums.alike(cde,e.cde);
	}
	public function append(e:Error):Error{
		return err(switch ([cde,e.cde]) {
			case [ErrorStack(errs),ErrorStack(errs0)] 	: ErrorStack(errs.append(errs0));
			case [ErrorStack(errs),er] 									: ErrorStack(errs.add(err(er)));
			case [er,ErrorStack(errs)]									: ErrorStack([err(er)].append(errs));
			case [er0,er1] 															: ErrorStack([err(er0),err(er1)]);
		});
	}
}