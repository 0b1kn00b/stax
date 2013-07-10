package stx.rct.behaviours;

import funk.Funk;
import stx.rct.Behaviour;
import stx.rct.Propagation;
import stx.rct.streams.StreamBool;
import funk.types.Tuple1;

using stx.rct.Stream;
using stx.rct.Behaviour;
using stx.rct.streams.StreamBool;

class BehaviourBool {

    public static function not(behaviour : Behaviour<Bool>) : Behaviour<Bool> {
        return StreamBool.not(behaviour.stream()).startsWith(!behaviour.value());
    }

    public static function ifThen<T>(    condition : Behaviour<Bool>,
                                        thenBlock : Behaviour<T>) : Behaviour<T> {
        return StreamBool.ifThen(condition.stream(), thenBlock.stream()).startsWith(
            if(condition.value()) thenBlock.value();
        );
    }

    public static function ifThenElse<T>(    condition : Behaviour<Bool>,
                                            thenBlock : Behaviour<T>,
                                            elseBlock : Behaviour<T>) : Behaviour<T> {
        return StreamBool.ifThenElse(condition.stream(), thenBlock.stream(), elseBlock.stream()).startsWith(
            if(condition.value()) thenBlock.value();
            else elseBlock.value();
        );
    }
}
