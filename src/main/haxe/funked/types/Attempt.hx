package funk.types;

import funk.Funk;
import funk.types.Attempt;
import funk.types.Either;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Predicate2;
import funk.types.Any;

using funk.types.extensions.Bools;
using funk.types.Option;

enum AttemptType<T> {
    Success(value : T);
    Fail(error : Fails);
}

abstract Attempt<T>(AttemptType<T>) from AttemptType<T> to AttemptType<T> {

    inline function new(attempt : AttemptType<T>) {
        this = attempt;
    }

    @:from
    inline public static function fromValue<T>(value : T) : Attempt<T> {
        return AttemptTypes.toAttempt(value);
    }

    @:to
    inline public static function toOption<T>(attempt : AttemptType<T>) : Option<T> {
        return AttemptTypes.toOption(attempt);
    }

    @:to
    inline public static function toString<T>(attempt : AttemptType<T>) : String {
        return AttemptTypes.toString(attempt);
    }
}

class AttemptTypes {

    public static function isSuccessful<T>(attempt : Attempt<T>) : Bool {
        return switch(attempt) {
            case Success(_): true;
            case _: false;
        }
    }

    public static function isFail<T>(attempt : Attempt<T>) : Bool {
        return !isSuccessful(attempt);
    }

    public static function success<T>(attempt : Attempt<T>) : Option<T> {
        return switch(attempt) {
            case Success(value): OptionTypes.toOption(value);
            case _: None;
        }
    }

    public static function failure<T>(attempt : Attempt<T>) : Option<Fails> {
        return switch(attempt) {
            case Fail(value): OptionTypes.toOption(value);
            case _: None;
        }
    }

    public static function swap<T>(attempt : Attempt<T>) : Attempt<Fails> {
        return switch(attempt) {
            case Fail(value): Success(value);
            case _: Fail(Fail("Fail"));
        }
    }

    public static function flatten<T>(attempt : Attempt<Attempt<T>>) : Attempt<T> {
        return switch(attempt) {
            case Success(value): value;
            case Fail(value): Fail(value);
        }
    }

    public static function flattenSuccess<T>(attempt : Attempt<Attempt<T>>) : Attempt<T> {
        return switch(attempt) {
            case Success(value): value;
            case _: Funk.error(IllegalOperationFail());
        }
    }

    public static function flattenFail<T>(attempt : Attempt<Attempt<T>>) : Attempt<Fails> {
        return switch(attempt) {
            case Fail(value): Fail(value);
            case _: Funk.error(IllegalOperationFail());
        }
    }

    public static function fold<T1, T2>(    attempt : Attempt<T1>,
                                            funcSuccess : Function1<T1, T2>,
                                            funcFail : Function1<Fails, T2>
                                            ) : T2 {
        return switch(attempt) {
            case Success(value): funcSuccess(value);
            case Fail(error): funcFail(error);
        }
    }

    public static function foldSuccess<T1, T2>(attempt : Attempt<T1>, func : Function1<T1, T2>) : T2 {
        return switch(attempt) {
            case Success(value): func(value);
            case _: Funk.error(IllegalOperationFail());
        }
    }

    public static function foldFail<T1, T2>(attempt : Attempt<T1>, func : Function1<Fails, T2>) : T2 {
        return switch(attempt) {
            case Fail(value): func(value);
            case _: Funk.error(IllegalOperationFail());
        }
    }

    public static function map<T1, T2>( attempt : Attempt<T1>,
                                        funcSuccess : Function1<T1, T2>,
                                        funcFail : Function1<Fails, Fails>
                                        ) : Attempt<T2> {
        return switch(attempt) {
            case Success(value): Success(funcSuccess(value));
            case Fail(value): Fail(funcFail(value));
        }
    }

    public static function mapSuccess<T1, T2>(attempt : Attempt<T1>, func : Function1<T1, T2>) : Attempt<T2> {
        return switch(attempt) {
            case Success(value): Success(func(value));
            case _: Funk.error(IllegalOperationFail());
        }
    }

    public static function mapFail<T>(attempt : Attempt<T>, func : Function1<Fails, Fails>) : Attempt<T> {
        return switch(attempt) {
            case Fail(value): Fail(func(value));
            case _: Funk.error(IllegalOperationFail());
        }
    }

    public static function equals<T>(   a : Attempt<T>,
                                        b : Attempt<T>,
                                        ?funcSuccess : Predicate2<T, T>,
                                        ?funcFail : Predicate2<Fails, Fails>
                                        ) : Bool {
        return switch (a) {
            case Success(left0):
                switch (b) {
                    case Success(left1): AnyTypes.equals(left0, left1, funcSuccess);
                    case _: false;
                }
            case Fail(right0):
                switch (b) {
                    case Fail(right1): AnyTypes.equals(right0, right1, funcFail);
                    case _: false;
                }
        }
    }

    public static function toEither<T>(attempt : Attempt<T>) : Either<Fails, T> {
        return switch(attempt) {
            case Success(value): Right(value);
            case Fail(value): Left(value);
        }
    }

    public static function toBool<T>(attempt : Attempt<T>) : Bool {
        return switch(attempt) {
            case Success(_): true;
            case _: false;
        }
    }

    public static function toOption<T>(attempt : Attempt<T>) : Option<T> {
        return switch(attempt) {
            case Success(value): Some(value);
            case _: None;
        }
    }

    public static function toAttempt<T>(any : Null<T>) : Attempt<T> {
        return AnyTypes.toBool(any).not() ? Fail(Fail("Fail")) : Success(any);
    }

    inline public static function toString<T>( attempt : Attempt<T>,
                                        ?funcSuccess : Function1<T, String>,
                                        ?funcFail : Function1<Fails, String>) : String {
        return switch (attempt) {
            case Success(value): 'Success(${AnyTypes.toString(value, funcSuccess)})';
            case Fail(value): 'Fail(${AnyTypes.toString(value, funcFail)})';
        }
    }
}
