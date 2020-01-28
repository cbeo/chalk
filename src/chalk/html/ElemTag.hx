package chalk.html;

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
  
  inline public function attr(a:Attrib):Html {
    return Elem(this, [a], []);
  }

  inline public function with(c:Html):Html {
    return Elem(this, [], [c]);
  }

  inline public function withAll(cs:Array<Html>):Html {
    return Elem(this, [], cs);
  }

  inline public function withText(s:String):Html {
    return Elem(this, [], [TextElem(s)]);
  }

  inline public function elem():Html {
    return Elem(this,[],[]);
  }

}
