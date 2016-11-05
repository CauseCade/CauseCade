import 'dart:js';
import 'package:causecade/network_interface.dart';
import 'dart:html';

Implement(InputData){
  window.console.debug('inoutdata: ');
  window.console.debug(InputData);

  var NewData = new List(2);
  var NewNode = new List(1);
  var NewLink = new List();

  var NodeHolder = new JsObject.jsify({"id":InputData[0][0],"group":20});
  NewNode[0]=(NodeHolder);

  for(var i = 0; i < InputData[1].length; i++){
    window.console.debug("what is index of target: ");
    window.console.debug(myNet.getNodeIndex(InputData[1][i]));
    var LinkHolder = new JsObject.jsify({"source":myNet.getNodesSize(),"target":myNet.getNodeIndex(InputData[1][i]),"value":8}); //finding values is hard right now
    NewLink.add(LinkHolder);
  }



  NewData[0]=(NewNode);
  NewData[1]=(NewLink);
  window.console.debug(NewData);

  networkInfo.add(NewData);
  window.console.debug("NetworkInfo: ");
  window.console.debug(networkInfo);


  myNet.addNewData();
  networkInfo.clear();

  //adds info to the actual DAG (beta)

  myDAG.insertNode(InputData[0][0],2); //make sure this will allow for users to chose multi state variables//FIX
  for (var i = 0; i < InputData[1].length; i++) {
    myDAG.insertLink(myDAG.findNode(InputData[1][i]), myDAG.findNode(InputData[0][0]));
    window.console.debug('running test');
  }
  for (var i = 0; i < InputData[2].length; i++) {
    myDAG.insertLink(myDAG.findNode(InputData[0][0]), myDAG.findNode(InputData[2][i]));
  }
  window.console.debug(myDAG.toString());
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


