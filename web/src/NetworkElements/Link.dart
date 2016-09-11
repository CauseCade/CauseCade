/*This dart file will contain the link class*/
import 'Node.dart';

class link{

  node Parent;
  node Daughter;

  link(parentNode, daughterNode){
    Parent = parentNode;
    Daughter = daughterNode;
  }
}