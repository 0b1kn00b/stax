package stx.math.geom {
	import stx.Ints;
	import stx.Entuple;
	import stx.Tuple2;
	public class Point2dIntExtensions {
		static public function minus(p1 : *,p2 : *) : * {
			return { dx : p1.x - p2.x, dy : p1.y - p2.y}
		}
		
		static public function plus(p : *,v : *) : * {
			return { x : p.x + v.dx, y : p.y + v.dy}
		}
		
		static public function map(p : *,f : Function,g : Function) : * {
			return { x : f(p.x), y : g(p.y)}
		}
		
		static public function toVector(p : *) : * {
			return { dx : p.x, dy : p.y}
		}
		
		static public function toFloat(p : *) : * {
			return { x : stx.Ints.toFloat(p.x), y : stx.Ints.toFloat(p.y)}
		}
		
		static public function toTuple(p : *) : stx.Tuple2 {
			return stx.Entuple.entuple(p.x,p.y);
		}
		
	}
}
