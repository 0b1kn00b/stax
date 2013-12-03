  package stx.io.json;

import haxe.CallStack;
import Prelude;

import stx.plus.Equal;

import Type;
using stx.Tuples;
import Prelude;
import stx.test.Suite;
import stx.io.json.JValue;
import stx.ds.Set;
import stx.ds.Map;
import stx.ds.List;
import stx.io.json.Transcode;



typedef UnionOfSimpleFeedTypes = Dynamic

class TranscodeJValuesTest extends Suite {
  public function new() {
    super();
  }

  public function testBool() {
    doTest([true, false]);
  }

  public function testInt() {
    doTest([-1234, 9231]);
  }

  public function testFloat() {
    doTest([0.25, 0.5]);
  }

  public function testString() {
    doTest(["boo", "baz"]);
  }

  public function testDate() {
    doTest([Date.now(), Date.fromTime(0.0)]);
  }

  public function testOption() {
    var a: Array<Option<Int>> = [Some(123), None];

    doTest(a, [Extractor.getExtractorForType(TInt)]);
  }

  public function testTuple2() {
    var a = [tuple2(123, "foo"), tuple2(0, "bar")];

    doTest(a, [Extractor.getExtractorForType(TInt), Extractor.getExtractorForType(TClass(String))]);
  }

  public function testTuple3() {
    var a = [Tuples.t3(123, "foo", true), Tuples.t3(0, "bar", false)];

    doTest(a, [Extractor.getExtractorForType(TInt), Extractor.getExtractorForType(TClass(String)), Extractor.getExtractorForType(TBool)]);

  }

  public function testTuple4() {
    var a = [Tuples.t4(123, "foo", true, 0.25), Tuples.t4(0, "bar", false, 0.5)];

    doTest(a, [Extractor.getExtractorForType(TInt), Extractor.getExtractorForType(TClass(String)), Extractor.getExtractorForType(TBool), Extractor.getExtractorForType(TFloat)]);
  }

  public function testTuple5() {
    var a = [Tuples.t5(123, "foo", true, 0.25, "biz"), Tuples.t5(0, "bar", false, 0.5, "bop")];

    doTest(a, [Extractor.getExtractorForType(TInt), Extractor.getExtractorForType(TClass(String)), Extractor.getExtractorForType(TBool), Extractor.getExtractorForType(TFloat), Extractor.getExtractorForType(TClass(String))]);
  }

  public function testArray() {
    var a: Array<Array<Int>> = [[123, 9, -23], []];

    doTest(a, [Extractor.getExtractorForType(TInt)]);
  }

  public function testSet() {
    var a: Array<Set<Int>> = [Set.create().addAll([123, 9, -23]), Set.create()];

    doTest(a, [Extractor.getExtractorForType(TInt)]);
  }

  public function testList() {
    var a: Array<List<Int>> = [List.create().addAll([123, 9, -23]), List.create()];

    doTest(a, TClass(List), [Extractor.getExtractorForType(TInt)]);
  }

  public function testMap() {
    var a: Array<Map<Int, String>> = [Map.create().addAll([tuple2(123, "foo"), tuple2(-23, "bar"), tuple2(0, "baz")]), Map.create()];
		
		doTest(a, [Extractor.getExtractorForType(TInt), Extractor.getExtractorForType(TClass(String))]);
  }

  public function testJValue() {
    var a = [JNull, JString("foo"), JNumber(123.0), JBool(false), JObject([JField("foo", JString("bar"))]), JArray([JNull, JString("baz")])];
    doTest(a);
  }

  public function testEnum() {
    var a: Array<TestEnum> = [Second(123), First];

    doTest(a, [Extractor.getExtractorForType(TInt)]);
  }


  private function doTest<T>(values: Array<T>, ?valueType: ValueType, ?extractors: Array<JExtractorFunction<T>>): Void {
		for (value in values) {
      if (valueType == null)
        valueType = Type.typeof(value);
      var decomposed = Decomposer.getDecomposerForType(valueType)(value);
      var actual     = Extractor.getExtractorForType(valueType, extractors)(decomposed);
			var equal      = Equal.getEqualFor(value)(value, actual);
      if (!equal) {
        throw "Expected " + value + " but was " + actual;
      }

      assertTrue(equal);
    }
  }
}


enum TestEnum {
  First;
  Second(v: Int);
}