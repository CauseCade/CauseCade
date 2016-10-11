/*This dart file will contain the node class*/
import 'Link.dart';
import 'VectorMath.dart';

class node{ //currently just boolean nodes, will add multiple states in future classes

  String name;
  Map<node,link> outGoing = new Map();
  Map<node,link> inComing = new Map();

  bool hasEvidence = false;
  bool hasHardEvidence = false;

  Matrix2 LinkMatrix = new Matrix2(2,2); //2x2 matrix is default (this corresponds to no parents)
  Vector2 Posterior = new Vector2(-9.99,-9.99); //This would be equal in dimension to the amount of states the node can have

  //gained from other nodes
  Vector2 LambdaEvidence = new Vector2(1.0,1.0); //this should be set to 1 by default, which equates to no evidence
  Vector2 PiEvidence = new Vector2(1.0,1.0); //this should be set to 1 by default, which equates to no evidence

  //sent out to other nodes
  Vector2 LambdaMessage = new Vector2(1.0,1.0); //this should be set to 1 by default, which equates to no evidence
  Vector2 PiMessage = new Vector2(1.0,1.0); //this should be set to 1 by default, which equates to no evidence*/

  node(this.name){}

  String getName(){
    return name;
  }

  bool getEvidenceStatus(){
    return hasEvidence;
  }

  String getLinkMatrixInfo(){
    var Buffer = new StringBuffer();
    Buffer.write('> Requested LinkMaxtrix for node: ' + name + '\n');
    inComing.keys.forEach((node){
      Buffer.write('InComing Nodes in Order: ' + node.getName() +'\n');
    });
    Buffer.write( '[0] = Node:true, [1]=Node:false \n'+ LinkMatrix.toString());
    return Buffer.toString();
  }

  bool enterLinkMatrix(Matrix2 updatedMatrix){ //the link matrix contains the probalities of this node havign value x given the values of the parents
    LinkMatrix = updatedMatrix;
  }

  bool HardEvidenceStatus(){
    return hasHardEvidence;
  }

  Vector2 getProbability(){
    return Posterior;
  }

  UpdatePosterior(){
    Posterior[0]=PiEvidence[0]*LambdaEvidence[0]; //updating posterior with lambda and pi evidence (note that probabilities may not sum to one)
    Posterior[1]=PiEvidence[1]*LambdaEvidence[1]; //updating posterior with lambda and pi evidence (note that probabilities may not sum to one)
    Posterior = Posterior.normalise(); //make sure probabilities sum to 1
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