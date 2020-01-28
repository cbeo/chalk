package chalk.html;

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

  public static function withAll(e:Html, cs:Array<Html>) : Html {
    return switch (e) {
    case Elem(_,_,children): {
      for (c in cs) children.push(c);
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



