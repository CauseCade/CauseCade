import 'package:angular2/core.dart';
import 'node.dart';
import 'link.dart';
import 'dart:html';
import 'app_component.dart'; //for myDAG import

@Injectable()

//will handle any set of selections made by user.
//currently a very simple service
class NetworkSelectionService {

  node selectedNode;

  node get selection => selectedNode;

  void setNodeSelectionString(String nodeName){
    selectedNode= myDAG.findNode(nodeName);
    print('[selectionService] set node:' + nodeName);
  }

  void setNodeSelection(node nodeIn){
    selectedNode=nodeIn;
    print('[selectionService] set node:' + nodeIn.getName());
  }

}