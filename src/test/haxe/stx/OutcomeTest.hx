package stx;

/**
 * ...
 * @author 0b1kn00b
 */									
																			using Stax;
import stx.test.TestCase;
import stx.test.Assert;							using stx.test.Assert;

import stx.Outcome;									using stx.Outcome;
import stx.Maths;										using stx.Maths;
import stx.Iterables;								using stx.Iterables;
import stx.reactive.Arrows;					using stx.reactive.Arrows;

class OutcomeTest extends TestCase{
	public function new() {
		super();
	}
	
	public function testRight() {
		var a = new Outcome();
		a.foreach( 
				function(x:String) {
					x.equals('ok');
				}
		);
		a.right('ok');
	}
	public function testMap() {
		var a = 'ok'.succeed();
				a.map(
						function(x:String) {
							return 3;
						}
				).foreach(
						function(y:Int) {
							3.equals(y);
						}
				);
	}
	public function testFlatMap() {
		var a = 'ok'.succeed();
				a.flatMap(
						function(x) {
							'ok'.equals(x);
							return 'yup'.succeed();
						}
				).foreach(
						function(x) {
							'yup'.equals(x);
						}
				);
	}
	public function testOutcomes(){
		0.until(10)
				.map(
						function(int:Int) {
							return int.succeed();
						}
				).toArray().waitFor()
				 .map(
						function(arr) {
							return arr.foldl(								
								0,
								function(int1:Int, int2:Int) {
									return int1 + int2;
								}
							);
						}
				 ).foreach(
						function(total) {
							45.equals(total);
						}
				);
	}
	public function testOutcomeFailure() {
		var outcome2 = new Outcome().left('notok')
				.onError(
						function(x) {
							true.isTrue();
							return x;
							//['notok', 'notok again'].equals(cast x);
						}.lift()
				);
	}
	public function testOutcomesFailure0() {
		var async 	= Assert.createAsync( function() { } , 200);
		var outcome2 = new Outcome();
		
		haxe.Timer.delay(
				function() {
					outcome2.left('notok');
				},10
		);
		
		outcome2
				.onError(
						function(x:Dynamic) {
							trace("0");
							true.isTrue();
							async();
							return x;
						}.lift()
				);
	}
	
	public function testOutcomesFailure1() {
		var async 	= Assert.createAsync( function() { } , 200);
		var outcome = new Outcome();
		
		haxe.Timer.delay(
				function() {
					outcome.left('not ok1');
				}
				,10
		);
		
		outcome
				.onError(
						function(x:Dynamic) {
							trace("1");
							true.isTrue();
							async();
							return x;
							//['notok', 'notok again'].equals(cast x);
						}.lift()
				);
	}
	public function testOutcomesFailure2() {
		var async 	= Assert.createAsync( function() { } , 200);
		var outcome = new Outcome();
		
		haxe.Timer.delay(
				function() {
					outcome.left('not ok1');
				}
				,10
		);
		
		outcome
				.map(
						function(x) {
							return x;
						}
				).onError(
						function(x:Dynamic) {
							trace("2");
							true.isTrue();
							async();
							return x;
							//['notok', 'notok again'].equals(cast x);
						}.lift()
				);
	}
	
	public function testOutcomesFailure3() {
		var async 	= Assert.createAsync( function() { } , 200);
		var outcome = new Outcome();
		
		haxe.Timer.delay(
				function() {
					outcome.right('ok1');
				}
				,10
		);
		
		outcome
				.flatMap(
						function (x) {
							return Outcome.failer('false');
						}
				).onError(
						function(x:Dynamic) {
							trace("3");
							true.isTrue();
							async();
							return x;
							//['notok', 'notok again'].equals(cast x);
						}.lift()
				);
	} 
	
	public function testOutcomesFailure4() {
		var async 	= Assert.createAsync( function() { } , 200);
		var outcome = new Outcome().right('ok1');
	
		outcome
				.flatMap(
						function (x) {
							return Outcome.failer('false');
						}
				).map(
						function(x) {
							return x;
						}
				).onError(
						function(x:Dynamic) {
							trace("4");
							true.isTrue();
							async();
							return x;
						}.lift()
				);
	}
	public function testWaitFailer10() {
		var outcome1 = 'ok1'.succeed();
		var outcome2 = new Outcome().left('notok');
		
		[outcome1, outcome2].waitFor()
		.map(
				function (x) {
					trace(x);
					return x;
				}
		).onError(
				function(x) {
					trace('5');
					true.isTrue();
					return x;
				}.lift()
		).foreach(
				function(x) {
					Assert.fail();
				}
		);
	}
	
	public function testWaitFailer11() {
		var async 	= Assert.createAsync( function() { } ,200);
		var outcome1 = 'ok1'.succeed();
		var outcome2 = new Outcome();
		haxe.Timer.delay(
				function() {
					outcome2.left('notok');
				}
				,10
		);
		
		[outcome2, outcome1].waitFor()
		.onError(
				function(x) {
					trace('6');
					true.isTrue();
					async();
					return x;
				}.lift()
		);
	}
	
	
	public function testOutcomesFailure7() {
		var async 	= Assert.createAsync( function() { } ,200);
		var outcome0 = 'ok0'.succeed();
		var outcome1 = 'ok1'.succeed();
		var outcome2 = new Outcome().left('notok0');
		var outcome3 = new Outcome().left('notok again');
		var outcome4 = new Outcome();
		
		haxe.Timer.delay(
				function() {
					outcome4.left('notok');
				}
				,10
		);
		
		[outcome0, outcome1]
				.waitFor()
				.flatMap(
						function (x){
							return outcome4;
						}
				).map(
						function(x) {
							return x;
						}
				).onError(
						function(x:Dynamic) {
							trace("7");
							true.isTrue();
							async();
							return x;
							//['notok', 'notok again'].equals(cast x);
						}.lift()
				);
	}
	
