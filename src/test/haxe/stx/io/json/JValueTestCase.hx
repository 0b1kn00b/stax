/*
 HaXe library written by John A. De Goes <john@socialmedia.com>
 Contributed by Social Media Networks

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the
 distribution.

 THIS SOFTWARE IS PROVIDED BY SOCIAL MEDIA NETWORKS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SOCIAL MEDIA NETWORKS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package stx.io.json;

import stx.Prelude;
import stx.Tuples;

import stx.ds.plus.Equal;

import stx.test.TestCase;
import stx.io.json.JValue;
import stx.ds.Set;
import stx.ds.Map;
import stx.ds.List;
import stx.io.json.TranscodeJValue;
import stx.io.json.TranscodeJValueExtensions;

using stx.io.json.TranscodeJValueExtensions;
import stx.io.json.JValueExtensions;
using stx.io.json.JValueExtensions;
import stx.io.json.PrimitivesJValue;
import stx.io.json.CollectionsJValue;

class JValueTestCase extends TestCase {
  public function testBool() {
    doTest(BoolJValue.decompose, function(v){return BoolJValue.extract(Bool, v);}, [true, false]);
  }

  public function testInt() {
    doTest(IntJValue.decompose, function(v){return IntJValue.extract(Int, v);}, [-1234, 9231]);
  }

  public function testFloat() {
    doTest(FloatJValue.decompose, function(v){return FloatJValue.extract(Float, v);}, [0.25, 0.5]);
  }

  public function testString() {
    doTest(StringJValue.decompose, function(v){return StringJValue.extract(String, v);}, ["boo", "baz"]);
  }

  public function testDate() {
    doTest(DateJValue.decompose, function(v){return DateJValue.extract(Date, v);}, [Date.now(), Date.fromTime(0.0)]);
  }

  public function testOption() {
    var a: Array<Option<Int>> = [Some(123), None];

    doTest(OptionJValue.decompose, function(v){return OptionJValue.extract(Option, v, function(v){return IntJValue.extract(Int, v);});}, a);
  }

  public function testTuple2() {
    var a = [Tuples.t2(123, "foo"), Tuples.t2(0, "bar")];

    doTest(Tuple2JValue.decompose,
          function(v){return Tuple2JValue.extract(v, function(v){return IntJValue.extract(Int, v);}, function(v){return StringJValue.extract(String, v);});},
          a);
  }

  public function testTuple3() {
    var a = [Tuples.t3(123, "foo", true), Tuples.t3(0, "bar", false)];

    doTest(Tuple3JValue.decompose,
          function(v){return Tuple3JValue.extract(v, function(v){return IntJValue.extract(Int, v);}, function(v){return StringJValue.extract(String, v);}, function(v){return BoolJValue.extract(Bool, v);});},
          a);

  }

  public function testTuple4() {
    var a = [Tuples.t4(123, "foo", true, 0.25), Tuples.t4(0, "bar", false, 0.5)];

    doTest(Tuple4JValue.decompose,
          function(v){return Tuple4JValue.extract(v, function(v){return IntJValue.extract(Int, v);}, function(v){return StringJValue.extract(String, v);}, function(v){return BoolJValue.extract(Bool, v);}, function(v){return FloatJValue.extract(Float, v);});},
          a);
  }

  public function testTuple5() {
    var a = [Tuples.t5(123, "foo", true, 0.25, "biz"), Tuples.t5(0, "bar", false, 0.5, "bop")];

    doTest(Tuple5JValue.decompose,
          function(v){return Tuple5JValue.extract(v, function(v){return IntJValue.extract(Int, v);}, function(v){return StringJValue.extract(String, v);}, function(v){return BoolJValue.extract(Bool, v);}, function(v){return FloatJValue.extract(Float, v);}, function(v){return StringJValue.extract(String, v);});},
          a);
  }

  public function testArray() {
    var a: Array<Array<Int>> = [[123, 9, -23], []];

    doTest(ArrayJValue.decompose, function(v){return ArrayJValue.extract(Array, v, function(v){return IntJValue.extract(Int, v);});}, a);
  }

  public function testSet() {
    var a: Array<Set<Int>> = [Set.create().addAll([123, 9, -23]), Set.create()];

    doTest(SetJValue.decompose, function(v){return SetJValue.extract(v, function(v){return IntJValue.extract(Int, v);});}, a);
  }

  public function testList() {
    var a: Array<List<Int>> = [List.create().addAll([123, 9, -23]), List.create()];

    doTest(ListJValue.decompose, function(v){return ListJValue.extract(v, function(v){return IntJValue.extract(Int, v);});}, a);
  }

  public function testMap() {
    var a: Array<Map<Int, String>> = [Map.create().addAll([stx.Tuples.t2(123, "foo"), stx.Tuples.t2(-23, "bar"), stx.Tuples.t2(0, "baz")]), Map.create()];

    doTest(MapJValue.decompose,
           function(v){return MapJValue.extract(v, function(v){return IntJValue.extract(Int, v);}, function(v){return StringJValue.extract(String, v);});}, a);
  }

  public function testJValue() {
    doTest(JValueExtensions.decompose,
        function(v){return JValueExtensions.extract(JValue, v);},
        [JNull, JString("foo"), JNumber(123.0), JBool(false), JObject([JField("foo", JString("bar"))]), JArray([JNull, JString("baz")])]);
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