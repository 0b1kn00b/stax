package  {
	import flash.utils.Dictionary;
	import flash.Boot;
	public class IntHash {
		public function IntHash() : void { if( !flash.Boot.skip_constructor ) {
			this.h = new flash.utils.Dictionary();
		}}
		
		public function toString() : String {
			var s : StringBuf = new StringBuf();
			s.add("{");
			var it : * = this.keys();
			{ var $it : * = it;
			while( $it.hasNext() ) { var i : int = $it.next();
			{
				s.add(i);
				s.add(" => ");
				s.add(Std.string(this.get(i)));
				if(it.hasNext()) s.add(", ");
			}
			}}
			s.add("}");
			return s.toString();
		}
		
		public function iterator() : * {
			return { ref : this.h, it : this.keys(), hasNext : function() : * {
				return this.it.hasNext();
			}, next : function() : * {
				var i : int = this.it.next();
				return this.ref[i];
			}}
		}
		
		public function keys() : * {
			return (function($this:IntHash) : * {
				var $r : *;
				$r = new Array();
				for(var $k2 : String in $this.h) $r.push($k2);
				return $r;
			}(this)).iterator();
		}
		
		public function remove(key : int) : Boolean {
			if(!this.h.hasOwnProperty(key)) return false;
			delete(this.h[key]);
			return true;
		}
		
		public function exists(key : int) : Boolean {
			return this.h.hasOwnProperty(key);
		}
		
		public function get(key : int) : * {
			return this.h[key];
		}
		
		public function set(key : int,value : *) : void {
			this.h[key] = value;
		}
		
		protected var h : flash.utils.Dictionary;
	}
}
