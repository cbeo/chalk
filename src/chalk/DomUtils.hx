package chalk;

class DomUtils {
 
  public static function query<E:js.html.Node>(q:String):E {
    return cast js.Browser.document.querySelector(q);
  }

  public static function byId<E:js.html.Node>(id:String):E {
    return cast js.Browser.document.getElementById(id);
  }

}