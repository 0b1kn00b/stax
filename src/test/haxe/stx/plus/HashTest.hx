class MapTest{
   @:todo('#0b1kn00b: the typer is now ignoring casts')
  public function testTupleMapCode() {    
    var tests : Array<MapFunction<Product>> = cast [
      cast Hasher.getMapFor(Tuples.t2("b",0)),
      cast Hasher.getMapFor(Tuples.t2("a",1)), 
      cast Hasher.getMapFor(Tuples.t3("a",0,0.1)),
      cast Hasher.getMapFor(Tuples.t4("a",0,0.1,"b")),
      cast Hasher.getMapFor(Tuples.t5("a",0,0.1,"a",1)), 
    ];
   
    while(tests.length > 0)
    {
      var value = tests.pop();
      // check is unique        
        assertFalse(tests.remove(value), "value is not unique hash: " + value);
      
      // check is different from zero
      assertNotEquals(0, value);
    } 
  }
  public function testMap() {
    assertMapCodeForIsZero(null);
    assertMapCodeForIsZero(0);
       
    assertMapCodeForIsNotZero(true);
    assertMapCodeForIsNotZero(false);
    assertMapCodeForIsNotZero("");
    assertMapCodeForIsNotZero("a");
    assertMapCodeForIsNotZero(1);
    assertMapCodeForIsNotZero(0.1);
    assertMapCodeForIsNotZero([]);
    assertMapCodeForIsNotZero([1]);
    assertMapCodeForIsNotZero({});
    assertMapCodeForIsNotZero({n:"a"});
    assertMapCodeForIsNotZero(new HasMap(1));
    assertMapCodeForIsNotZero(Date.fromString("2000-01-01"));       
    assertMapCodeForIsNotZero(None);
    assertMapCodeForIsNotZero(Some("a"));
  }

  public function testReflectiveHasher(){
    var zerocodes : Array<Dynamic> = [null, 0];
    for(z in zerocodes)
      assertEquals(0, Hasher.getMapFor(z)(z));

    var nonzerocodes : Array<Dynamic> = [true, false, "", "a", 1, 0.1, [],[1], {}, {n:"a"}, new HasNoMapAndShow(1), new HasMap(1), Date.fromString("2000-01-01"), None, Some("a")];
    for(n in nonzerocodes)
      this.assertNotEquals(0, Hasher.getMapFor(n)(n));
  }

  public function assertMapCodeForIsZero<T>(v : T) {
    assertEquals(0, Hasher.getMapFor(v)(v));
  }

  public function assertMapCodeForIsNotZero<T>(v : T) {
    assertNotEquals(0, Hasher.getMapFor(v)(v));
  }

}
@DataClass private class HasNoMapAndShow
{ 
  @DataField({show:false})   
  var v : Int;
  public function new(v : Int) this.v = v
}
private class HasMap
{
  var v : Int;
  public function new(v : Int) this.v = v
  public function hashCode() return v
}