import 'dart:math' as math;
import 'package:d3/d3.dart';
import 'dart:html';
import 'dart:js';

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
    ..linkDistance = 60
    ..size = [width, height];

    /*json("Supplementary/EntryExample.json").then( (input_data) {*/
     links = input_data['links'];
     nodes = input_data['nodes'];

     force
       ..nodes = nodes
       ..links = links
       ..start();

     zoom
       ..scaleExtent = [1, 10]
       ..center = [width / 2, height / 2]
       ..size = [width, height];

      svg
        ..call(zoom);

      zoom.onZoom.listen((_) => rescale());

     link = g.selectAll(".link").data(links).enter().append("line")
         ..attr["class"] = "link"
         ..styleFn["stroke-width"] = (d) => math.sqrt(d['value']);

     node =
     g.selectAll(".node").data(nodes).enter().append("circle")
       ..attr["class"] = "node"
       ..attr["r"] = "8"
       ..styleFn["fill"] = ((d) => color(d['group']))
       ..call((_) => force.drag());

     node.append("title")
       ..textFn = (d) => d['name'];

     force.onTick.listen((_) {
       link
         ..attrFn["x1"] = ((d) => d['source']['x'])
         ..attrFn["y1"] = ((d) => d['source']['y'])
         ..attrFn["x2"] = ((d) => d['target']['x'])
         ..attrFn["y2"] = ((d) => d['target']['y']);

       node
         ..attrFn["cx"] = ((d) => d['x'])
         ..attrFn["cy"] = ((d) => d['y']);
       });
  }

  reset(){
    /*svg.clear();
    node.reset();
    link.reset();*/
    window.console.debug(svg.runtimeType.toString());
    link.remove();
  }

  setForce(ChargeIn,LnkDistIn){
    force
      ..charge = -ChargeIn
      ..linkDistance = LnkDistIn
      ..start();
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
}




