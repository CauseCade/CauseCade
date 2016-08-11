
import 'Network.dart';
import 'UI_Buttons.dart';
import 'card_barchart.dart';
import 'dart:html';
import 'Modals.dart';
/*import 'dart:svg';*/
import 'package:d3/d3.dart';
/*This should handle interactions with other dart files in NetworkElements*/

List NetworkInfo = new List();
Network MyNet;

class BayesNetCanvas{

  var width = 900;
  var height =900;

  ButtonElement reset_button;
  ButtonElement load_button;
  ButtonElement node_adder;
 /* Network MyNet;*/
  var NetworkHolder = querySelector('#GraphHolder');
  var svg = new Selection("#GraphHolder").append("svg"); /*svg file we draw on*/
 /* SvgElement svg;*/

  BayesNetCanvas(){
    window.console.debug(svg.runtimeType.toString()) ;

    /*GenerateBarchart();*/
    window.onResize.listen((_) => setScreenDimensions());


    json("Supplementary/EntryExample.json").then( (input_data) {
      MyNet = new Network(svg,width,height,input_data);
      setScreenDimensions();
    }, onError: (err) => throw err);

    reset_button = querySelector("#button_reset");
    reset_button.onClick.listen(clearNet);

    load_button = querySelector("#button_load");
    load_button.onClick.listen(updateNodes);

    node_adder = querySelector("#node_adder");
    node_adder.onClick.listen((event) {
      ModalNodeAdder nodeAdderMenu = new ModalNodeAdder();
      nodeAdderMenu.show();
      });
  }

  clearNet(Event q){
    MyNet.reset();
  }

  changeNetwork(Event g){

    json("Supplementary/EntryExample.json").then( (input_data) {
      MyNet = new Network(svg,width,height,input_data);
    }, onError: (err) => throw err);
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




