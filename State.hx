package;

import haxe.ds.Option;

class ConcreteState<T> {
  var state:T;

  function updateViews() {
  }

  public function fields(name:String):Option<Any> {
    return if (Reflect.hasField(state,name) || Reflect.hasField(state,"get_"+name))
      Some(Reflect.getProperty(state,name))
      else None;
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