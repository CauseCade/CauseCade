import 'dart:math' as math;
import 'package:d3/d3.dart';
import 'dart:html';

class Network {

  var force = new Force();
  var svg = new Selection("#GraphHolder").append("svg");
  var color = new OrdinalScale.category20();
  var width;
  var height;
  Map links;
  Map nodes;


  /*constructor*/
  Network(width_input,height_input) {
    width = width_input ;
    height = height_input;

    force
    ..charge = -120
    ..linkDistance = 60
    ..size = [width, height];

    svg
    ..attr["width"] = "$width"
    ..attr["height"] = "$height";

    json("Supplementary/EntryExample.json").then( (input_data) {
     links = input_data['links'];
     nodes = input_data['nodes'];

      window.console.debug(links);

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

  }


  }




