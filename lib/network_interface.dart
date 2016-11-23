import 'package:causecade/data_converter.dart';
import 'package:causecade/network.dart';
import 'package:causecade/card_barchart.dart';
import 'dart:html';
import 'package:causecade/modals.dart';
/*import 'dart:svg';*/
import 'package:d3/d3.dart';
import 'package:causecade/bayesian_dag.dart';

/*This should handle interactions with other dart files in NetworkElements*/

List networkInfo = new List();
Network myNet;
BayesianDAG myDAG;


class BayesNetCanvas{

  var width = 900;
  var height =900;

  ButtonElement reset_button;
  ButtonElement save_button;
  ButtonElement load_button;
  ButtonElement node_adder;
 /* Network MyNet;*/
  WelcomeModal welcomeModal = new WelcomeModal();
  var networkHolder = querySelector('#GraphHolder');
  var svg = new Selection("#GraphHolder").append("svg"); /*svg file we draw on*/
 /* SvgElement svg;*/

  BayesNetCanvas(){

    /*GenerateBarchart();*/
    window.onResize.listen((_) => setScreenDimensions());

    myNet = new Network(svg,width,height);
    myDAG = new BayesianDAG();
    setScreenDimensions();

    //Buttons

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
      });
  }

  void clearNet(Event q){
    myNet.reset();
  }


  void loadNetwork(Event g){
    json('/supplementary/Example2.json').then( (inputData) {
      window.console.debug(inputData["nodes"].elementAt(0).toString()) ;
/*
      ImplementJson(input_data);
*/
    }, onError: (err) => throw err);
  }

  void fitNetwork(Event f){
    setScreenDimensions();
    myNet.fitNetwork(width,height);
  }

  void updateNodes(Event f){
    myNet.addNewData();
    window.console.debug("called method updateNodes") ;
  }

  void setScreenDimensions(){ /*sets the SVG Dimensions*/
    window.console.debug("set screen dimensions");

    width = networkHolder.contentEdge.width;
    height = networkHolder.contentEdge.height;

    svg
      ..attr["width"] = width.toString()
      ..attr["height"] = height.toString();

    myNet.setSize(width,height);
  }
}




