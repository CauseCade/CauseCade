import 'package:angular2/core.dart';
import 'node.dart';
import 'link.dart';
import 'dart:js';
import 'dart:html';

@Injectable()

class NetworkStyleService {

  String defaultFillColour='rgb(31, 119, 180)';
  String inactiveFillColour = '#999'; // a type of grey
  String defaultStrokeColour='#fafafa'; //background colour of canvas
  String defaultStrokeWidth='1.5px';
  String defaultRadius='16';

  //hover parameters
  String hoverRadius = '18';

  //style the network for the selected node
  void setNodeSelection(node nodeSelected) {
    //clear any possible old selection
    clearNodeSelection();
    var allNodes = querySelectorAll('.circlesvg').style.setProperty(
        'fill', inactiveFillColour);
    //get  the svg element of the selectged node

    if (nodeSelected != null){ //would be null if we just reset the selection
    var selectedNode = querySelector(
        generateSvgNodeNameFromString(nodeSelected.getName()));
    selectedNode.style.setProperty('fill', 'rgb(31, 119, 180)');
    //selectedNode.style.setProperty('fill-opacity', '1.0');


    setParentSelection(nodeSelected);
    setDaughterSelection(nodeSelected);
    }
    else{ //selectionservice has null selected (no node)
      clearNodeSelection();
    }
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
    allNodes.style.setProperty('fill', defaultFillColour);
    allNodes.style.setProperty('stroke', defaultStrokeColour);
    allNodes.style.setProperty('stroke-width', defaultStrokeWidth);
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

  /*Other Style Elements*/
  void setUiColours(String input){
    switch (input) {
      case 'normal':
        querySelectorAll('.themeColour').style.backgroundColor =  '#E91E63'; //Pink.
        querySelectorAll('.themeColourSecondary').style.backgroundColor = '#D81B60'; //darker pink;
        print('Colours: normal');
        break;
      case 'teach':
        querySelectorAll('.themeColour').style.backgroundColor = '#00BCD4'; //Blue

        querySelectorAll('.themeColourSecondary').style.backgroundColor = '#00ACC1'; //darker blue;
        print('Colours: teach');
        break;

    }
  }

}