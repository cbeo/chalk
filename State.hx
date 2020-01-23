package;

class ConcreteState<T> {
  var state:T;

  function updateViews() {
  }

  public function fields(name:String):Any {
    return Reflect.field(state,name);
  }

  public function checkout(fn:T -> Void) {
    fn(state);
    updateViews();
  }

  public function new(t) {
    state = t;
  }
}

@:forward(update,field);
abstract State<T>(ConcreteState<T>) from ConcreteState to ConcreteState {

  inline public function new(t:T) {
    this = new ConcreteState(t);
  }

  @:op(a.b) public function fieldRead(name:String) {
    return this.field(name);
  }
}