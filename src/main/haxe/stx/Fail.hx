package stx;

import haxe.CallStack;
import haxe.PosInfos;

import stx.Show;

using stx.Option;
using stx.Either;
using stx.Arrays;
using Prelude;
using stx.Enums;
using stx.Compose;
using stx.Positions;
using stx.Functions;

@doc("Stax's error class, is used to allow typed `try...catch` declarations. Fails can be accumulated through the `append` function.")
class Fail{
  @doc("Transforms any `EnumValue` into a Fail")
	@:noUsing static public function fail(cde:EnumValue,?pos){
		return new Fail(cde,pos);
	}
	public var cde(default,null) 				: EnumValue;
	private var pos(default,null) 			: PosInfos;
	private var stack(default,null) 		: Array<StackItem>;

	public function new(cde:EnumValue,?pos) {
		this.pos = pos;
		//fixes for Dynamics in catch
		cde = (switch ((Type.typeof(cde))) {
					case TObject 										: NativeError(cde);
					case TClass(c) if (c == String)	: NativeError(cde);
					default 												: cde;
				});
		this.cde 				= cde;
		this.stack 			= CallStack.callStack();
	}
  @doc('returns the string representation of the parameters of the wrapped enum')
	public function msg():String{
		var prm = cde.params().foldLeft1(
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
			case [ErrorStack(errs),ErrorStack(errs0)] 	: ErrorStack(errs.append(errs0));
			case [ErrorStack(errs),er] 									: ErrorStack(errs.add(fail(er)));
			case [er,ErrorStack(errs)]									: ErrorStack([fail(er)].append(errs));
			case [er0,er1] 															: ErrorStack([fail(er0),fail(er1)]);
		});
	}
}