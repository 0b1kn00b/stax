package stx.test.resources {
	import stx.Iterables;
	import haxe.Log;
	import flash.Boot;
	import stx.test.TestCase;
	public class CollectionTester extends stx.test.TestCase {
		public function CollectionTester() : void { if( !flash.Boot.skip_constructor ) {
			super();
		}}
		
		public function testThatItXScanr1Works() : void {
			var a : * = [6,5,4,3,2];
			this.assertEquals("[2,5,6,7,8]",Std.string(stx.Iterables.scanr1(a,function(a1 : int,b : int) : int {
				return a1 + b;
			})),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 133, className : "stx.test.resources.CollectionTester", methodName : "testThatItXScanr1Works"});
		}
		
		public function testThatItXScanrWorks() : void {
			var a : * = [6,5,4,3,2];
			this.assertEquals("[1,3,4,5,6,7]",Std.string(stx.Iterables.scanr(a,1,function(a1 : int,b : int) : int {
				return a1 + b;
			})),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 127, className : "stx.test.resources.CollectionTester", methodName : "testThatItXScanrWorks"});
		}
		
		public function testThatItXScanl1Works() : void {
			var a : * = [6,5,4,3,2];
			this.assertEquals("[6,11,10,9,8]",Std.string(stx.Iterables.scanl1(a,function(a1 : int,b : int) : int {
				return a1 + b;
			})),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 121, className : "stx.test.resources.CollectionTester", methodName : "testThatItXScanl1Works"});
		}
		
		public function testThatItXScanlWorks() : void {
			var a : * = [6,5,4,3,2];
			this.assertEquals("[1,7,6,5,4,3]",Std.string(stx.Iterables.scanl(a,1,function(a1 : int,b : int) : int {
				return a1 + b;
			})),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 115, className : "stx.test.resources.CollectionTester", methodName : "testThatItXScanlWorks"});
		}
		
		public function testThatItXMapWorks() : void {
			var a : * = [6,5,4,3,2];
			this.assertEquals("[12,10,8,6,4]",Std.string(Prelude.SIterables.map(a,function(a1 : int) : int {
				return a1 * 2;
			})),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 109, className : "stx.test.resources.CollectionTester", methodName : "testThatItXMapWorks"});
		}
		
		public function testThatItXAtWorks() : void {
			var a : * = [1,2,3,4,5,4,3,2,1,5,6,7,8,6,5,4,3,2];
			this.assertEquals(6,stx.Iterables.at(a,10),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 101, className : "stx.test.resources.CollectionTester", methodName : "testThatItXAtWorks"});
			this.assertEquals(5,stx.Iterables.at(a,-4),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 103, className : "stx.test.resources.CollectionTester", methodName : "testThatItXAtWorks"});
		}
		
		public function testThatItXNubWorks() : void {
			var a : * = [1,2,3,4,5,4,3,2,1,5,6,7,8,6,5,4,3,2];
			this.assertEquals(8,Prelude.SIterables.size(stx.Iterables.nub(a)),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 95, className : "stx.test.resources.CollectionTester", methodName : "testThatItXNubWorks"});
		}
		
		public function testThatItXExistsWorks() : void {
			var i : * = [1,2,3,4,5];
			this.assertTrue(stx.Iterables.contains(i,2,function(a : int,b : int) : Boolean {
				return a == b;
			}),null,{ fileName : "BCollectionTester.hx", lineNumber : 87, className : "stx.test.resources.CollectionTester", methodName : "testThatItXExistsWorks"});
			this.assertFalse(stx.Iterables.contains(i,1,function(a1 : int,b1 : int) : Boolean {
				return a1 < b1;
			}),null,{ fileName : "BCollectionTester.hx", lineNumber : 89, className : "stx.test.resources.CollectionTester", methodName : "testThatItXExistsWorks"});
		}
		
		public function testThatItXDropWorks() : void {
			var i : * = [1,2,3,4,5];
			this.assertEquals("[4,5]",Std.string(stx.Iterables.drop(i,3)),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 77, className : "stx.test.resources.CollectionTester", methodName : "testThatItXDropWorks"});
			var i1 : Array = [1];
			this.assertEquals(Std.string(stx.Iterables.drop(i1,3)),"[]",null,null,{ fileName : "BCollectionTester.hx", lineNumber : 81, className : "stx.test.resources.CollectionTester", methodName : "testThatItXDropWorks"});
		}
		
		public function testThatItXTakeWorks() : void {
			var i : * = [1,2,3,4,5];
			this.assertEquals(Std.string(stx.Iterables.take(i,3)),"[1,2,3]",null,null,{ fileName : "BCollectionTester.hx", lineNumber : 63, className : "stx.test.resources.CollectionTester", methodName : "testThatItXTakeWorks"});
			var i1 : Array = [1];
			this.assertEquals(Std.string(stx.Iterables.take(i1,3)),"[1]",null,null,{ fileName : "BCollectionTester.hx", lineNumber : 67, className : "stx.test.resources.CollectionTester", methodName : "testThatItXTakeWorks"});
			var i2 : Array = [];
			this.assertEquals(Std.string(stx.Iterables.take(i2,3)),"[]",null,null,{ fileName : "BCollectionTester.hx", lineNumber : 71, className : "stx.test.resources.CollectionTester", methodName : "testThatItXTakeWorks"});
		}
		
		public function testThatItXTailWorks() : void {
			var i : * = [1,2,3,4,5];
			this.assertEquals(Std.string(stx.Iterables.tail(i)),"[2,3,4,5]",null,null,{ fileName : "BCollectionTester.hx", lineNumber : 57, className : "stx.test.resources.CollectionTester", methodName : "testThatItXTailWorks"});
		}
		
		public function testThatItXAppendWorks() : void {
			var i : * = [1,2,3,4,5];
			this.assertEquals(Std.string(stx.Iterables.append(i,2)),"[1,2,3,4,5,2]",null,null,{ fileName : "BCollectionTester.hx", lineNumber : 51, className : "stx.test.resources.CollectionTester", methodName : "testThatItXAppendWorks"});
		}
		
		public function testThatItXHeadWorks() : void {
			var i : * = [1,2,3,4,5];
			this.assertEquals(stx.Iterables.head(i),1,null,null,{ fileName : "BCollectionTester.hx", lineNumber : 45, className : "stx.test.resources.CollectionTester", methodName : "testThatItXHeadWorks"});
		}
		
		public function testThatItXReversedWorks() : void {
			var i : * = [1,2,3,4,5];
			this.assertEquals(Std.string(stx.Iterables.reversed(i)),"[5,4,3,2,1]",null,null,{ fileName : "BCollectionTester.hx", lineNumber : 39, className : "stx.test.resources.CollectionTester", methodName : "testThatItXReversedWorks"});
		}
		
		public function testThatItXFoldrWorks() : void {
			var i : * = [1,2,3,4,5];
			var result : int = stx.Iterables.foldr(i,0,function(a : int,b : int) : int {
				return a + b;
			});
			this.assertEquals(result,15,null,null,{ fileName : "BCollectionTester.hx", lineNumber : 33, className : "stx.test.resources.CollectionTester", methodName : "testThatItXFoldrWorks"});
		}
		
		public function testThatItXFoldlWorks() : void {
			var i : * = [1,2,3,4,5];
			var result : int = Prelude.SIterables.foldl(i,0,function(a : int,b : int) : int {
				return a + b;
			});
			this.assertEquals(result,15,null,null,{ fileName : "BCollectionTester.hx", lineNumber : 25, className : "stx.test.resources.CollectionTester", methodName : "testThatItXFoldlWorks"});
		}
		
		public function testThatTraceWorks() : void {
			haxe.Log._trace("Trace is working",{ fileName : "BCollectionTester.hx", lineNumber : 16, className : "stx.test.resources.CollectionTester", methodName : "testThatTraceWorks"});
			this.assertTrue(true,null,{ fileName : "BCollectionTester.hx", lineNumber : 17, className : "stx.test.resources.CollectionTester", methodName : "testThatTraceWorks"});
		}
		
	}
}
