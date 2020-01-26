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

  public function attribs(a:Array<Attrib>):Html {
    return VoidElem(this, a);
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
  
  public function attribs(a:Array<Attrib>):Html {
    return Elem(this, a, []);
  }
  
  public function children(c:Array<Html>):Html {
    return Elem(this, [], c);
  }

  public function add(c:Html):Html {
    return Elem(this, [], [c]);
  }

  public function withText(s:String):Html {
    return Elem(this, [], [TextElem(s)]);
  }

}


enum abstract EventName(String) from String to String {
  var Click = "click";

  @:op(A >= B)
  public function setTo(h:EventHandler): Attrib {
    return EventHandlerAttribute(this, h);
  }
}

enum abstract AttributeName(String) from String to String {
  var Class = "class";
  var Id = "id";

  @:op(A >= B)
  public function setString(s:String) : Attrib {
    return ElementAttribute(this, s);
  }

  @:op(A >= B)
  public function setInt(i:Int) : Attrib {
    return ElementAttribute(this, Std.string(i));
  }

  @:op(A >= B)
  public function setFloat(f:Float) : Attrib {
    return ElementAttribute(this, Std.string(f));
  }

  @:op(A >= B)
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

  public static function realizeOn(attrib:Attrib, node: js.html.Element) {
    switch (attrib) {
    case EventHandlerAttribute(event, handler): node.addEventListener(event, handler);
    case ElementAttribute(name, value): node.setAttribute(name, value);
    }
  }
}


@:using(Html.HtmlExtensions)
enum Html {
  VoidElem(tag:VoidElemTag, attributes:Array<Attrib>);
  TextElem(string:String);
  Elem(tag:ElemTag, attributes:Array<Attrib>, children: Array<Html>);
}

class HtmlExtensions {

  public static function attribs(e:Html, a:Array<Attrib>): Html {
    return switch (e) {
    case VoidElem(tag, _): VoidElem(tag,a);
    case Elem(tag, _, children): Elem(tag,a,children);
    default: throw "TextElem has no attributes";
    };
  }

