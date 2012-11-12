package stx.math.geom {
	import stx.Entuple;
	import stx.Tuple2;
	import stx.Floats;
	public class Vector2dFloatExtensions {
		static public function minus(v1 : *,v2 : *) : * {
			return { dx : v1.dx - v2.dx, dy : v1.dy - v2.dy}
		}
		
		static public function plus(v1 : *,v2 : *) : * {
			return { dx : v1.dx + v2.dx, dy : v1.dy + v2.dy}
		}
		
		static public function times(v : *,factor : Number) : * {
			return { dx : v.dx * factor, dy : v.dy * factor}
		}
		
		static public function dot(v1 : *,v2 : *) : Number {
			return v1.dx * v2.dx + v1.dy * v2.dy;
		}
		
		static public function map(v : *,f : Function,g : Function) : * {
			return { dx : f(v.dx), dy : g(v.dy)}
		}
		
		static public function toPoint(v : *) : * {
			return { x : v.dx, y : v.dy}
		}
		
		static public function toInt(v : *) : * {
			return { dx : stx.Floats.round(v.dx), dy : stx.Floats.round(v.dy)}
		}
		
		static public function toTuple(v : *) : stx.Tuple2 {
			return stx.Entuple.entuple(v.dx,v.dy);
		}
		
	}
}
