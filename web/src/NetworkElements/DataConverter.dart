import 'dart:js';
import 'NetworkInterface.dart';
import 'dart:html';

Implement(InputData){

  var NewData = new List();
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



  NewData.add(NewNode);
  NewData.add(NewLink);
  window.console.debug(NewData);

  NetworkInfo.add(NewData);
  window.console.debug("NetworkInfo: ");
  window.console.debug(NetworkInfo);


  MyNet.addNode();
  NetworkInfo.clear();
}

/*var temp = new JsObject.jsify({"id":counter,"group":4});
    var temp2 = new JsObject.jsify({"source":counter,"target":5,"value":8});
    var temp3 = new JsObject.jsify({"source":counter,"target":1,"value":8});*/

