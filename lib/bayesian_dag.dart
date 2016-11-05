import 'package:causecade/node.dart';
import 'package:causecade/link.dart';
import 'dart:collection';

/*TODO
* implement a way to check whether the network has accidentally become cyclic
* find a way to refer to nodes by their name
*/

class BayesianDAG{

  List<node> nodeList = new List();
  List<link> linkList = new List();

  BayesianDAG(){
    print("DAG Created!");

  }

  //basic network query
  int numNodes(){
    return nodeList.length;
  }

  List<node> getNodes(){
    return nodeList;
  }

  int numLinks(){
    return linkList.length;
  }

  List<link> getLinks(){
    return linkList;
  }

  //detailed node query

  int nodeDegree(node nodeIn){
    return nodeIn.getOutGoing().length+nodeIn.getInComing().length;
  }

  int outDegree(node nodeIn){
    return nodeIn.getOutGoing().length;
  }

  int inDegree(node nodeIn){
    return nodeIn.getInComing().length;
  }

  node findNode(String nameIn){ //returns the node object associated with a name
    for(var i=0; i<nodeList.length;i++){
      if (nodeList[i].getName()==nameIn){
        return nodeList[i];
      }
    };
    print('no node was found, please re-enter your option');
  }

  //this checks whether there is a connection between two nodes (this could be both ways)
  bool isConnected(node node1, node node2){
    if(node1.getOutGoing()[node2]!=null || node2.getOutGoing()[node1]!=null){
      print('they are connected');
      return true;
    }
    else{
      print('they are not connected');
      return false;
    }
  }

  //checks and returns the edge of the node origin to target - note this is a directed check, unlike isConnected
  link getLink(node nodeOrigin,node nodeTarget){
    return nodeOrigin.getOutGoing()[nodeTarget];
  }

  //adding and removing nodes and links
  void insertNode(newName, stateCount){
    node newNode = new node(newName, stateCount);
    nodeList.add(newNode);
  }

  void insertLink(node nodeOrigin, node nodeTarget){
    if (!isConnected(nodeOrigin,nodeTarget)){ //!isConnected(node1, node2)
      link newLink = new link(nodeOrigin,nodeTarget);

      nodeOrigin.addOutgoing(nodeTarget,newLink);
      nodeTarget.addIncoming(nodeOrigin,newLink);

      linkList.add(newLink);
      print("created link");
    }
    else{
      print("these nodes are already connected");
    }
  }

  /*needs more verification to see whether this is functional - update links*/
  bool removeNode(String nameIn){
    var removingHolder = new List<link>();
    for(var i =0; i< nodeList.length;i++){

      if(nodeList[i].getName()==nameIn){
        nodeList[i].getOutGoing().values.forEach((link){
          print(link);
          removingHolder.add(link);
        });
        nodeList[i].getInComing().values.forEach((link){
          print(link);
          removingHolder.add(link);
        });

        for(var j=0; j< removingHolder.length;j++){ //This is done because nodes cant be removed during forEach loop
          removeEdge(removingHolder[j]);
        }
        removingHolder.clear();

        nodeList.removeAt(i);
        print("node removed");
        return true;
      }
    }
    print("no such node found");
    return false;
  }

  void removeEdge(link linkIn){
    //this will remove the map value from the vertices' link map
    linkIn.getEndPoints()[0].getOutGoing().remove(linkIn.getEndPoints()[1]);
    linkIn.getEndPoints()[1].getInComing().remove(linkIn.getEndPoints()[0]);
    // this will remove the actual link instance
    linkList.remove(linkIn);
    print('removed link');
  }

  //searching the network (to see what is reachable) (depth first search)

  void DFS(node startNode,  Set<node> known,Map<node,link> forest ){
    known.add(startNode);

    startNode.getOutGoing().keys.forEach((connectedNode){
      if (!known.contains(connectedNode)){
        Map<node,link> map ={};
        map[connectedNode]=startNode.getOutGoing()[connectedNode];
        forest.addAll(map);

        DFS(connectedNode, known, forest);
      }
    });
  }

