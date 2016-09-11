import 'DataConverter.dart';
import 'Network.dart';
import 'UI_Buttons.dart';
import 'card_barchart.dart';
import 'dart:html';
import 'Modals.dart';
/*import 'dart:svg';*/
import 'package:d3/d3.dart';
import 'BayesianDAG.dart';
/*This should handle interactions with other dart files in NetworkElements*/

List NetworkInfo = new List();
Network MyNet;

class BayesNetCanvas{

  var width = 900;
  var height =900;

  ButtonElement reset_button;
  ButtonElement save_button;
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

/*    MyNet = new Network(svg,width,height);
    setScreenDimensions();




    reset_button = querySelector("#button_reset");
    reset_button.onClick.listen(clearNet);

    save_button = querySelector("#button_save");
    save_button.onClick.listen(fitNetwork);

    load_button = querySelector("#button_load");
    load_button.onClick.listen(loadNetwork);

    node_adder = querySelector("#node_adder");
    node_adder.onClick.listen((event) {
      ModalNodeAdder nodeAdderMenu = new ModalNodeAdder();
      nodeAdderMenu.show();
      });*/



  }

  clearNet(Event q){
    MyNet.reset();
  }

  loadNetwork(Event g){
    json("Supplementary/Example2.json").then( (input_data) {
      window.console.debug(input_data["nodes"].elementAt(0).toString()) ;
      ImplementJson(input_data);
    }, onError: (err) => throw err);
  }

  fitNetwork(Event f){
    setScreenDimensions();
    MyNet.fitNetwork(width,height);
  }

  updateNodes(Event f){
    MyNet.addNewData();
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




