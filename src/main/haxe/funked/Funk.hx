package funk;

import funk.types.extensions.EnumValues;
import haxe.CallStack;
import haxe.PosInfos;

enum Fails {
    Abstract;
    AbstractMethod;
    ActorFail(message : String);
    ActorKillFail(message : String);
    ArgumentFail(?message : String);
    BindingFail(message : String);
    Fail(message : String);
    HttpFail(message : String);
    IllegalOperationFail(?message : String);
    IndexOutOfBoundsFail(index : Int);
    InjectorFail(message : String);
    NoSuchElementFail;
    RangeFail;
    TypeFail(?message : String);
}

class FunkFail {

    private var _error : Fails;

    private var _message : String;

    private var _posInfo : PosInfos;

    private var _stack : Array<StackItem>;

    public function new(    error : Fails,
                            message : String,
                            posInfo : PosInfos,
                            ?stack : Array<StackItem>
                            ) {
        _error = error;
        _message = message;
        _posInfo = posInfo;
        _stack = stack;
    }

    public function error() : Fails return _error;

    public function message() : String return _message;

    public function posInfo() : PosInfos return _posInfo;

    public function stack() : Array<StackItem> return _stack;

    public function toString() : String {
        return '${EnumValues.getEnumName(_error)}: ${_message} ${CallStack.toString(_stack)}';
    }
}

class Funk {

    @:noUsing
    public static function error<T>(type : Fails, ?posInfo : PosInfos) : T {
        var message = switch(type) {
            case Abstract: 'Type is abstract, you must extend it';
            case AbstractMethod: 'Method is abstract, you must override it';
            case ActorFail(msg): msg;
            case ActorKillFail(msg): msg;
            case ArgumentFail(msg): msg == null ? 'Arguments supplied are not expected' : msg;
            case BindingFail(msg): msg;
            case Fail(msg): msg;
            case HttpFail(msg): msg;
            case IllegalOperationFail(msg): msg == null ? 'Required operation can not be executed' : msg;
            case IndexOutOfBoundsFail(index): 'No element exists with in the bounds $index';
            case InjectorFail(msg): msg;
            case NoSuchElementFail: 'No such element exists';
            case RangeFail: 'Value is outside of the expected range';
            case TypeFail(msg): msg == null ? 'Type error was thrown' : msg;
        }

        var stack = CallStack.callStack();
        // Remove the first item as it's always going to be Funk.error
        if (stack.length > 0) stack.shift();

        var error = new FunkFail(type, message, posInfo, stack);

        #if (debug && !sys) trace(error.toString()); #end

        // Why does this not bubble up, I wonder who is catching this?
        throw error;

        return null;
    }

    @:noUsing
    public static function main() : Void {
    }
}
