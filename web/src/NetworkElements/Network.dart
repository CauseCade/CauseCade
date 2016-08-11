import 'dart:math' as math;
import 'package:d3/d3.dart';
import 'dart:html';
import 'dart:js';
import 'NetworkInterface.dart';

var counter = 6;


class Network {


  var force = new Force();
  var zoom = new Zoom();
  var color = new OrdinalScale.category20();
  var links;
  var nodes;
  var svg;
  var link;
  var node;
  var g;

  /*constructor*/
  Network(svgIn,width,height,input_data) {

    svg = svgIn;

    g = svg.append('g');

    force
    ..charge = -120
    ..linkDistance = 20
    ..size = [width, height];

    /*json("Supplementary/EntryExample.json").then( (input_data) {*/
     links = input_data['links'];
     nodes = input_data['nodes'];

    /*set up a force*/
     force
       ..nodes = nodes
       ..links = links
       ..start();

    /*set up a zoom*/
     zoom
       ..scaleExtent = [1, 10]
       ..center = [width / 2, height / 2]
       ..size = [width, height];

    /*set up interactable svg*/
      svg
        ..attr["pointer-events"] = 'all'
        ..call(zoom);

    /*when zoom or pan is detected, call rescale method*/
      zoom.onZoom.listen((_) => rescale());

     refreshData();

    /*this handles updating the network svg positions*/
     force.onTick.listen((_) {
       g.selectAll(".link")
         ..attrFn["x1"] = ((d) => d['source']['x'])
         ..attrFn["y1"] = ((d) => d['source']['y'])
         ..attrFn["x2"] = ((d) => d['target']['x'])
         ..attrFn["y2"] = ((d) => d['target']['y']);

       g.selectAll(".node")
         ..attrFn["cx"] = ((d) => d['x'])
         ..attrFn["cy"] = ((d) => d['y']);
       });
  }

  refreshData(){
    link = g.selectAll(".link").data(links).enter().append("line") /*tempfix mmethod is a rather duct-tape level fix*/ /*FIX*/
      ..attr["class"] = "link"
      ..styleFn["stroke-width"] = (d) => math.sqrt(d['value']);

    node = g.selectAll(".node").data(nodes as List, (d) => d['id']).enter().append("circle"); /*tempfix mmethod is a rather duct-tape level fix*/ /*FIX*/ /**/
    node //FIX
      ..attr["class"] = "node"
      ..attr["r"] = "8"
      ..styleFn["fill"] = ((d) => color(d['group']));
      /*..call((_) => force.drag());*/

    node.append("title")
      ..textFn = (d) => d['id'];
  }

  addNode(){
    for (var i =0; i < NetworkInfo.length; i++){
      nodes.add(NetworkInfo[i][0][0]);
      for (var j = 0; j < NetworkInfo[i][1].length; j++){
        links.add(NetworkInfo[i][1][j]);
      }
    }

    force.nodes = nodes;
    force.links = links;

    refreshData();
    force.start();
  }

  reset(){
    /*svg.clear();
    node.reset();
    link.reset();*/
    window.console.debug(svg.runtimeType.toString());
    link.remove();
  }

  setSize(widthIn,heightIn){
    force.size = [widthIn, heightIn];
    force.start();
    /*zoom.size = [widthIn, heightIn];*/ /*im not sure if this is actually useful, will revisit this later FIX*/
  }

  rescale(){ /*handles the panning and zooming of the svg*/
    window.console.debug("zoomevent triggered");
    g.attr["transform"] = "translate(" + zoom.translate.elementAt(0).toString() + "," + zoom.translate.elementAt(1).toString() + ")" + "scale(" + zoom.scale.toString() + ")" ;
  }

  getNodesSize(){
    window.console.debug(nodes.length);
    return nodes.length;
  }

}




