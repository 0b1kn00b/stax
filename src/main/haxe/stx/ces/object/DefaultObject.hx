package stx.ces.object;

import stx.ces.ifs.Object in IObject;

class DefaultObject extends DefaultComponent implements IObject{
  @:noUsing static public function create(triggers:Array<Event>,behaviours:Array<Behaviour>)
  public var triggers     : Array<Event>;
  public var behaviours   : Array<Behaviour>;
}