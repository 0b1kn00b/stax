package stx {
	public class Filters {
		static public function filterIsNotNull(iter : *) : * {
			return Prelude.SIterables.filter(iter,function(e : *) : Boolean {
				return e != null;
			});
		}
		
		static public function filterIsNull(iter : *) : * {
			return Prelude.SIterables.filter(iter,function(e : *) : Boolean {
				return e == null;
			});
		}
		
	}
}