  public static function children(e:Html, c:Array<Html>) : Html {
    return switch (e) {
    case Elem(tag,attribs,_): Elem(tag,attribs,c);
    default: throw "Only Elem has children";
    };
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

  public static function add(e:Html, c:Html) : Html {
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
}




















@:using(Html.HtmlExtensions)
enum Html {
  A(attribs:Array<Attrib>, children:Array<Html>);
  Abbr(attribs:Array<Attrib>, children:Array<Html>);
  Address(attribs:Array<Attrib>, children:Array<Html>);
  Area(attribs:Array<Attrib>);
  Article(attribs:Array<Attrib>, children:Array<Html>);
  Aside(attribs:Array<Attrib>, children:Array<Html>);
  Audio(attribs:Array<Attrib>, children:Array<Html>);
  B(attribs:Array<Attrib>, children:Array<Html>);
  Base(attribs:Array<Attrib>);
  Bdi(attribs:Array<Attrib>, children:Array<Html>);
  Bdo(attribs:Array<Attrib>, children:Array<Html>);
  Blockquote(attribs:Array<Attrib>, children:Array<Html>);
  Body(attribs:Array<Attrib>, children:Array<Html>);
  Br(attribs:Array<Attrib>);
  Button(attribs:Array<Attrib>, children:Array<Html>);
  Canvas(attribs:Array<Attrib>, children:Array<Html>);
  Caption(attribs:Array<Attrib>, children:Array<Html>);
  Cite(attribs:Array<Attrib>, children:Array<Html>);
  Code(attribs:Array<Attrib>, children:Array<Html>);
  Col(attribs:Array<Attrib>);
  Colgroup(attribs:Array<Attrib>, children:Array<Html>);
  Data(attribs:Array<Attrib>, children:Array<Html>);
  Datalist(attribs:Array<Attrib>, children:Array<Html>);
  Dd(attribs:Array<Attrib>, children:Array<Html>);
  Del(attribs:Array<Attrib>, children:Array<Html>);
  Details(attribs:Array<Attrib>, children:Array<Html>);
  Dfn(attribs:Array<Attrib>, children:Array<Html>);
  Dialog(attribs:Array<Attrib>, children:Array<Html>);
  Div(attribs:Array<Attrib>, children:Array<Html>);
  Dl(attribs:Array<Attrib>, children:Array<Html>);
  Dt(attribs:Array<Attrib>, children:Array<Html>);
  Em(attribs:Array<Attrib>, children:Array<Html>);
  Embed(attribs:Array<Attrib>);
  Fieldset(attribs:Array<Attrib>, children:Array<Html>);
  Figcaption(attribs:Array<Attrib>, children:Array<Html>);
  Figure(attribs:Array<Attrib>, children:Array<Html>);
  Footer(attribs:Array<Attrib>, children:Array<Html>);
  Form(attribs:Array<Attrib>, children:Array<Html>);
  H1(attribs:Array<Attrib>, children:Array<Html>);
  H2(attribs:Array<Attrib>, children:Array<Html>);
  H3(attribs:Array<Attrib>, children:Array<Html>);
  H4(attribs:Array<Attrib>, children:Array<Html>);
  H5(attribs:Array<Attrib>, children:Array<Html>);
  H6(attribs:Array<Attrib>, children:Array<Html>);
  Head(attribs:Array<Attrib>, children:Array<Html>);
  Header(attribs:Array<Attrib>, children:Array<Html>);
  Hgroup(attribs:Array<Attrib>, children:Array<Html>);
  Hr(attribs:Array<Attrib>);
  Html(attribs:Array<Attrib>, children:Array<Html>);
  I(attribs:Array<Attrib>, children:Array<Html>);
  Iframe(attribs:Array<Attrib>, children:Array<Html>);
  Img(attribs:Array<Attrib>);
  Input(attribs:Array<Attrib>);
  Ins(attribs:Array<Attrib>, children:Array<Html>);
  Kbd(attribs:Array<Attrib>, children:Array<Html>);
  Label(attribs:Array<Attrib>, children:Array<Html>);
  Legend(attribs:Array<Attrib>, children:Array<Html>);
  Li(attribs:Array<Attrib>, children:Array<Html>);
  Link(attribs:Array<Attrib>);
  Main(attribs:Array<Attrib>, children:Array<Html>);
  Map(attribs:Array<Attrib>, children:Array<Html>);
  Mark(attribs:Array<Attrib>, children:Array<Html>);
  Meta(attribs:Array<Attrib>);
  Meter(attribs:Array<Attrib>, children:Array<Html>);
  Nav(attribs:Array<Attrib>, children:Array<Html>);
  Noscript(attribs:Array<Attrib>, children:Array<Html>);
  Object(attribs:Array<Attrib>, children:Array<Html>);
  Ol(attribs:Array<Attrib>, children:Array<Html>);
  Optgroup(attribs:Array<Attrib>, children:Array<Html>);
  Option(attribs:Array<Attrib>, children:Array<Html>);
  Output(attribs:Array<Attrib>, children:Array<Html>);
  P(attribs:Array<Attrib>, children:Array<Html>);
  Param(attribs:Array<Attrib>);
  Picture(attribs:Array<Attrib>, children:Array<Html>);
  Pre(attribs:Array<Attrib>, children:Array<Html>);
  Progress(attribs:Array<Attrib>, children:Array<Html>);
  Q(attribs:Array<Attrib>, children:Array<Html>);
  Rb(attribs:Array<Attrib>, children:Array<Html>);
  Rp(attribs:Array<Attrib>, children:Array<Html>);
  Rt(attribs:Array<Attrib>, children:Array<Html>);
  Rtc(attribs:Array<Attrib>, children:Array<Html>);
  Ruby(attribs:Array<Attrib>, children:Array<Html>);
  S(attribs:Array<Attrib>, children:Array<Html>);
  Samp(attribs:Array<Attrib>, children:Array<Html>);
  Script(attribs:Array<Attrib>, children:Array<Html>);
  Section(attribs:Array<Attrib>, children:Array<Html>);
  Select(attribs:Array<Attrib>, children:Array<Html>);
  Small(attribs:Array<Attrib>, children:Array<Html>);
  Source(attribs:Array<Attrib>);
  Span(attribs:Array<Attrib>, children:Array<Html>);
  Strong(attribs:Array<Attrib>, children:Array<Html>);
  Style(attribs:Array<Attrib>, children:Array<Html>);
  Sub(attribs:Array<Attrib>, children:Array<Html>);
  Summary(attribs:Array<Attrib>, children:Array<Html>);
  Sup(attribs:Array<Attrib>, children:Array<Html>);
  Table(attribs:Array<Attrib>, children:Array<Html>);
  Tbody(attribs:Array<Attrib>, children:Array<Html>);
  Td(attribs:Array<Attrib>, children:Array<Html>);
  Template(attribs:Array<Attrib>, children:Array<Html>);
  Textarea(attribs:Array<Attrib>, children:Array<Html>);
  Text(s:String); // just made up for containing text...
  Tfoot(attribs:Array<Attrib>, children:Array<Html>);
  Th(attribs:Array<Attrib>, children:Array<Html>);
  Thead(attribs:Array<Attrib>, children:Array<Html>);
  Time(attribs:Array<Attrib>, children:Array<Html>);
  Title(attribs:Array<Attrib>, children:Array<Html>);
  Tr(attribs:Array<Attrib>, children:Array<Html>);
  Track(attribs:Array<Attrib>);
  U(attribs:Array<Attrib>, children:Array<Html>);
  Ul(attribs:Array<Attrib>, children:Array<Html>);
  Var(attribs:Array<Attrib>, children:Array<Html>);
  Video(attribs:Array<Attrib>, children:Array<Html>);
  Wbr(attribs:Array<Attrib>);
}

class HtmlExtensions {

  public static function tagName(html:Html):String {
    return Type.enumConstructor(html).toLowerCase();
  }

  public static function realize(elem:Html): js.html.Node {
    return switch (elem) {
    case Text(s):
      js.Browser.document.createTextNode(s);

    case
  }

}