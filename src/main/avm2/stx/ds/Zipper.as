package stx.ds {
	import stx.Arrays;
	import flash.Boot;
	public class Zipper {
		public function Zipper(v : * = null,c : * = null,p : Array = null) : void { if( !flash.Boot.skip_constructor ) {
			this.data = v;
			this.path = p;
			this.current = ((p == null)?v:c);
			this.path = ((this.path == null)?[]:this.path);
		}}
		
		public function get() : * {
			return this.current;
		}
		
		public function up() : stx.ds.Zipper {
			var s : Array = stx.Arrays.take(this.path,this.path.length - 2);
			var p : * = Prelude.SArrays.foldl(s,this.data,function(value : *,func : Function) : * {
				return func(value);
			});
			return new stx.ds.Zipper(this.data,p,s);
		}
		
		public function flatMap() : void {
		}
		
		public function map(f : Function) : stx.ds.Zipper {
			var o : * = f(this.current);
			return new stx.ds.Zipper(this.data,o,stx.Arrays.append(this.path,f));
		}
		
		public function root() : stx.ds.Zipper {
			return new stx.ds.Zipper(this.data);
		}
		
		public var current : *;
		protected var path : Array;
		protected var data : *;
		static public function zipper(v : *) : stx.ds.Zipper {
			return new stx.ds.Zipper(v);
		}
		
	}
}
