package;

using stx.Strings;

import haxe.unit.TestCase;

class NekoTest extends TestCase{
  public function test_whether_cwd_has_terminating_slash(){
    var cwd = Sys.getCwd();
    assertTrue(cwd.endsWith("/"));
  }
}