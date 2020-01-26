package;

typedef EventHandler = (e:js.html.Event) -> Void;

enum abstract VoidElemTag(String) to String from String {
  var Area = "area";
  var Base = "base";
  var Br = "br";
  var Col = "col";
  var Embed = "embed";
  var Hr = "hr";
  var Img = "img";
  var Input = "input";
  var Link = "link";
  var Meta = "meta";
  var Param = "param";
  var Source = "source";
  var Track = "track";
  var Wbr = "wbr";

  public function attr(a:Attrib):Html {
    return VoidElem(this, [a]);
  }

}

enum abstract ElemTag(String) to String from String {
  var A = "a";
  var Abbr = "abbr";
  var Address = "address";
  var Article = "article";
  var Aside = "aside";
  var Audio = "audio";
  var B = "b";
  var Bdi = "bdi";
  var Bdo = "bdo";
  var Blockquote = "blockquote";
  var Body = "body";
  var Button = "button";
  var Canvas = "canvas";
  var Caption = "caption";
  var Cite = "cite";
  var Code = "code";
  var Colgroup = "colgroup";
  var Data = "data";
  var Datalist = "datalist";
  var Dd = "dd";
  var Del = "del";
  var Details = "details";
  var Dfn = "dfn";
  var Dialog = "dialog";
  var Div = "div";
  var Dl = "dl";
  var Dt = "dt";
  var Em = "em";
  var Fieldset = "fieldset";
  var Figcaption = "figcaption";
  var Figure = "figure";
  var Footer = "footer";
  var Form = "form";
  var H1 = "h1";
  var H2 = "h2";
  var H3 = "h3";
  var H4 = "h4";
  var H5 = "h5";
  var H6 = "h6";
  var Head = "head";
  var Header = "header";
  var Hgroup = "hgroup";
  var Html = "html";
  var I = "i";
  var Iframe = "iframe";
  var Ins = "ins";
  var Kbd = "kbd";
  var Label = "label";
  var Legend = "legend";
  var Li = "li";
  var Main = "main";
  var Map = "map";
  var Mark = "mark";
  var Meter = "meter";
  var Nav = "nav";
  var Noscript = "noscript";
  var Object = "object";
  var Ol = "ol";
  var Optgroup = "optgroup";
  var Option = "option";
  var Output = "output";
  var P = "p";
  var Picture = "picture";
  var Pre = "pre";
  var Progress = "progress";
  var Q = "q";
  var Rb = "rb";
  var Rp = "rp";
  var Rt = "rt";
  var Rtc = "rtc";
  var Ruby = "ruby";
  var S = "s";
  var Samp = "samp";
  var Script = "script";
  var Section = "section";
  var Select = "select";
  var Small = "small";
  var Span = "span";
  var Strong = "strong";
  var Style = "style";
  var Sub = "sub";
  var Summary = "summary";
  var Sup = "sup";
  var Table = "table";
  var Tbody = "tbody";
  var Td = "td";
  var Template = "template";
  var Textarea = "textarea";
  var Tfoot = "tfoot";
  var Th = "th";
  var Thead = "thead";
  var Time = "time";
  var Title = "title";
  var Tr = "tr";
  var U = "u";
  var Ul = "ul";
  var Var = "var";
  var Video = "video";
  
  public function attr(a:Attrib):Html {
    return Elem(this, [a], []);
  }

  public function with(c:Html):Html {
    return Elem(this, [], [c]);
  }

  public function withText(s:String):Html {
    return Elem(this, [], [TextElem(s)]);
  }

}

enum abstract EventName(String) from String to String {
  var OnClick = "click";
  var OnInput = "input";

  @:op(A => B)
  public function setTo(h:EventHandler): Attrib {
    return EventHandlerAttribute(this, h);
  }
}

enum abstract AttributeName(String) from String to String {
  var Class = "class";
  var Id = "id";
  var Value = "value";

  @:op(A => B)
  public function setString(s:String) : Attrib {
    return ElementAttribute(this, s);
  }

  @:op(A => B)
  public function setInt(i:Int) : Attrib {
    return ElementAttribute(this, Std.string(i));
  }

  @:op(A => B)
  public function setFloat(f:Float) : Attrib {
    return ElementAttribute(this, Std.string(f));
  }

  @:op(A => B)
  public function setBool(b:Bool) : Attrib {
    return ElementAttribute(this, Std.string(b));
  }
}

@:using(Html.AttribExtensions)
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


@:using(Html.HtmlExtensions)
enum Html {
  VoidElem(tag:VoidElemTag, attributes:Array<Attrib>);
  TextElem(string:String);
  Elem(tag:ElemTag, attributes:Array<Attrib>, children: Array<Html>);
}

class HtmlExtensions {

  public static function attr(e:Html, a:Attrib): Html {
    return switch (e) {
    case Elem(_,attribs,_) | VoidElem(_,attribs): {
      attribs.push(a);
      e;
    };
    default: throw "TextNodes have no attribues";
    }
  }

  public static function withText(e:Html, s:String) : Html {
    return switch (e) {
    case Elem(_, _, children): {
      children.push(TextElem(s));
      e;
    }
    case TextElem(_): TextElem(s);
    default: throw "VoidElem cannot contain a text node";
    };
  }

  public static function with(e:Html, c:Html) : Html {
    return switch (e) {
    case Elem(_,_,children): {
      children.push(c);
      e;
    };
    default: throw "Only Elem has children";
    }
  }

  public static function realize (elem:Html) : js.html.Node {
    switch (elem) {
 
   case TextElem(string):
      return js.Browser.document.createTextNode(string);

    case VoidElem(tag, attribs): {
      var node = js.Browser.document.createElement(tag);

      for (a in attribs) a.realizeOn(node);

      return node;
    };

    case Elem(tag, attribs, children): {
      var node = js.Browser.document.createElement(tag);

      for (a in attribs) a.realizeOn(node);

      for (c in children) node.appendChild( realize(c) );

      return node;
    };
    }
  }


  public static function childCount(elem:Html):Int {
    return switch (elem) {
    case Elem(_,_,children): children.length;
    default: 0;
    };
  }

  public static function nthChild(elem:Html, i:Int): Null<Html> {
    return switch (elem) {
    case Elem(_,_,children) if (i < children.length): children[i];
    default: null;
    };
  }

  // retturns true if the tags differ, or if the text differs
  // but doesn't consider children or attributes
  public static function differsFromNode(thisElem:Html, otherElem:Html) : Bool {
    return switch ([thisElem, otherElem]) {
    case [VoidElem(tag1, attrs1), VoidElem(tag2, attrs2)]:  tag1 != tag2;
    case [TextElem(t1), TextElem(t2)]: t1 != t2;
    case [Elem(t1,_,_), Elem(t2,_,_)]: t1 != t2;
    default: false;
    };
  }

  public static function getAttributes(elem:Html): Array<Attrib> {
    return switch (elem) {
    case VoidElem(_,a)| Elem(_,a,_): a;
    default: [];
    };
  }

}



