package  {
	public class IntIters {
		static public function to(start : int,end : int) : * {
			return { iterator : function() : * {
				var cur : int = start;
				return { hasNext : function() : Boolean {
					return cur <= end;
				}, next : function() : int {
					var next : int = cur;
					++cur;
					return next;
				}}
			}}
		}
		
		static public function until(start : int,end : int) : * {
			return IntIters.to(start,end - 1);
		}
		
	}
}
