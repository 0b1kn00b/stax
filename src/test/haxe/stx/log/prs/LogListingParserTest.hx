package stx.log.prs;

import Stax.*;
import stx.Compare.*;
import stx.Log.*;

using stx.UnitTest;

using stx.Arrays;
using stx.Strings;
using stx.prs.Base;
using stx.prs.Parser;
using stx.prs.StringParsers;

import stx.log.prs.LogListingParser.*;

class LogListingParserTest extends TestCase{
  public function testASCII(u:UnitArrow):UnitArrow{
    var tsts = [
      isEqual([13,10],"
".chunk().map(Strings.cca.bind(_,0))), //true on windows
      isEqual(10,'\n'.cca(0)),
      isEqual(13,"\r".cca(0))
    ];
    return u.append(tsts);
  }
  public function testLogListingParser(u:UnitArrow):UnitArrow{
    var tsts = [];
    var ln0 = '@1239';
    var a = p_line()(ln0.reader());
    tsts.push(isAlike(Success(null,null),a));
    var ln1 = '&run_prdct';
    var b = p_method()(ln1.reader());
    tsts.push(isAlike(Success(null,null),b));
    var ln2 = '$$sdj.sfg.DF';
    var c = p_type()(ln2.reader());
    tsts.push(isAlike(Success(null,null),c));
    var ln3 = '*\\name.hx';
    var d = p_file()(ln3.reader());
    tsts.push(isAlike(Success(null,null),d));

    var ln4 = '$ln3$ln2$ln1$ln0';
    var d = p_pos()(ln4.reader());
    tsts.push(isAlike(Success(null,null),d));
    var ln5 = '$ln3$ln2$ln1';
    var e = p_pos()(ln5.reader());
    tsts.push(isAlike(Success(null,null),e));
    var ln6 = '$ln3$ln2';
    var f = p_pos()(ln6.reader());
    tsts.push(isAlike(Success(null,null),f));
    var ln7 = '$ln3';
    var g = p_pos()(ln7.reader());
    tsts.push(isAlike(Success(null,null),g));
    var ln8 = '$ln2$ln1';
    var h = p_pos()(ln8.reader());
    tsts.push(isAlike(Success(null,null),h));
    var ln9 = '$ln2$ln0';
    var i = p_pos()(ln9.reader());
    tsts.push(isAlike(Success(null,null),i));
    var ln10 = '$ln2';
    var j = p_pos()(ln10.reader());
    tsts.push(isAlike(Success(null,null),j));
    var ln11 = '$ln3$ln0';
    var k = p_pos()(ln11.reader());
    tsts.push(isAlike(Success(null,null),k));
    var l = 
      [
        '+$ln4',
        '-$ln7',
        '#+$ln10',
        '+$ln4',
      ];
    var m = l.map('\n'.prepend).join('');
    var n = p_parse()(m.reader());
    tsts.push(isAlike(Success(null,null),n));
    
    var o = p_entry()('+$ln10'.reader());
    tsts.push(isAlike(Success(null,null),o));
    
    var ln12 = '#ñjfgoihar8923p';
    var p = p_ignore()(ln12.reader());
    tsts.push(isAlike(Success(null,null),p));

    var q = parse(m);
    tsts.push(isTrue(true));
    var v = 
      [
        '+$ln4',
        '$ln7',
        '#+$ln10'
      ];
    var r = hasFail(parse.bind(v.join('\n')));
    tsts.push(r);
    var s = '-*\\A.hx&aaa';
    tsts.push(isAlike(Success(null,null),p_parse()(s.reader())));
    var t = "-$ThreadCommand&new
-*\\ThreadScheduler.hx&run_prdct";
    tsts.push(isAlike(Success(null,null),p_parse()(t.reader())));
    return u.append(tsts);
  }
}

