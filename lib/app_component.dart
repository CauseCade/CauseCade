import 'package:angular2/core.dart';

import 'package:causecade/network.dart';
import 'package:causecade/bayesian_dag.dart';

import 'package:causecade/info_component.dart';
import 'package:causecade/node_adder_component.dart';
import 'package:causecade/modals.dart';
import 'dart:html';

import 'package:d3/d3.dart';

List networkInfo = new List();
Network myNet;
BayesianDAG myDAG;

@Component(
    selector: 'causecade',
    templateUrl: 'app_component.html',
directives: const [InfoComponent,NodeAdderComponent]

)
class AppComponent implements OnInit{

  //display settings
  var width = 900;
  var height =900;
  var networkHolder;
  var svg;

  AppComponent(){

  }

  void ngOnInit(){
    print('Appcomponent Initiated');

    networkHolder = querySelector('#GraphHolder');
    svg = new Selection('#GraphHolder').append("svg"); /*svg file we draw on*/
    //uses d3 import in order to load this

    myNet = new Network(svg,width,height);
    myDAG = new BayesianDAG();

    setScreenDimensions();
    window.onResize.listen((_) => setScreenDimensions());

  }

  loadNodeAdder(){
    ModalNodeAdder nodeAdderMenu = new ModalNodeAdder();
    nodeAdderMenu.show();
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