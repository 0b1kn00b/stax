package stx.io.log;

import Type;
import haxe.PosInfos;

enum Listing<T> {
  Include(s:T);
  Exclude(s:T);
}