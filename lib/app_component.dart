import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';

import 'package:causecade/network.dart';
import 'package:causecade/bayesian_dag.dart';

import 'package:causecade/overview_component.dart';
import 'package:causecade/detail_component.dart';
import 'package:causecade/edit_component.dart';
import 'package:causecade/node_adder_component.dart';

import 'package:causecade/example_networks.dart';
import 'package:causecade/modals.dart';
import 'node.dart';
import 'dart:html';

import 'package:d3/d3.dart';

import 'package:angular2/router.dart';

List networkInfo = new List();
Network myNet;
BayesianDAG myDAG;

@Component(
    selector: 'causecade',
    templateUrl: 'app_component.html',
directives: const [ROUTER_DIRECTIVES,materialDirectives,NodeAdderComponent],
providers: const [ROUTER_PROVIDERS,materialProviders]
)
@RouteConfig(const [
  const Route(path: '/overview/:id',name: 'Overview',component: OverviewComponent),
  const Route(path: '/details/:id', name: 'Detail', component: DetailComponent),
  const Route(path: '/edit/:id', name: 'Edit', component: EditComponent)
])
class AppComponent implements OnInit{

  //display settings
  var width = 900;
  var height =900;
  var networkHolder;
  var svg;
  String NodeName;


  AppComponent(){
    print('Appcomponent created');
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

  onKey(dynamic event) {
    NodeName=event.target.value; //saves entered string
    myDAG.findNode(event.target.value); //prints if error
  }

  loadNodeAdder(){
    ModalNodeAdder nodeAdderMenu = new ModalNodeAdder();
    nodeAdderMenu.show();
  }

  //when the ''LOAD'' button is clicked
  loadData(){
    //This function will get improved functionality in the future
    LoadExample_Animals(); //loads the animals example
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