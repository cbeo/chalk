package;

class ConcreteState<T> {
  public var state(default,null):T;
  //  var views:Array<View>;

  function renderViews(s:T) {
    trace('rendering views...');
    // for (v in view)
    //   v.render(); // TODO handle "Err(...)" return values
  }

  public function write(tform: StateTransform<T>) {
    try {

      var newState = tform(state);
      renderViews(newState);
      state = newState;

    } catch (e:Dynamic) {

      trace('Error on update: $e');
      trace('Restoring from last good state');
      renderViews(state);

    }
  }

  public inline function new(t) {
    state = t;
  }
}

@:forward(read,write,state)
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

  @:op(a.b)
  public function setField<F>(name:String, val:F):StateTransform<T> {
    var l: Lens<T,F> = field(name);
    return (t:T) -> l.set(val,t);
  }

}

