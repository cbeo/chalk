package;

import js.html.Element;
import Html.*;

using Lambda;

class View<T> {

  private static function updateAttributes(dom:Element, oldElem: Html, newElem: Html) {
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

  private static function updateDom(parent : Element, ?oldElem: Html,  ?newElem: Html, ?index = 0) {
    var child = parent.childNodes.item( index );

    if ( oldElem == null ) 
      parent.appendChild( newElem.realize() );

    else if ( newElem == null )
      return parent.removeChild( child );

    else if ( newElem.differsFromNode( oldElem ) ) 
      parent.replaceChild( newElem.realize(), child );

    else {
      updateAttributes(child, oldElem, newElem);
      var childCount = Math.max(oldElem.childCount(), newElem.childCount());
      childCount--;
      for (i in 0...childCount)
        updateDom(child,
                  oldElem.nthChild( childCount - i),
                  newElem.nthChild( childCount - i),
                  childCount - i);
    }
  }


  final model:State<T>;
  var root: Element;
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

  public function new(m:State<T>) {
    model = m;
    m.register( updateView );
  }
}

