package funk.actors.patterns;

import funk.actors.ActorRef;
import funk.actors.Props;
import funk.futures.Deferred;
import funk.types.Any;
import funk.types.Attempt;
import funk.types.Pass;
import funk.types.extensions.Strings;

using funk.futures.Promise;

@:support('#0b1kn00b: why the sender param not used?')
class AskSupport {

    public static function ask( actor : ActorRef,
                                value : AnyRef,
                                sender : ActorRef) : Promise<AnyRef> {
        var deferred = new Deferred();
        var promise = deferred.promise();

        var system = actor.context().system();
        var name = '${actor.name()}_promise_${Strings.uuid()}';
        var creator = new AskSupportRefCreator(deferred);
        var askRef = system.actorOf(new Props().withCreator(creator), name);

        actor.send(value, askRef);

        return promise;
    }
}

private class AskSupportRef extends Actor {

    private var _deferred : Deferred<AnyRef>;

    public function new(deferred : Deferred<AnyRef>) {
        super();

        _deferred = deferred;
    }
    @:support("#0b1kn00b: Abstracts aren't always types: this might break code in other platforms, but the cast foxes the pattern matching in js.")
    override public function receive(value : AnyRef) : Void {
        function dispatch(attempt : AttemptType<AnyRef>) {
            switch(attempt){
                case Success(v): 
                    _deferred.resolve(v);
                case Failure(e): 
                _deferred.reject(e);
            }
        }
        switch(Type.typeof(value)) {
            case TEnum(e) if(e == AttemptType): dispatch(value);
            //case TClass(c) if(c == Attempt): dispatch(c);
            case _: _deferred.resolve(value);
        }
    }
}

private class AskSupportRefCreator implements Creator {

    private var _deferred : Deferred<AnyRef>;

    public function new(deferred : Deferred<AnyRef>) {
        _deferred = deferred;
    }

    public function create() : Actor return Pass.instanceOf(AskSupportRef, [_deferred])();
}

