/*This dart file will contain the node class*/
import 'Link.dart';

class node{

  String name;
  Map<node,link> outGoing = new Map();
  Map<node,link> inComing = new Map();

  node(nameIn){
    name = nameIn;
  }

  String getName(){
    return name;
  }

  Map<node,link> getOutGoing(){
    return outGoing;
  }

  Map<node,link>  getInComing(){
    return inComing;
  }

  addIncoming(node parentNode, link connectingLink){
    var map ={};
    map[parentNode]=connectingLink;
    inComing.addAll(map);
  }

  addOutgoing(node daughterNode, link connectingLink){
    var map ={};
    map[daughterNode]=connectingLink;
    outGoing.addAll(map);
  }
}