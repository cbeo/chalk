package;

class DomUtils {
  public static function getElementById<E:js.html.Element>(id:String):E {
    return cast js.Browser.document.getElementById(id);
  }
}