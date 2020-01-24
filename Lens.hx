package;

typedef LensType<T,F> =
  { get : (record:T) -> F,
    set : (field:F, record:T) -> T
  };

@:forward(get,set)
abstract Lens<T,F>(LensType<T,F>) from LensType<T,F> to LensType<T,F> {
  inline function new (l) {
    this = l;
  }

  //  @:op(A * B)
  public function compose<G>(other:Lens<F,G>): Lens<T,G> {
    return { get : (t:T) -> other.get( this.get( t ) ),
              set : (g:G,t:T) -> this.set( other.set( g, this.get( t ) ), t )
              };
  }

  @:op(a.b)
  public function dotOp<G>(field:String): Lens<T,G> {
    var other: Lens<F,G> = Lens.on(field);
    return compose(other);
  }

  @:op(a.b)
  public function setOp<G>(field:String, val:G): StateTransform<T> {
    var l: Lens<T,G> = dotOp(field);
    return (t:T) -> l.set(val, t);
  }

  public static function on<T1,F1>(field:String): Lens<T1,F1> {
    var get = (o:T1) -> (Reflect.field(o, field) : F1);
    var set = (f:F1,o:T1) ->
      {
       var copy = Reflect.copy(o);
       Reflect.setField(copy, field, f);
       return copy;
      };
    return {get: get, set: set};
  }
}