  void checkNodes(){
    StringBuffer buffer = new StringBuffer();
    buffer.write('> Requested Node Status of the Network\n');
    int errorCount=0;
    nodeList.forEach((node){
      if(!node.getLinkMatrixStatus()){
        errorCount++;
        buffer.write('Node: ' + node.getName() + ' - has an inproperly configured Link Matrix\n');
      }
    });
    buffer.write('\t['+ errorCount.toString() + '] nodes with inproper LinkMatrix values found, please enter proper values.');
    print(buffer.toString());
  }

  void checkFlags(){ //this could use some fancier print message
    print('flagged nodes are given below');
    nodeList.forEach((node){
      if(node.getFlaggedStatus()){
        print('The following Node is Currently Flagged: ' + node.getName());
      }
    });
  }

  bool checkCyclic(){
    List<node> copyNodes = new List<node>.from(nodeList);
    List<link> copyLinks = new List<link>.from(linkList);

    List<link> holder = new List<link>();
    List<link> linkBackup = new List<link>();
    node nodeHolder;

    List<node> sorted = new List<node>();
    Queue<node> noIncomingEdges = new Queue<node>();

    copyNodes.forEach((node){
      if(node.getInComing().isEmpty){
        noIncomingEdges.add(node);
      }
    });

    while(noIncomingEdges.length != 0){
      sorted.add(noIncomingEdges.removeFirst());
      print(sorted);
      sorted.last.getOutGoing().keys.forEach((node){
        holder.add(node.getInComing()[sorted.last]);
        linkBackup.add(node.getInComing()[sorted.last]);
      });
      for(var i =0;i<holder.length;i++){

        //print(holder[i].getEndPoints()[1].getName() + '<-  name of target');
        nodeHolder = holder[i].getEndPoints()[1];
        removeEdge(holder[i]);

        if(nodeHolder.getInComing().isEmpty){
          noIncomingEdges.add(nodeHolder);
          //print('found new no incoming node');
        }

      }
      holder.clear();
    }

    if(linkList.isEmpty){
      reintroduceEdges(linkBackup);
      return false;
    }
    else{
      reintroduceEdges(linkBackup);
      return true;
    }

  }

  void reintroduceEdges(List<link> edgesToReadd){
    edgesToReadd.forEach((link){
      insertLink(link.getEndPoints()[0],link.getEndPoints()[1]);
    });
  }

  //MAIN FUNCTIONALITY (

  void updateNetwork(){ //This may be changed to a thing that loops over all nodes, as this only updates max 1 nodes per call.
    //the only problem with that is that the order in which the network is updated matters, as otherwise itll start finding itself working with null values
    //Will eventually implement method that avoids these problems and allows updating the whole network with one call

    for(var i=0; i<nodeList.length;i++){
      if(nodeList[i].getFlaggedStatus()){
        print('> Updating The Network - Propagating Evidence...');
        print('updating node: ' + nodeList[i].getName());
        print('fetching Pi Messages...');
        nodeList[i].FetchPiMessage();
        /*print('fetching lambda Messages...'); //This is currently not yet implemented - the network can only propagate downwards
       NodeList[i].FetchLambdaMessage();*/
        print('Updating Probability...');
        nodeList[i].UpdatePosterior();
        print('Single Update Cycle Complete.\n');
        break;
      }
    };
  }

  //String representation of the network (very basic, for debugging)

  String toString(){
    var buffer = new StringBuffer();
    buffer.write('> Network Representation - Nodes: ' + nodeList.length.toString() + ' Links: ' + linkList.length.toString() + '\n');
    for(var i =0; i<nodeList.length;i++){
      buffer.write('Node: ' + nodeList[i].getName() + ' - Probabilities: ' +nodeList[i].getProbability().toString());
      buffer.write('\n \t [outdegree]: ' + outDegree(nodeList[i]).toString() + ' connections ->');
      nodeList[i].getOutGoing().keys.forEach((node){buffer.write(node.getName() + ',');});
      buffer.write('\n \t [indegree]: ' + inDegree(nodeList[i]).toString() + ' connections ->');
      nodeList[i].getInComing().keys.forEach((node){buffer.write(node.getName() + ',');});
      buffer.write('\n');
    }
/*
    print(Buffer.toString());
*/
    return buffer.toString();
  }
}