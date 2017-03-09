import 'dart:js';
import 'package:causecade/network_interface.dart';
import 'dart:html';

Implement(InputData){
  window.console.debug('inoutdata: ');
  window.console.debug(InputData);

  //these can be cleared afterwards
  var NewData = new List(2);
  var NewNode = new List(1);
  var NewLink = new List();

  // -------- adds info to the JS network (NETWORK REPRESENTATION) ---------

  //Holds the New JsNodeObject
  var NodeHolder = new JsObject.jsify({"id":InputData[0][0],"group":20});
  NewNode[0]=(NodeHolder); //This must be a List (for some reason)

  //adds the links for the visual network
  for(var i = 0; i < InputData[1].length; i++){
    //print("what is index of target: ");
    //print(myNet.getNodeIndex(InputData[1][i]));
    var LinkHolder = new JsObject.jsify({"source":myNet.getNodesSize(),"target":myNet.getNodeIndex(InputData[1][i]),"value":8}); //finding values is hard right now
    NewLink.add(LinkHolder);
  }

  NewData[0]=(NewNode); //Storing In Other List
  NewData[1]=(NewLink); //Storing In Other List
  //print(NewData);

  networkInfo.add(NewData); //updating the (global) list of all information
                            //in the visual part of the network. We need
                            //to call .addNewData() for this to have effect.
  //print("NetworkInfo: ");
  //print(networkInfo);
  myNet.addNewData(); //actually adding the nodes to the network
  networkInfo.clear(); //clearing stuff

  // -------- adds info to the actual DAG (NETWORK BEHIND THE SCENES) ---------

  myDAG.insertNode(InputData[0][0],2); //make sure this will allow for users to chose multi state variables//FIX
  //Creates a Link for to all the parents of the node you just created
  for (var i = 0; i < InputData[1].length; i++) {
    myDAG.insertLink(myDAG.findNode(InputData[1][i]), myDAG.findNode(InputData[0][0]));
  }
  //Creates a Link for to all the daughters of the node you just created
  for (var i = 0; i < InputData[2].length; i++) {
    myDAG.insertLink(myDAG.findNode(InputData[0][0]), myDAG.findNode(InputData[2][i]));
  }
  print(myDAG.toString());

}

ImplementJson(InputData) {
  var currentNodeCount = myNet.getNodesSize();

  for (var i = 0; i < InputData["links"].length; i++) {
    InputData["links"][i]["source"] =
        InputData["links"][i]["source"] + currentNodeCount;
    InputData["links"][i]["target"] =
        InputData["links"][i]["target"] + currentNodeCount;
  }
  myNet.addNewDataSet(InputData);


}


