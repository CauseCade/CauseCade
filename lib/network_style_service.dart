import 'package:angular2/core.dart';
import 'node.dart';
import 'link.dart';
import 'dart:js';
import 'dart:html';

@Injectable()

class NetworkStyleService {

  String defaultFillColour='#999'; // a type of grey
  String defaultStrokeColour='#fafafa'; //background colour of canvas
  String defaultStrokeWidth='1.5px';
  String defaultRadius='16';

  //hover parameters
  String hoverRadius = '18';

  //style the network for the selected node
  void setNodeSelection(node nodeSelected){
    //clear any possible old selection
    clearNodeSelection();
    //get  the svg element of the selectged node
    var selectedNode= querySelector(generateSvgNodeNameFromString(nodeSelected.getName()));
      selectedNode.style.setProperty('fill', 'rgb(31, 119, 180)');
      //selectedNode.style.setProperty('fill-opacity', '1.0');

    setParentSelection(nodeSelected);
    setDaughterSelection(nodeSelected);
  }

  void setParentSelection(node nodeSelected){
    nodeSelected.getParents().forEach((node_select){
      var nodeVar = querySelector(generateSvgNodeNameFromNode(node_select));
      nodeVar.style.setProperty('stroke', 'orange');
      nodeVar.style.setProperty('stroke-width', '3px');
    });
  }

  void setDaughterSelection(node nodeSelected){
    nodeSelected.getDaughters().forEach((node_select){
      var nodeVar = querySelector(generateSvgNodeNameFromNode(node_select));
      nodeVar.style.setProperty('stroke', 'purple');
      nodeVar.style.setProperty('stroke-width', '3px');
    });
  }

  void clearNodeSelection(){
    var allNodes= querySelectorAll('.circlesvg');
    allNodes.style.setProperty('fill', defaultFillColour.toString());
    allNodes.style.setProperty('stroke', defaultStrokeColour.toString());
    allNodes.style.setProperty('stroke-width', defaultStrokeWidth.toString());
  }

  void setNodeHover(JsObject jsNode){
    //fetch svg object and set styles
    var hoveredNode = querySelector(generateSvgNodeNameFromString(jsNode['id']));
      hoveredNode.setAttribute('r',hoverRadius);
  }

  void clearNodeHover(JsObject jsNode){
    //fetch svg object and set styles
    var hoveredNode = querySelector(generateSvgNodeNameFromString(jsNode['id']));
    hoveredNode.setAttribute('r',defaultRadius);
  }

  String generateSvgNodeNameFromString(String nodeNameRaw){
    return '#'+'svgNodeObject_'+nodeNameRaw.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
  }

  String generateSvgNodeNameFromNode(node nodeNameRaw){
    return '#'+'svgNodeObject_'+nodeNameRaw.getName().replaceAll(new RegExp(r"\s+\b|\b\s"), "");
  }


}