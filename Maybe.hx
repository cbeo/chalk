package;

@:using(Maybe.MaybeExtensions)
enum Maybe<T> {
  Just(val:T);
  Nothing;
}

class MaybeExtensions {
  public static function isJust<T>(o:Maybe<T>):Bool {
    return switch (o) {
    case Just(_): true;
    default: false;
    };
  }

  public static function isNothing<T>(o:Maybe<T>):Bool {
    return !isJust(o);
  }

  public static function map<T,U>(o:Maybe<T>, fn: T->U):Maybe<U> {
    return switch (o) {
    case Nothing: Nothing;
    case Just(t): Just(fn(t));
    };
  }

  public static function then<T,U>(o:Maybe<T>, fn:T -> Maybe<U>):Maybe<U> {
    return switch (o) {
    case Nothing: Nothing;
    case Just(t): fn(t);
    };
  }

  public static function onJust<T>(o:Maybe<T>, fn:T->Void):Maybe<T> {
    map(o, fn);
    return o;
  }

  public static function onNothing<T>(o:Maybe<T>, fn:Void->Void):Maybe<T> {
    if (isNothing(o)) fn();
    return o;
  }


  public static function filter<T>(o:Maybe<T>, pred:T->Bool):Maybe<T> {
    return switch (o) {
    case Just(t) if(pred(t)): Just(t);
    default: Nothing;
    };
  }

  public static function join<T,U,V>(o1:Maybe<T>, fn:(t:T,u:U)->V, o2:Maybe<U>):Maybe<V> {
    return then(o1, t -> then(o2, u -> fn(t,u)));
  }

  public function fold<T,U>(o:Maybe<T>, acc: U, fn:(u:U,t:T) -> V): U {
    return switch (o) {
    case Just(t): fn(u,t);
    default: u;
    }
  }
}