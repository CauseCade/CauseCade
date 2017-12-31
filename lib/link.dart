/*This dart file will contain the link class*/
import 'package:causecade/node.dart';
import 'package:dartson/dartson.dart';

@Entity()
class link{

  @Property(ignore:true)
  List<node> endpoints = new List<node>(2);
  //ensures we obtain a compact JSON file, not used for anything computational
  @Property(name:"endpointnames")
  List<String> stringEndpoints = new List<String>(2);

  link(); //constructor

  set origin(node nodeOne){
    endpoints[0] = nodeOne;
    stringEndpoints[0]=nodeOne.name;
  }

  set target(node nodeTwo){
    endpoints[1] = nodeTwo;
    stringEndpoints[1]=nodeTwo.name;
  }
  node get origin => endpoints[0];

  node get target => endpoints[1];

    ///Returns a list<node> that contains the two nodes that this link links.
  List<node> getEndPoints(){
    return endpoints;
  }

}