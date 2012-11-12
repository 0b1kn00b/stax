package stx {
	import stx.Bools;
	import stx.Functions1;
	import stx.Enums;
	import stx.Option;
	import stx.Options;
	import stx.Tuple2;
	import stx.Arrays;
	import stx.Log;
	import flash.Boot;
	import stx.Logger;
	import stx.LogLevel;
	public class DefaultLogger implements stx.Logger{
		public function DefaultLogger(listings : Array = null,level : stx.LogLevel = null,permissive : * = true) : void { if( !flash.Boot.skip_constructor ) {
			if(permissive==null) permissive=true;
			this.listings = ((listings == null)?[]:listings);
			this.level = ((level == null)?stx.LogLevel.Warning:level);
			this.permissive = permissive;
		}}
		
		public function _trace(v : *,infos : * = null) : void {
			flash.Boot.__trace(v,infos);
		}
		
		protected function checker(pos : *,v : String) : Boolean {
			var reg : EReg = new EReg(v,"");
			var matches : Boolean = reg.match(stx.Log.format(pos));
			if(matches) {
			}
			return matches;
		}
		
		public function check(v : *,pos : *) : Boolean {
			var _g : stx.DefaultLogger = this;
			var white : Function = function(includes : Array) : Boolean {
				return stx.Arrays.forAny(Prelude.SArrays.map(Prelude.SArrays.map(includes,stx.Enums.params),stx.Arrays.first),function() : Function {
					var $r : Function;
					var f : Function = _g.checker, a1 : * = pos;
					$r = function(v1 : String) : Boolean {
						return f(a1,v1);
					}
					return $r;
				}());
			}
			var black : Function = function(excludes : Array) : Boolean {
				return !stx.Arrays.forAll(Prelude.SArrays.map(Prelude.SArrays.map(excludes,stx.Enums.params),stx.Arrays.first),function() : Function {
					var $r2 : Function;
					var f1 : Function = _g.checker, a11 : * = pos;
					$r2 = function(v2 : String) : Boolean {
						return f1(a11,v2);
					}
					return $r2;
				}());
			}
			var o : Boolean = stx.Tuple2.into(stx.Arrays.partition(this.listings,function(x : enum) : Boolean {
				return stx.Enums.constructorOf(x) == "Include";
			}),function(includes1 : Array,excludes1 : Array) : Boolean {
				return stx.Bools.ifElse(includes1.length > 0,function() : Boolean {
					return ((white(includes1))?stx.Options.get(stx.Options.orElseC(stx.Bools.ifTrue(excludes1.length > 0,stx.Functions1.lazy(black,excludes1)),stx.Option.Some(_g.permissive))):false);
				},function() : Boolean {
					return stx.Options.get(stx.Options.orElseC(stx.Bools.ifTrue(excludes1.length > 0,stx.Functions1.lazy(black,excludes1)),stx.Option.Some(_g.permissive)));
				});
			});
			return o;
		}
		
		public var level : stx.LogLevel;
		protected var permissive : Boolean;
		protected var listings : Array;
		static public function create(listings : Array,level : stx.LogLevel = null) : stx.DefaultLogger {
			return new stx.DefaultLogger(listings,level);
		}
		
	}
}
