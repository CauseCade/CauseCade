import 'node.dart';
import 'link.dart';
import 'dart:collection';
import 'package:causecade/vector_math.dart';

class BayesianDAG{

  List<node> NodeList = new List();
  List<link> LinkList = new List();
  String name;

  BayesianDAG(){
    print("DAG Created!");
    name="Unnamed Network";
  }

  //name setting and getting
  void setName(String nameIn){
    name = nameIn;
  }

  String getName(){
    return name;
  }

  //basic network query
  int numNodes(){
    return NodeList.length;
  }

  List<node> getNodes(){
    return NodeList;
  }

  int numLinks(){
    return LinkList.length;
  }

  List<link> getLinks(){
    return LinkList;
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
    for(var i=0; i<NodeList.length;i++){
      if (NodeList[i].getName()==nameIn){
        return NodeList[i];
      }
    };
    print('no node was found, please re-enter your option');
  }

  // this checks whether there is a connection between two nodes
  // (this could be both ways)
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

  //checks and returns the edge of the node origin to target
  // - note this is a directed check, unlike isConnected
  link getLink(node nodeOrigin,node nodeTarget){
    return nodeOrigin.getOutGoing()[nodeTarget];
  }

  //adding and removing nodes and links
  insertNode(newName, stateCount){
    node NewNode = new node(newName, stateCount);
    NodeList.add(NewNode);
  }

  insertLink(node nodeOrigin, node nodeTarget){
    if (!isConnected(nodeOrigin,nodeTarget)){ /*!isConnected(node1, node2)*/
      link newLink = new link(nodeOrigin,nodeTarget);

      nodeOrigin.addOutgoing(nodeTarget,newLink);
      nodeTarget.addIncoming(nodeOrigin,newLink);

      LinkList.add(newLink);
      print("created link");
    }
    else{
      print("these nodes are already connected");
    }
  }

  /*needs more verification to see whether this is functional - update links*/
  bool removeNode(String nameIn){
    var removingHolder = new List<link>();
    for(var i =0; i< NodeList.length;i++){

      if(NodeList[i].getName()==nameIn){
        NodeList[i].getOutGoing().values.forEach((link){
          print(link);
          removingHolder.add(link);
        });
        NodeList[i].getInComing().values.forEach((link){
          print(link);
          removingHolder.add(link);
        });

        //This is done because nodes cant be removed during forEach loop
        for(var j=0; j< removingHolder.length;j++){
          removeEdge(removingHolder[j]);
        }
        removingHolder.clear();

        NodeList.removeAt(i);
        print("node removed");
        return true;
      }
    }
    print("no such node found");
    return false;
  }

  removeEdge(link linkIn){
    //this will remove the map value from the vertices' link map
    linkIn.getEndPoints()[0].getOutGoing().remove(linkIn.getEndPoints()[1]);
    linkIn.getEndPoints()[1].getInComing().remove(linkIn.getEndPoints()[0]);
    // this will remove the actual link instance
    LinkList.remove(linkIn);
    print('removed link');
  }

  //searching the network (to see what is reachable) (depth first search)

  DFS(node startNode,  Set<node> known,Map<node,link> forest ){
    known.add(startNode);

    startNode.getOutGoing().keys.forEach((connectedNode){
      if (!known.contains(connectedNode)){
        var map ={};
        map[connectedNode]=startNode.getOutGoing()[connectedNode];
        forest.addAll(map);

        DFS(connectedNode, known, forest);
      }
    });
  }

  checkNodes(){
    StringBuffer Buffer = new StringBuffer();
    Buffer.write('> Requested Node Status of the Network\n');
    int errorCount=0;
    NodeList.forEach((node){
      if(!node.getLinkMatrixStatus()){
        errorCount++;
        Buffer.write('Node: ' + node.getName() +
            ' - has an inproperly configured Link Matrix\n');
      }
    });
    Buffer.write('\t['+ errorCount.toString() +
        '] nodes with inproper LinkMatrix values found,'
            ' please enter proper values.');
    print(Buffer.toString());
  }

  checkFlags(){ //this could use some fancier print message
    print('flagged nodes are given below');
    NodeList.forEach((node){
      if(node.getFlaggedStatus()){
        print('The following Node is Currently Flagged: ' + node.getName());
      }
    });
  }

  bool checkFlagsStatus(){
    for(int i=0; i<NodeList.length;i++){
      if(NodeList[i].getFlaggedStatus()){
        //print('we found at least one flag');
        return true;

      }
    };

    return false;
  }

  bool checkCyclic(){
    List<node> copyNodes = new List<node>.from(NodeList);
    List<link> copyLinks = new List<link>.from(LinkList);

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

    if(LinkList.isEmpty){
      reintroduceEdges(linkBackup);
      return false;
    }
    else{
      reintroduceEdges(linkBackup);
      return true;
    }

  }

