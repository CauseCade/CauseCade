import 'dart:math' as math;
import 'package:d3/d3.dart';

class Graph {

  Graph(width_input,height_input) {
    var width = width_input ;
    var height = height_input;

    var color = new OrdinalScale.category20();

    var force = new Force()
      ..charge = -120
      ..linkDistance = 60
      ..size = [width, height];

    var svg = new Selection("#GraphHolder").append("svg")
      ..attr["width"] = "$width"
      ..attr["height"] = "$height";

    json("Supplementary/EntryExample.json").then((graph) {
      force
        ..nodes = graph['nodes']
        ..links = graph['links']
        ..start();

      var link =
      svg.selectAll(".link").data(graph['links']).enter().append("line")
        ..attr["class"] = "link"
        ..styleFn["stroke-width"] = (d) => math.sqrt(d['value']);

      var node =
      svg.selectAll(".node").data(graph['nodes']).enter().append("circle")
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
    }, onError: (err) => throw err);
  }
}
