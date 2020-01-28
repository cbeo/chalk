package chalk.html;

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

  inline public function attr(a:Attrib):Html {
    return VoidElem(this, [a]);
  }

  inline public function elem():Html {
    return VoidElem(this,[]);
  }

}
