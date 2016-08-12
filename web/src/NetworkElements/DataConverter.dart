import 'dart:js';
import 'NetworkInterface.dart';
import 'dart:html';

Implement(InputData){

  var NewData = new List(2);
  var NewNode = new List(1);
  var NewLink = new List();

  var NodeHolder = new JsObject.jsify({"id":InputData[0][0],"group":20});
  NewNode[0]=(NodeHolder);

  for(var i = 0; i < InputData[1].length; i++){
    /*window.console.debug("what is index of target: ");
    window.console.debug(MyNet.getNodeIndex(InputData[1][i]));*/
    var LinkHolder = new JsObject.jsify({"source":MyNet.getNodesSize(),"target":MyNet.getNodeIndex(InputData[1][i]),"value":8}); /*finding values is hard right now*/
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
}

ImplementJson(InputData){

  var currentNodeCount = MyNet.getNodesSize();

  for(var i =0; i< InputData["links"].length;i++){
    InputData["links"][i]["source"]=InputData["links"][i]["source"]+currentNodeCount;
    InputData["links"][i]["target"]=InputData["links"][i]["target"]+currentNodeCount;
  }


  MyNet.addNewDataSet(InputData);
}


