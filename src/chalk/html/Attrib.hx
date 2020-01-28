package chalk.html;

// import chalk.html.AttribName;
// import chalk.html.EventName;

@:using(Attrib.AttribExtensions)
enum Attrib {
  EventHandlerAttribute(event:EventName, handler: EventHandler);
  ElementAttribute(name:AttributeName, value: String);
}

// TODO: do I need a Boolean case too?
class AttribExtensions {

  public static function realizeOn(attrib:Attrib, node: js.html.Node) {
    var node : js.html.Element = (cast node);
    switch (attrib) {
    case EventHandlerAttribute(event, handler): node.addEventListener(event, handler);
    case ElementAttribute(name, value): node.setAttribute(name, value);
    }
  }

  public static function removeFrom(attrib:Attrib, node: js.html.Node) {
    var node : js.html.Element = (cast node);
    switch (attrib) {
    case EventHandlerAttribute(event,handler): node.removeEventListener(event, handler);
    case ElementAttribute(name,_): node.removeAttribute(name);
    }
  }

  public static function sameNameAs(a1: Attrib, a2: Attrib) : Bool {
    return switch ([a1,a2]) {
    case [EventHandlerAttribute(e1,_), EventHandlerAttribute(e2,_)]: e1 == e2;
    case [ElementAttribute(n1,_), ElementAttribute(n2,_)]: n1 == n2;
    default: false;
    };
  }

  public static function equals(a1: Attrib, a2: Attrib): Bool {
    return switch ([a1,a2]) {
    case [EventHandlerAttribute(e1,h1), EventHandlerAttribute(e2,h2)]:  e1 == e2 && h1 == h2;
    case [ElementAttribute(n1,s1), ElementAttribute(n2,s2)]: n1 == n2 && s1 == s2;
    default: false;
    };
  }

}

