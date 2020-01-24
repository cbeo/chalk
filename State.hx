package;

class ConcreteState<T> {
  var state:T;
  //  var views:Array<View>;

  function renderViews(s:T) {
    trace('rendering views...');
    // for (v in view)
    //   v.render(); // TODO handle "Err(...)" return values
  }

  public function read<F>(lens:Lens<T,F>):F {
    return lens.get(state);
  }

  public function write<F>(lens:Lens<T,F>, val:F) : F {
    try {

      var newState = lens.set(val,state);
      renderViews(newState);
      state = newState;
      return val;

    } catch (e:Dynamic) {

      trace('Error on update: $e');
      trace('Restoring from last good state');
      renderViews(state);
      return lens.get(state);

    }
  }

  public inline function new(t) {
    state = t;
  }
}

@:forward(read,write)
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


  // @:op(a.b) public function fieldRead<F>(name:String):F {
  //   var lens : Lens<T,F> = Lens.on(name);
  //   return this.read( lens );
  // }

  // @:op(a.b) public function writeField<F>(name:String, f:F) {
  //   var lens : Lens<T,F> = Lens.on(name);
  //   return this.write(lens, f);
  // }

