package chalk.html;

enum abstract AttributeName(String) from String to String {
  var Class = "class";
  var Id = "id";
  var Value = "value";
  var Action = "action";
  var Href = "href";
  var Method = "method";
  var Placeholder = "placeholder";
  var Src = "src";
  var Title = "title";

  @:op(A => B)
  inline public function setString(s:String) : Attrib {
    return ElementAttribute(this, s);
  }

  @:op(A => B)
  inline public function setInt(i:Int) : Attrib {
    return ElementAttribute(this, Std.string(i));
  }

  @:op(A => B)
  inline public function setFloat(f:Float) : Attrib {
    return ElementAttribute(this, Std.string(f));
  }

  @:op(A => B)
  inline public function setBool(b:Bool) : Attrib {
    return ElementAttribute(this, Std.string(b));
  }
}
