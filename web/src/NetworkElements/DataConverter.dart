import 'dart:js';
import 'NetworkInterface.dart';
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
    window.console.debug(MyNet.getNodeIndex(InputData[1][i]));
    var LinkHolder = new JsObject.jsify({"source":MyNet.getNodesSize(),"target":MyNet.getNodeIndex(InputData[1][i]),"value":8}); //finding values is hard right now
    NewLink.add(LinkHolder);
  }



  NewData[0]=(NewNode);
  NewData[1]=(NewLink);
  window.console.debug(NewData);

  NetworkInfo.add(NewData);
  window.console.debug("NetworkInfo: ");
  window.console.debug(NetworkInfo);


  MyNet.addNewData();
  NetworkInfo.clear();

  //adds info to the actual DAG (beta)

  MyDAG.insertNode(InputData[0][0]);
  for (var i = 0; i < InputData[1].length; i++) {
    MyDAG.insertLink(MyDAG.findNode(InputData[1][i]), MyDAG.findNode(InputData[0][0]));
    window.console.debug('running test');
  }
  for (var i = 0; i < InputData[2].length; i++) {
    MyDAG.insertLink(MyDAG.findNode(InputData[0][0]), MyDAG.findNode(InputData[2][i]));
  }
  window.console.debug(MyDAG.toString());
}

ImplementJson(InputData) {
  var currentNodeCount = MyNet.getNodesSize();

  for (var i = 0; i < InputData["links"].length; i++) {
    InputData["links"][i]["source"] =
        InputData["links"][i]["source"] + currentNodeCount;
    InputData["links"][i]["target"] =
        InputData["links"][i]["target"] + currentNodeCount;
  }
  MyNet.addNewDataSet(InputData);


}


