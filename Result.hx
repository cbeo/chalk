package;

@:using(Result.ResultExtensions)
enum Result<E,T> {
  Err(kind:E);
  Ok(ok:T);
}

class ResultExtensions {

  public static function isOk<E,T>(result: Result<E,T>): Bool {
    return switch (result) {
    case Ok(_): true;
    case _: false;
    };
  }

  public static function isErr<E,T>(result: Result<E,T>): Bool {
    return !isOk(result);
  }

  public static function then<E,T,U>(result: Result<E,T>, fn: (val:T) -> Result<E,U>): Result<E,U> {
    return switch (result) {
    case Ok(val): fn(val);
    case Err(e): Err(e);
    };
  }

  public static function map<E,T,U>(result: Result<E,T>, fn: (val:T) -> U): Result<E,U> {
    return switch (result) {
    case Ok(v): Ok(fn(v));
    case Err(e): Err(e);
    };
  }

  public static function mapError<E,T,F>(result: Result<E,T>, fn(e:E) -> F): Result<F,T> {
    result switch (result) {
    case Ok(v): Ok(v);
    case Err(e): Err(f);
    };
  }

  public static function onOk<E,T>(result: Result<E,T>, fn: (val:T) -> Void): Result<E,T> {
    map(result, fn);
    return result;
  }      

  public static function onError<E,T>(result: Result<E,T>, fn: (err:E) -> Void): Result<E,T> {
    mapError(result,fn);
    return result;
  }


}