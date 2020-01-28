package chalk;

import js.html.Node;
import chalk.html.*;

using Lambda;

class View<T> {

  private static function updateAttributes(dom:Node, oldElem: Html, newElem: Html) {
    var oldAttribs = oldElem.getAttributes();
    var newAttribs = newElem.getAttributes();
    // remove old attribs that are absent in the new element
    for (attrib in oldAttribs)
      if ( !newAttribs.exists( (a) -> a.sameNameAs( attrib ) ))
        attrib.removeFrom( dom );

    // realize new attribs if they differ from old ones
    for (attrib in newAttribs)
      if ( !oldAttribs.exists( (a) -> a.equals( attrib ) ))
        attrib.realizeOn( dom );
  }

  private static function updateDom(parent : Node, ?oldElem: Html,  ?newElem: Html, ?index = 0) {
    var child = parent.childNodes.item( index );

    if ( oldElem == null ) {
      parent.appendChild( newElem.realize() );
    } else if ( newElem == null ) {
      parent.removeChild( child );
    } else if ( newElem.differsFromNode( oldElem ) )  {
      parent.replaceChild( newElem.realize(), child );
    }  else {
      updateAttributes(child, oldElem, newElem);
      var childCount = Std.int(Math.max(oldElem.childCount(), newElem.childCount()));
      childCount;
      for (i in 0 ... childCount)
        updateDom(child,
                  oldElem.nthChild( (childCount - 1) - i),
                  newElem.nthChild( (childCount - 1) - i),
                  (childCount - 1) - i);
    }
  }


  final model:Model<T>;
  var root: Node;
  var currentVirtual: Html;

  final function updateView () {
    var newVirtual = render();
    updateDom(root, currentVirtual, newVirtual);
    currentVirtual = newVirtual;
  }

  public function render() : Html {
    throw "Must Implement";
    return null;
  }

  public function new(m:Model<T>, r: Node) {
    model = m;
    currentVirtual = render();
    m.register( updateView );
    root = r;
    updateDom(root, null, currentVirtual);
  }
}

