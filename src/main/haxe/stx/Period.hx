package stx;

using Math;

import stx.time.*;
import stx.time.Period in CPeriod;

abstract Period(CPeriod) from CPeriod to CPeriod{
	@:op(A + B) static public function op_add(lhs:Period, rhs:Period):Period{
    return lhs.getRaw() + rhs.getRaw();
  }
  @:op(A - B) static public function op_sub(lhs:Period, rhs:Period):Period{
    return lhs.getRaw() - rhs.getRaw();
  }
  @:op(A / B) static public function op_div(lhs:Period, rhs:Period):Period{
    return lhs.getRaw() / rhs.getRaw();
  }
  @:op(A * B) static public function op_mul(lhs:Period, rhs:Period):Period{
    return lhs.getRaw() * rhs.getRaw();
  }
  public function new(?v){
    this = v == null ? new CPeriod() : v;
  }
  @:from static public function fromFloat(f:Float):Period{
  	return new CPeriod().setRaw(f);
  }
  @:from static public function fromDate(dt:Date):Period{
  	return new CPeriod().setRaw(dt.getTime());
  }
  @:to public function toDate():Date{
  	return this.toDate();
  }
  @:to public function toFloat():Float{
  	return this.getRaw();
  }
  public function getRaw():Float{
  	return this.getRaw();
  }
  public function add(t:Period):Period {
		return this.add(t);
	}
	@doc("Subtracts Periods.")
	public function sub(t:Period):Period {
		return this.sub(t);
	}
	@doc("Multiplies Periods.")
	public function mul(t:Period):Period {
		return this.mul(t);
	}
	@doc("Divides Periods.")
	public function div(t:Period):Period {
		return this.div(t);
	}
	public function mod(t:Period):Period {
		return this.mod(t);
	}
	public function compare(t:Period):Int{
		return stx.Maths.Floats.compare(getRaw(),t.getRaw());
	}
	static public function now():Period {
		return CPeriod.now();
	}
	static public function day(m:Int = 1):Period {
		return CPeriod.day(m);
	}
	static public function hour(m:Int = 1):Period {
		return CPeriod.hour(m);
	}
	static public function minute(m:Int = 1):Period {
		return CPeriod.minute(m);
	}
	static public function second(m:Int = 1):Period {
		return CPeriod.second(m);
	}
	static public function millisecond(m:Int = 1):Period {
		return CPeriod.millisecond(m);
	}
}