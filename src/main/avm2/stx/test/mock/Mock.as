package stx.test.mock {
	import stx.ds.Map;
	import flash.Boot;
	public class Mock {
		public function Mock(c : Class = null) : void { if( !flash.Boot.skip_constructor ) {
			this._expects = stx.ds.Map.create();
			this._target = Type.createEmptyInstance(c);
		}}
		
		protected function internal_remove(name : String) : void {
			var array : Array = this._expects.getOrElseC(name,[]);
			array.shift();
			if(array.length > 0) Reflect.setField(this,name,array[0]);
		}
		
		protected function internal_add(name : String,f : *) : void {
			var a : Array = this._expects.getOrElseC(name,[]);
			if(a == []) this._expects.set(name,a);
			a.push(f);
			Reflect.setField(this,name,f);
		}
		
		public function getTarget() : * {
			return this._target;
		}
		
		public function verifyAllExpectations() : void {
			{ var $it : * = this._expects.keys().iterator();
			while( $it.hasNext() ) { var key : String = $it.next();
			{
				var array : Array = this._expects.getOrElseC(key,[]);
				if(array.length > 0) throw "Expected function " + key + " to be invoked " + array.length + " more time" + (((array.length == 1)?"":"s"));
			}
			}}
		}
		
		public function allow5(name : String,f : Function) : void {
			Reflect.setField(this._target,name,f);
		}
		
		public function allow4(name : String,f : Function) : void {
			Reflect.setField(this._target,name,f);
		}
		
		public function allow3(name : String,f : Function) : void {
			Reflect.setField(this._target,name,f);
		}
		
		public function allow2(name : String,f : Function) : void {
			Reflect.setField(this._target,name,f);
		}
		
		public function allow1(name : String,f : Function) : void {
			Reflect.setField(this._target,name,f);
		}
		
		public function expect5(name : String,f : Function,times : int = 1) : void {
			var self : stx.test.mock.Mock = this;
			{
				var _g : int = 0;
				while(_g < times) {
					var i : int = _g++;
					this.internal_add(name,function(p1 : *,p2 : *,p3 : *,p4 : *,p5 : *) : * {
						self.internal_remove(name);
						return f(p1,p2,p3,p4,p5);
					});
				}
			}
		}
		
		public function expect4(name : String,f : Function,times : int = 1) : void {
			var self : stx.test.mock.Mock = this;
			{
				var _g : int = 0;
				while(_g < times) {
					var i : int = _g++;
					this.internal_add(name,function(p1 : *,p2 : *,p3 : *,p4 : *) : * {
						self.internal_remove(name);
						return f(p1,p2,p3,p4);
					});
				}
			}
		}
		
		public function expect3(name : String,f : Function,times : int = 1) : void {
			var self : stx.test.mock.Mock = this;
			{
				var _g : int = 0;
				while(_g < times) {
					var i : int = _g++;
					this.internal_add(name,function(p1 : *,p2 : *,p3 : *) : * {
						self.internal_remove(name);
						return f(p1,p2,p3);
					});
				}
			}
		}
		
		public function expect2(name : String,f : Function,times : int = 1) : void {
			var self : stx.test.mock.Mock = this;
			{
				var _g : int = 0;
				while(_g < times) {
					var i : int = _g++;
					this.internal_add(name,function(p1 : *,p2 : *) : * {
						self.internal_remove(name);
						return f(p1,p2);
					});
				}
			}
		}
		
		public function expect1(name : String,f : Function,times : int = 1) : void {
			var self : stx.test.mock.Mock = this;
			{
				var _g : int = 0;
				while(_g < times) {
					var i : int = _g++;
					this.internal_add(name,function(p : *) : * {
						self.internal_remove(name);
						return f(p);
					});
				}
			}
		}
		
		public function get target() : * { return getTarget(); }
		protected function set target( __v : * ) : void { $target = __v; }
		protected var $target : *;
		protected var _target : *;
		protected var _expects : stx.ds.Map;
		static public function internal_create(c : Class) : stx.test.mock.Mock {
			return new stx.test.mock.Mock(c);
		}
		
	}
}
