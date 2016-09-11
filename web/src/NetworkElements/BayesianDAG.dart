import 'Node.dart';
import 'Link.dart';

class BayesianDAG{

  List<node> NodeList = new List();
  List<link> LinkList = new List();

  BayesianDAG(){
    print("DAG Created!");

  }

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

  int nodeDegree(node nodeIn){
    return nodeIn.getOutGoing().length+nodeIn.getInComing().length;
  }

  int outDegree(node nodeIn){
    nodeIn.getOutGoing().length;
  }

  int inDegree(node nodeIn){
    nodeIn.getInComing().length;
  }

  /*This will have to be adapted, error handling and check incoming nodes etc...*/
  bool isConnected(node node1, node node2){
    if(node1.getOutGoing().contains(node2) || node2.getOutGoing().contains(node1)){
      print('they are connected');
      return true;
    }
    else{
      print('they are not connected');
      return false;
    }
  }

  insertNode(newName){
    node NewNode = new node(newName);
    NodeList.add(NewNode);
  }

  /*needs more verification to see whether this is functional - update links*/
  bool removeNode(String nameIn){
    for(var i =0; i< NodeList.length;i++){
      if(NodeList[i].getName()==nameIn){
        for(var j=0;j<NodeList[i].getOutGoing().length;j++){
          NodeList[i].getOutGoing()[j].getInComing().remove(NodeList[i]);
        }
        for(var j=0;j<NodeList[i].getInComing().length;j++){
          NodeList[i].getInComing()[j].getOutGoing().remove(NodeList[i]);
        }

        NodeList.removeAt(i);
        print("node removed");
        return true;
      }
    }
    print("no such node found");
    return false;
  }

  insertLink(node node1, node node2){
    if (!isConnected(node1,node2)){ /*!isConnected(node1, node2)*/
      node1.addDaughter(node2);
      node2.addParent(node1);
      link newLink = new link(node1,node2);
      LinkList.add(newLink);
      print("created link");
    }
    else{
      print("these nodes are already connected");
    }
  }








}