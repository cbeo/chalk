package;

import haxe.Constraints;

class ConcreteState<T> {
  var state:T;
  var postUpdateActions:Array<Void->Void> = [];

  public var onTransformError:Function = null;

  function postUpdate() {
    for (callback in postUpdateActions) callback();
  }

  public var _read_(get,never):T;

  function get__read_(): T {
    return state;
  }

  public function _write_(tform: StateTransform<T>) {
    var oldState = state;
    try {

      state = tform(state);
      postUpdate();

    } catch (e:Dynamic) {

      trace('Error on update: $e');

      if (onTransformError != null) {
        trace('Error Handler Exists, Evoking Now');

        try {onTransformError(e);} catch (e2:Dynamic) {
          trace('Error encountered while attempting to handle state transform error');
          trace('New Error = $e2');
        }
      }

      trace('Restoring from last good state');
      state = oldState;
      postUpdate();

    }
  }

  public function register(callback:Void->Void) {
    postUpdateActions.push(callback);
  }

  public function unregister(callback:Void->Void) {
    postUpdateActions.remove(callback);
  }

  public inline function new(t) {
    state = t;
  }
}

@:forward(_read_,_write_,register,unregister)
abstract State<T>(ConcreteState<T>) {

  inline public function new(t:T) {
    this = new ConcreteState(t);
  }

  @:from
  static public function from<T>(t:T) {
    return new State(t);
  }

  @:op(a.b)
  public function field<F>(name:String):Lens<T,F> {
    return Lens.on(name);
  }

}

