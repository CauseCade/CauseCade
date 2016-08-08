import 'dart:math' as math;
import 'package:d3/d3.dart';
import 'dart:html';

class Network {

  var force = new Force();
  var color = new OrdinalScale.category20();
  Map links;
  Map nodes;
  var svg;
  /*constructor*/
  Network(svgIn,width,height) {
    svg = svgIn;

    force
    ..charge = -120
    ..linkDistance = 60
    ..size = [width, height];

    json("Supplementary/EntryExample.json").then( (input_data) {
     links = input_data['links'];
     nodes = input_data['nodes'];

      window.console.debug(nodes);

      force
        ..nodes = nodes
        ..links = links
        ..start();

      /*window.console.debug(input_data["nodes"].toString()) ;*/

      var link = svg.selectAll(".link").data(links).enter().append("line")
        ..attr["class"] = "link"
        ..styleFn["stroke-width"] = (d) => math.sqrt(d['value']);

      var node =
      svg.selectAll(".node").data(nodes).enter().append("circle")
        ..attr["class"] = "node"
        ..attr["r"] = "8"
        ..styleFn["fill"] = ((d) => color(d['group']))
        ..call((_) => force.drag());

      node.append("title")
        ..textFn = (d) => d['name'];

      /*some force interactions*/
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
    }, onError: (err) => throw err);
  }

  addNode(){
    svg.selectAll(".node").data(nodes).enter().append("circle")
      ..attr["class"] = "node"
      ..attr["r"] = "8"
      ..styleFn["fill"] = ((d) => color(d['group']))
      ..call((_) => force.drag());
  }

  addConnection(var SelectedNode,var NodesToConnect ){
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
  }

}




