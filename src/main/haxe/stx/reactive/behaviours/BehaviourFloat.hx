package stx.rct.behaviours;

import funk.Funk;
import stx.rct.Behaviour;
import stx.rct.Propagation;
import stx.rct.streams.StreamBool;


using stx.Tuples;
using stx.rct.Stream;
using stx.rct.Behaviour;
using stx.rct.streams.StreamBool;

class BehaviourFloat {

    public static function plus(behaviour0 : Behaviour<Float>, behaviour1 : Behaviour<Float>) : Behaviour<Float> {
        return behaviour0.zip(behaviour1).lift(function(tuple) return tuple._1() + tuple._2());
    }

    public static function minus(behaviour0 : Behaviour<Float>, behaviour1 : Behaviour<Float>) : Behaviour<Float> {
        return behaviour0.zip(behaviour1).lift(function(tuple) return tuple._1() - tuple._2());
    }

    public static function multiply(    behaviour0 : Behaviour<Float>,
                                        behaviour1 : Behaviour<Float>) : Behaviour<Float> {
        return behaviour0.zip(behaviour1).lift(function(tuple) return tuple._1() * tuple._2());
    }

    public static function modulo(  behaviour0 : Behaviour<Float>,
                                    behaviour1 : Behaviour<Float>) : Behaviour<Float> {
        return behaviour0.zip(behaviour1).lift(function(tuple) return tuple._1() % tuple._2());
    }

    public static function divide(  behaviour0 : Behaviour<Float>,
                                    behaviour1 : Behaviour<Float>) : Behaviour<Float> {
        return behaviour0.zip(behaviour1).lift(function(tuple) return tuple._1() / tuple._2());
    }
}
