
import 'Network.dart';
import 'UI_Buttons.dart';
import 'card_barchart.dart';
import 'dart:html';
import 'package:d3/d3.dart';
/*This should handle interactions with other dart files in NetworkElements*/





class BayesNetCanvas{

  var width = 900;
  var height =900;
  ButtonElement reset_button;
  ButtonElement load_button;
  Network MyNet;
  var NetworkHolder = querySelector('#GraphHolder');
  var svg = new Selection("#GraphHolder").append("svg"); /*svg file we draw on*/

  BayesNetCanvas(){

    GenerateBarchart();
    window.onResize.listen((_) => setScreenDimensions());
    /*setScreenDimensions();*/

    MyNet = new Network(svg,width,height);

    reset_button = querySelector("#button_reset");
    reset_button.onClick.listen(updateNetForce);

    load_button = querySelector("#button_load");
    load_button.onClick.listen(updateNodes);
  }

  updateNetForce(Event e){
    MyNet.setForce(300,100);
    window.console.debug("called method updateNetForce") ;
  }

  updateNodes(Event f){
    MyNet.addNode();
    window.console.debug("called method updateNodes") ;
  }

  setScreenDimensions(){ /*sets the SVG Dimensions*/
    window.console.debug("set screen dimensions");

    width = NetworkHolder.contentEdge.width;
    height = NetworkHolder.contentEdge.height;

    svg
      ..attr["width"] = width
      ..attr["height"] = height;

    MyNet.setSize(width,height);
  }
}




