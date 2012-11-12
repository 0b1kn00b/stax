package stx {
	import stx.StateRef;
	public class StateRefs {
		static public function modifier(f : Function,sr : stx.StateRef) : Function {
			return sr.modify(f);
		}
		
		static public function reader(sr : stx.StateRef) : Function {
			return sr.read();
		}
		
	}
}
