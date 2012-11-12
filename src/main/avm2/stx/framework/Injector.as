package stx.framework {
	import stx.framework._Injector.InjectorImpl;
	public class Injector {
		static public function inject(interf : Class,pos : * = null) : * {
			return stx.framework._Injector.InjectorImpl.inject(interf,pos);
		}
		
		static public function enter(f : Function) : * {
			return stx.framework._Injector.InjectorImpl.enter(f);
		}
		
		static public function forever(f : Function) : * {
			return stx.framework._Injector.InjectorImpl.forever(f);
		}
		
	}
}
