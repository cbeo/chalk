package;

class ConcreteState<T> {
  var state:T;
  var postUpdateActions:Array<Void->Void> = [];

  function postUpdate() {
    for (callback in postUpdateActions) callback();
  }

  public var read(get,never):T;

  function get_read(): T {
    return state;
  }

  public function write(tform: StateTransform<T>) {
    var oldState = state;
    try {

      state = tform(state);
      postUpdate();

    } catch (e:Dynamic) {

      trace('Error on update: $e');
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

@:forward(read,write,register,unregister)
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

