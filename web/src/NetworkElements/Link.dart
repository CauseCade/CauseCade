/*This dart file will contain the link class*/
import 'Node.dart';

class link{

  List<node> endpoints;

  link(node1, node2){
    endpoints = new List<node>(2);
    endpoints[0]=(node1);
    endpoints[1]=(node2);
  }

  List<node> getEndPoints(){
    return endpoints;
  }

}