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

class OutcomeTest extends TestCase{
	public function new() {
		super();
	}
/*	public function testRight() {
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
				a.mapr(
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
				).fold( 
						0,
						function(int1:Int, int2:Int) {
							return int1 + int2;
						}
				).foreach(
						function(total) {
							45.equals(total);
						}
				);
	}
	public function testOutcomes2() {
		0.until(10)
				.map( Outcome.succeed )
				.fold(
						[], 	
						function (arr,int){
								arr.push(int);
								return arr;
						}
				).foreach(
						function(array) {
							(array.length == 10).isTrue();
						}
				);
	}
	public function testOutcomesFailure() {
		var outcome1 = 'ok1'.succeed();
		var outcome2 = new Outcome().left('notok');
		var outcome3 = new Outcome().left('notok again');
		var outcome4 = 'ok4'.succeed();
		
		[outcome1, outcome2, outcome3,outcome4]
				.fold(
						'',
						function(a, b) {
							return a + b;
						}
				).but(
						function(fail) {
							['notok', 'notok again'].equals(cast fail);
						}
				).foreach(
						function(succ) {
							Assert.fail();
						}
				);
	}
	public function testFailAll(){
		var outcome2 = new Outcome().left('notok');
		var outcome3 = new Outcome().left('notok again');
		
		[outcome2, outcome3]
				.fold(
						'',
						function(a, b) {
							return a + b;
						}
				).but(
						function(fail) {
							['notok', 'notok again'].equals(cast fail);
						}
				).foreach(
						function(succ) {
							Assert.fail();
						}
				);
	}
	*/
}