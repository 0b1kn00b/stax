package stx.reactive._Reactive {
	import flash.Boot;
	public class PriorityQueue {
		public function PriorityQueue() : void { if( !flash.Boot.skip_constructor ) {
			this.val = [];
		}}
		
		public function pop() : * {
			if(this.val.length == 1) return this.val.pop();
			var ret : * = this.val.shift();
			this.val.unshift(this.val.pop());
			var kvpos : int = 0;
			var kv : * = this.val[0];
			while(true) {
				var leftChild : int = ((kvpos * 2 + 1 < this.val.length)?this.val[kvpos * 2 + 1].k:kv.k + 1);
				var rightChild : int = ((kvpos * 2 + 2 < this.val.length)?this.val[kvpos * 2 + 2].k:kv.k + 1);
				if(leftChild > kv.k && rightChild > kv.k) break;
				else if(leftChild < rightChild) {
					this.val[kvpos] = this.val[kvpos * 2 + 1];
					this.val[kvpos * 2 + 1] = kv;
					kvpos = kvpos * 2 + 1;
				}
				else {
					this.val[kvpos] = this.val[kvpos * 2 + 2];
					this.val[kvpos * 2 + 2] = kv;
					kvpos = kvpos * 2 + 2;
				}
			}
			return ret;
		}
		
		public function isEmpty() : Boolean {
			return this.val.length == 0;
		}
		
		public function insert(kv : *) : void {
			this.val.push(kv);
			var kvpos : int = this.val.length - 1;
			while(kvpos > 0 && kv.k < this.val[Math.floor((kvpos - 1) / 2)].k) {
				var oldpos : int = kvpos;
				kvpos = Math.floor((kvpos - 1) / 2);
				this.val[oldpos] = this.val[kvpos];
				this.val[kvpos] = kv;
			}
		}
		
		public function length() : int {
			return this.val.length;
		}
		
		protected var val : Array;
	}
}
