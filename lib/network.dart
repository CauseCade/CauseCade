import 'dart:math' as math;
import 'package:d3/d3.dart';
import 'dart:html';
import 'dart:js';
import 'dart:svg';
import 'package:causecade/app_component.dart';

var counter = 6; //not sure what this is //TODO


class Network {


  var force = new Force();
  var zoom = new Zoom();
  var color = new OrdinalScale.category20();
  JsArray links = new JsArray();
  JsArray nodes = new JsArray();
  var svg;
  Selection link;
  Selection node;
  var g;
  var activeSelection;

  /*constructor*/
  Network(svgIn,int width,int height) {

    svg = svgIn;

    g = svg.append('g');

    force
    ..charge = -120
    ..linkDistance = 35
    ..size = [width, height];

    /*var kappa =new JsObject.jsify({"id":"InitialNode","group":1});
    nodes.add(kappa);*/
    /* nodes = input_data['nodes'];*/

    /*set up a force*/
     force
       ..nodes = nodes
       ..links = links
       ..start();

    /*set up a zoom*/
     zoom
       ..scaleExtent = [0.1, 10]
       ..center = [width / 2, height / 2]
       ..size = [width, height];

    /*set up interactable svg*/
      svg
        ..attr["pointer-events"] = 'all'
        ..call(zoom);

    /*when zoom or pan is detected, call rescale method*/
      zoom.onZoom.listen((_) => rescale());


    refreshData();
    print('Network View is refreshing');

    /*this handles updating the network svg positions*/
     force.onTick.listen((_) {
       g.selectAll(".link")
         ..attrFn["x1"] = ((d) => d['source']['x'])
         ..attrFn["y1"] = ((d) => d['source']['y'])
         ..attrFn["x2"] = ((d) => d['target']['x'])
         ..attrFn["y2"] = ((d) => d['target']['y']);

       g.selectAll(".node")
         ..attr["transform"] = ((d) => 'translate(' + d['x'].toString() + ',' + d['y'].toString() + ")");
         /*..attrFn["cy"] = ((d) => d['y']);*/
       });
  }

  void refreshData(){
    print('refreshData() called');
    link = g.selectAll(".link").data(links).enter().append("line") /*tempfix mmethod is a rather duct-tape level fix*/ /*FIX*/
      ..attr["class"] = "link"
      ..styleFn["stroke-width"] = ((d) => math.sqrt(d['value']));



  node = g.selectAll(".node").data(nodes as List, (d) => d['id']).enter().append("g") /*tempfix mmethod is a rather duct-tape level fix*/ /*FIX*/ /**/
        ..attr["class"]= "node";
    //node = g.selectAll(".node").data(nodes).exit(); //testing this

    node.append("circle") //FIX
      ..attr["class"] = "circlesvg"
      ..attr["r"] = "8"
      ..styleFn["fill"] = ((d) => color(d['group']));
      //..call((_) => force.drag());*/

    node.append("text")
      ..attr["dx"] = "10"
      ..attr["dy"] =  ".39em"
      ..styleFn["stroke"] = "#9E9E9E"
      ..styleFn['font-family'] = "roboto"
      ..styleFn['font-weight'] = "100"
      ..styleFn['font-size'] = "10px"
      ..text = (d) => d['id'];

    node.on("mouseover").listen( (Selection) {
      window.console.debug(node.toString());
      node.styleFn['fill']=color(6);
      svg.styleFn['cursor']="pointer";
    });
    node.on("mouseout").listen((d) {
      svg.styleFn['cursor']="default";
    });
  }

  void addNewData(){
    //Adds the new nodes present in networkInfo
    for (var i =0; i < networkInfo[0][0].length; i++){
      nodes.add(networkInfo[0][0][i]);
    }
    //Adds the new links present in networkInfo
    for (var j = 0; j < networkInfo[0][1].length; j++){
      links.add(networkInfo[0][1][j]);
    }

    force.nodes = nodes;
    force.links = links;

    refreshData();
    force.start();
  }

  void addNewDataSet(InputDataSet){

    for(var i =0; i< InputDataSet["nodes"].length;i++){
      nodes.add(InputDataSet["nodes"][i]);
    }
    for(var i =0; i< InputDataSet["links"].length;i++){
      links.add(InputDataSet["links"][i]);
    }

    force.nodes = nodes;
    force.links = links;

    //print('addNewDataCalled');
    refreshData();
    force.start();
  }

  void reset(){ /*WIP*/

    nodes.clear();
    //nodes.add(new JsObject.jsify({"id":"NewNode","group":1}));
    //links.clear();
    window.console.debug("This isn't working at the moment - WIP");
    /*g.selectAll(".link").size();*/
    /*link.exit();*/
    //print(node.data(nodes).exit().toString());
    print(g.selectAll('node').runtimeType);
    node = g.selectAll(".node").exit().remove();



    force.nodes = nodes;
    force.links = links;

    refreshData();
    force.start();
/*
    var holder = new SvgElement.tag("g");
    var kappa = holder.querySelectorAll("circle");
    holder.remove();*/
  }

  void setSize(widthIn,heightIn){
    force.size = [widthIn, heightIn];
    force.start();
    /*zoom.size = [widthIn, heightIn];*/ /*im not sure if this is actually useful, will revisit this later FIX*/
  }

  void rescale(){ /*handles the panning and zooming of the svg*/
    window.console.debug("zoomevent triggered");
    g.attr["transform"] = "translate(" + zoom.translate.elementAt(0).toString() + "," + zoom.translate.elementAt(1).toString() + ")" + "scale(" + zoom.scale.toString() + ")" ;
  }

  void fitNetwork(width, height){ /*centers network and scales it to fit on the screen*/ /*WIP*/
    g.attr["transform"] = "translate(0,0)" + "scale(1)" ;
    zoom.scale = 1;
    zoom.translate = [0,0];

    var kappa = new SvgSvgElement();

   /* var gDiv= new DivElement();
    gDiv = querySelector(g);
    var kappa = gDiv.height;*/
    window.console.debug("g height");
    /*window.console.debug(kappa);*/
  }

  int getNodesSize(){
    window.console.debug(nodes.length);
    return nodes.length;
  }

  int getNodeIndex(stringIn){ /*returns the index of the node target, so the node can be appended to the proper targets (allows users to enter the node name rather than index*/

    window.console.debug("getting node index...");
    for (var i =0; i< nodes.length; i++){
      if (nodes.elementAt(i)["id"]==stringIn){
        window.console.debug("found a match");
        return i;
      }
      else{

      }
    }
    window.console.debug("no match found");
  }
}




