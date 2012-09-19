class HashTest{
   @:todo('#0b1kn00b: the typer is now ignoring casts')
  public function testTupleHashCode() {    
    var tests : Array<HashFunction<Product>> = cast [
      cast Hasher.getHashFor(Tuples.t2("b",0)),
      cast Hasher.getHashFor(Tuples.t2("a",1)), 
      cast Hasher.getHashFor(Tuples.t3("a",0,0.1)),
      cast Hasher.getHashFor(Tuples.t4("a",0,0.1,"b")),
      cast Hasher.getHashFor(Tuples.t5("a",0,0.1,"a",1)), 
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
  public function testHash() {
    assertHashCodeForIsZero(null);
    assertHashCodeForIsZero(0);
       
    assertHashCodeForIsNotZero(true);
    assertHashCodeForIsNotZero(false);
    assertHashCodeForIsNotZero("");
    assertHashCodeForIsNotZero("a");
    assertHashCodeForIsNotZero(1);
    assertHashCodeForIsNotZero(0.1);
    assertHashCodeForIsNotZero([]);
    assertHashCodeForIsNotZero([1]);
    assertHashCodeForIsNotZero({});
    assertHashCodeForIsNotZero({n:"a"});
    assertHashCodeForIsNotZero(new HasHash(1));
    assertHashCodeForIsNotZero(Date.fromString("2000-01-01"));       
    assertHashCodeForIsNotZero(None);
    assertHashCodeForIsNotZero(Some("a"));
  }

  public function testReflectiveHasher(){
    var zerocodes : Array<Dynamic> = [null, 0];
    for(z in zerocodes)
      assertEquals(0, Hasher.getHashFor(z)(z));

    var nonzerocodes : Array<Dynamic> = [true, false, "", "a", 1, 0.1, [],[1], {}, {n:"a"}, new HasNoHashAndShow(1), new HasHash(1), Date.fromString("2000-01-01"), None, Some("a")];
    for(n in nonzerocodes)
      this.assertNotEquals(0, Hasher.getHashFor(n)(n));
  }

  public function assertHashCodeForIsZero<T>(v : T) {
    assertEquals(0, Hasher.getHashFor(v)(v));
  }

  public function assertHashCodeForIsNotZero<T>(v : T) {
    assertNotEquals(0, Hasher.getHashFor(v)(v));
  }

}
@DataClass private class HasNoHashAndShow
{ 
  @DataField({show:false})   
  var v : Int;
  public function new(v : Int) this.v = v
}
private class HasHash
{
  var v : Int;
  public function new(v : Int) this.v = v
  public function hashCode() return v
}