package stx;

import stx.Muster;
import stx.Muster.Test.*;
import stx.Log.*;

import stx.log.*;
import stx.log.Listing;
import stx.log.Listing.Listings.*;


class LogTest extends TestCase{
  public function testLog(u:UnitArrow):UnitArrow{
    var z = new ZebraListings(
      blacklist()
    );
    return u;
  }
}

