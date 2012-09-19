package stx.io.json;

import stx.Prelude;
import stx.Tuples;

import stx.plus.Equal;

import stx.test.TestCase;
import stx.io.json.JValue;
import stx.ds.Set;
import stx.ds.Map;
import stx.ds.List;
import stx.io.json.TranscodeJValue;
import stx.io.json.Decomposer;
import stx.io.json.Extractor;

using stx.io.json.JValue;
import stx.io.json.Transcode;

import stx.io.json.types.ArrayJValue;
import stx.io.json.types.BoolJValue;
import stx.io.json.types.DateJValue;
import stx.io.json.types.IntJValue;
import stx.io.json.types.FloatJValue;
import stx.io.json.types.StringJValue;

import stx.io.json.types.stx.OptionJValue;
import stx.io.json.types.stx.Tuple2JValue;
import stx.io.json.types.stx.Tuple3JValue;
import stx.io.json.types.stx.Tuple4JValue;
import stx.io.json.types.stx.Tuple5JValue;

import stx.io.json.types.stx.ds.SetJValue;
import stx.io.json.types.stx.ds.MapJValue;
import stx.io.json.types.stx.ds.ListJValue;

class JValueTest extends TestCase {
  public function testBool() {
    doTest(BoolJValue.decomposer(), function(v){return BoolJValue.extractor()(v);}, [true, false]);
  }

  public function testInt() {
    doTest(IntJValue.decomposer(), function(v){return IntJValue.extractor()(v);}, [-1234, 9231]);
  }

  public function testFloat() {
    doTest(FloatJValue.decomposer(), function(v){return FloatJValue.extractor()(v);}, [0.25, 0.5]);
  }

  public function testString() {
    doTest(StringJValue.decomposer(), function(v){return StringJValue.extractor()(v);}, ["boo", "baz"]);
  }

  public function testDate() {
    doTest(DateJValue.decomposer(), function(v){return DateJValue.extractor()(v);}, [Date.now(), Date.fromTime(0.0)]);
  }

  public function testOption() {
    var a: Array<Option<Int>> = [Some(123), None];

    doTest(OptionJValue.decomposer(), function(v){return OptionJValue.extractor()(v);}, a);
  }

  public function testTuple2() {
    var a = [Tuples.t2(123, "foo"), Tuples.t2(0, "bar")];
    var dt = Tuple2JValue.decomposer();
    var et = Tuple2JValue.extractor();

    doTest(dt,
          function(v){return et(v);},
          a);
  }

  public function testTuple3() {
    var a   = [Tuples.t3(123, "foo", true), Tuples.t3(0, "bar", false)];

    doTest(
        Tuple3JValue.decomposer()
      , function(v){return Tuple3JValue.extractor()(v); }
      , a
    );
  }

  public function testTuple4() {
    var a = [Tuples.t4(123, "foo", true, 0.25), Tuples.t4(0, "bar", false, 0.5)];

    doTest(
        Tuple4JValue.decomposer()
      , function(v){return Tuple4JValue.extractor()(v);}
      , a
    );
  }

  public function testTuple5() {
    var a = [Tuples.t5(123, "foo", true, 0.25, "biz"), Tuples.t5(0, "bar", false, 0.5, "bop")];

    doTest(
        Tuple5JValue.decomposer()
      , function(v){return Tuple5JValue.extractor()(v);}
      , a
    );
  }

  public function testArray() {
    var a: Array<Array<Int>> = [[123, 9, -23], []];

    doTest(
        ArrayJValue.decomposer()
      , function(v){return ArrayJValue.extractor()(v);}
      , a
    );
  }

  public function testSet() {
    var a: Array<Set<Int>> = [Set.create().addAll([123, 9, -23]), Set.create()];

    doTest(
        SetJValue.decomposer()
      , function(v){return SetJValue.extractor()(v);}
      , a
    );
  }

  public function testList() {
    var a: Array<List<Int>> = [List.create().addAll([123, 9, -23]), List.create()];

    doTest(
        ListJValue.decomposer()
      , function(v){return ListJValue.extractor()(v);}
      , a
    );
  }

  public function testMap() {
    var a: Array<Map<Int, String>> = [Map.create().addAll([stx.Tuples.t2(123, "foo"), stx.Tuples.t2(-23, "bar"), stx.Tuples.t2(0, "baz")]), Map.create()];

    doTest(
        MapJValue.decomposer()
      , function(v){return MapJValue.extractor()(v);}
      , a
    );
  }

  public function testJValue() {
    var tc = stx.io.json.types.stx.io.json.JValue.transcoder();
    doTest(
        tc.extract
      , function(v){return tc.extract(v);}
      , [JNull, JString("foo"), JNumber(123.0), JBool(false), JObject([JField("foo", JString("bar"))]), JArray([JNull, JString("baz")])]
    );
  }

  private function doTest<T>(decomposer: JDecomposerFunction<T>, extractor: JExtractorFunction<T>, values: Array<T>): Void {
    var eq = Equal.getEqualFor(values[0]);
    for (value in values) {
			var decompose = decomposer(value);
			var actual = extractor(decomposer(value));
			var equal = eq(value, actual);

		if (!equal) {
        throw "Expected " + value + " but was " + actual;
      }

      assertTrue(equal);
    }
  }
}