	public function testOutcomesFailure8() {
		var async 	= Assert.createAsync( function() { } ,200);
		var outcome0 = new stx.Outcome(
				function (x) {
					trace('"·"·"·"·"·"·"·"·"·"·');
					return x;
				}.lift()
		);
		var outcome1 = 'ok1'.succeed();
		var outcome2 = new Outcome();
		var outcome3 = new Outcome().left('notok again');
		var outcome4 = new Outcome();
		var outcome5 = new Outcome().right('ok');
		
		haxe.Timer.delay(
				function() {
					outcome4.left('notok');
				}
				,10
		);
		haxe.Timer.delay(
				function() {
					outcome2.left('notok 2');
				}
				,20
		);
		
		var counter = 0;
		
		haxe.Timer.delay(
				function() {
					outcome0.right('ok');
				}
				,10
		);
		outcome0
				.flatMap(
						function (x){
							return outcome2;
						}
				).onError(
						function(x) {
							trace('1111111111111111111111111111111111');
							return x;
						}.lift()
				).map(
						function(x) {
							return true;
						}
				).foreach(
						function(x) {
							Assert.fail();
						}
				).toCallback(
						function(err, res) {
							trace('boo');
							if (err != null) {
								true.isTrue();
								async();
							}
							trace(res);
						}
				);
	}
	public function testOutcomesFailure6() {
		var async 	= Assert.createAsync( function() { } ,200);
		var outcome1 = 'ok1'.succeed();
		var outcome2 = new Outcome().left('notok');
		var outcome3 = new Outcome().left('notok again');
		var outcome4 = new Outcome();
		
		haxe.Timer.delay(
				function() {
					outcome4.right('ok1');
				}
				,10
		);
		
		[outcome1, outcome2, outcome3,outcome4]
				.waitFor()
				.map( 
						function(arr) {
							trace('folding');
							return arr.foldl(
								'',
										function(a, b) {
											return a + b;
										}
							);
						}
				).onError(
						function(x:Dynamic) {
							trace("6");
							true.isTrue();
							async();
							return x;
							//['notok', 'notok again'].equals(cast x);
						}.lift()
				);
	}
	
	public function testOutcomesFailure9() {
		var async 	= Assert.createAsync( function() { } , 200);
		var outcome1 = 'ok1'.succeed();
		var outcome2 = new Outcome().left('notok');
		var outcome3 = new Outcome().left('notok again');
		var outcome4 = new Outcome();
		
		haxe.Timer.delay(
				function() {
					outcome4.right('ok1');
				}
				,10
		);
		
		[outcome1, outcome2, outcome3,outcome4]
				.waitFor()
				.onError(
						function(x:Dynamic) {
							trace("AAAAAAAAAAAAAAAAAAAAAA");
							return x;
						}.lift()
				).map( 
						function(arr) {
							trace('folding');
							return arr.foldl(
								'',
										function(a, b) {
											return a + b;
										}
							);
						}
				).onError(
						function(x:Dynamic) {
							trace("BBBBBBBBBBBBBBBBBBBBBBB");
							return x;
							//['notok', 'notok again'].equals(cast x);
						}.lift()
				).flatMap(
						function(succ) {
							trace('flatmapping');
							return Outcome.failer('');
						}
				).onError(
						function(x:Dynamic) {
							trace("CCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
							return x;
							//['notok', 'notok again'].equals(cast x);
						}.lift()
				).map(
						function(x) {
							return x;
						}
				).onError(
						function(x:Dynamic) {
							trace("2");
							true.isTrue();
							async();
							return x;
							//['notok', 'notok again'].equals(cast x);
						}.lift()
				);
	}
		public function testOutcomesFailure10() {
		var async 	= Assert.createAsync( function() { } , 200);
		var outcome1 = 'ok1'.succeed();
		var outcome4 = new Outcome();
		
		haxe.Timer.delay(
				function() {
					outcome4.right('ok1');
				}
				,10
		);
		
		[outcome1, outcome4]
				.waitFor()
				.onError(
						function(x:Dynamic) {
							trace("AAAAAAAAAAAAAAAAAAAAAA");
							return x;
						}.lift()
				).map( 
						function(arr) {
							trace('folding');
							return arr.foldl(
								'',
										function(a, b) {
											return a + b;
										}
							);
						}
				).onError(
						function(x:Dynamic) {
							trace("BBBBBBBBBBBBBBBBBBBBBBB");
							return x;
						}.lift()
				).flatMap(
						function(succ) {
							trace('flatmapping');
							return Outcome.failer('');
						}
				).onError(
						function(x:Dynamic) {
							trace("CCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
							return x;
						}.lift()
				).map(
						function(x) {
							trace('mapping 2');
							return x;
						}
				).onError(
						function(x:Dynamic) {
							trace("2");
							true.isTrue();
							async();
							return x;
						}.lift()
				);
	}
}