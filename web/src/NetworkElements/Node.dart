/*This dart file will contain the node class*/

class node{

  String name;
  List<node> outGoing = new List();
  List<node> inComing = new List();

  node(nameIn){
    name = nameIn;
  }

  String getName(){
    return name;
  }

  List<node> getOutGoing(){
    return outGoing;
  }

  List<node>  getInComing(){
    return inComing;
  }

  addParent(node parentNode){
    inComing.add(parentNode);
  }

  addDaughter(node daughterNode){
    outGoing.add(daughterNode);
  }
}