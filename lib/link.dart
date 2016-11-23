/*This dart file will contain the link class*/
import 'package:causecade/node.dart';

/// This class contains a reference to two nodes and has one method
class link{

  List<node> endpoints;

  link(node1, node2){
    endpoints = new List<node>(2);
    endpoints[0]=(node1);
    endpoints[1]=(node2);
  }

  ///Returns a list<node> that contains the two nodes that this link links.
  List<node> getEndPoints(){
    return endpoints;
  }

}