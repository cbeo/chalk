package chalk.html;

enum abstract EventName(String) from String to String {
  var OnBlur = "blur";
  var OnClick = "click";
  var OnClose = "close";
  var OnError = "error";
  var OnFocus = "focus";
  var OnInput = "input";
  var OnKeyDown = "keydown";
  var OnKeyPress = "keypress";
  var OnKeyUp =  "keyup";
  var OnMessage = "message";
  var OnMouseDown = "mousedown";
  var OnMouseEnter = "mouseenter";
  var OnMouseLeave = "mouseleave";
  var OnMouseMove = "mousemove";
  var OnMouseOut = "mouseout";
  var OnMouseUp = "mouseup";
  var OnOpen = "open";
  var OnResize = "resize";
  var OnScroll = "scroll";
  var OnSelect = "select";
  var OnSubmit = "submit";
  var OnWheel = "wheel";

  @:op(A => B)
  inline public function setTo(h:EventHandler): Attrib {
    return EventHandlerAttribute(this, h);
  }
}