  reintroduceEdges(List<link> edgesToReadd){
    edgesToReadd.forEach((link){
      insertLink(link.getEndPoints()[0],link.getEndPoints()[1]);
    });
  }

  //MAIN FUNCTIONALITY (


  updateNetwork(){ // This may be changed to a thing that loops over all nodes,
    // as this only updates max 1 nodes per call.
    // the only problem with that is that the order in which the
    // network is updated matters, as otherwise itll start finding
    // itself working with null values.
    // Will eventually implement method that avoids these problems
    // and allows updating the whole network with one call
    int iterationTracker=1;
    while(checkFlagsStatus()){ //TODO temporarily set to update once at a atime
      print('<<<<<<<<<<<<< We are on Iteration: '+ iterationTracker.toString() +' >>>>>>>>>>>>>>>>>>>>>>');
      for(var i=0; i<NodeList.length;i++) {
        if (NodeList[i].getFlaggedStatus()) {
          print('> Updating The Network - Propagating Evidence...');
          print('updating node: ' + NodeList[i].getName());
          // print('fetching Pi Messages...');
          NodeList[i].ComputePiEvidence();

          //This is currently not yet implemented
          // - the network can only propagate downwards
          //  print('fetching lambda Messages...');
          NodeList[i].ComputeLambdaEvidence();

          NodeList[i].UpdatePosterior();
          print('Updating Probability...' +
              NodeList[i].getProbability().toString());
          print('Single Update Cycle Complete.\n');
          //break; //enable this if you only want one node updating at a time (useful for debugging)
        }
      }
      iterationTracker++;

    };
  }

  //should only be called for debugging
  //forces single node to be updated
  updateNode(node NodeIn){
    print('<<<<<<<<<<<<< Forced Update >>>>>>>>>>>>>>>>>>>>>>');


        print('updating node: ' + NodeIn.getName());
        // print('fetching Pi Messages...');
      NodeIn.ComputePiEvidence();

        //This is currently not yet implemented
        // - the network can only propagate downwards
        //  print('fetching lambda Messages...');
     NodeIn.ComputeLambdaEvidence();

      NodeIn.UpdatePosterior();
        print('Updating Probability...' +
            NodeIn.getProbability().toString());
        print('Single Update Cycle Complete.\n');
        //break; //enable this if you only want one node updating at a time (useful for debugging)


  }

  //Enter Hard evidence for a node
  //Hard Evidence(instantiated) means the probability of the node cannot change]
  //Node can be both root node and instantiated
  setEvidence(String nodeName,Vector EvidenceToSet){
    NodeList.forEach((node){
      //we choose to let the user give a name,
      //may change to referencing a node object later on (better performance)
      if (node.getName()== nodeName){
        node.setProbability(EvidenceToSet);
        print('node: ' + node.getName() + ' has been updated (instantiated)'
            'to probability: ' + node.getProbability().toString());
      }
    });
  }

  //sets the prior probability for the node. This is the probability a root
  //node will have. This differs from instantiating a node, with the regard that
  //a root node can still change it's probability in the face of lambda evidence
  //This method should ONLY be called on root nodes (with no parent).
  setPrior(String nodeName, Vector PiEvidenceToSet){
    NodeList.forEach((node){
      //we choose to let the user give a name,
      //may change to referencing a node object later on (better performance)
      if (node.getName()== nodeName){
        if(node.getEvidenceStatus()){ //informative message
          print('you are setting a prior for an instantiated node,'
              'the probability wont be affected until you remove instantiation.');
        }

        node.setRootStatus(true); //this to inform users this is a root node
        node.setPiEvidence(PiEvidenceToSet); //set the PiEvidence;
        node.UpdatePosterior(); //have new evidence come into effect

        print('node: ' + node.getName() + ' has a new Prior Probability: '
            + node.getProbability().toString());
      }
    });
  }

  //String representation of the network (very basic, for debugging)

  String toString(){
    var Buffer = new StringBuffer();
    Buffer.write('> Network Representation - Nodes: ' +
        NodeList.length.toString() + ' Links: ' +
        LinkList.length.toString() + '\n');
    for(var i =0; i<NodeList.length;i++){
      Buffer.write('Node: ' + NodeList[i].getName() + ' - Probabilities: ' +
          NodeList[i].getProbability().toString() + NodeList[i].getStateLabels().toString());
      Buffer.write('\n \t [outdegree]: ' + outDegree(NodeList[i]).toString() +
          ' connections ->');
      NodeList[i].getOutGoing().keys.forEach(
          (node){Buffer.write(node.getName() + ',');});
      Buffer.write('\n \t [indegree]: ' + inDegree(NodeList[i]).toString() +
          ' connections ->');
      NodeList[i].getInComing().keys.forEach(
          (node){Buffer.write(node.getName() + ',');});
      Buffer.write('\n');
    }
/*
    print(Buffer.toString());
*/
    return Buffer.toString();
  }
}