/*This dart file will contain the node class*/
import 'Link.dart';
import 'VectorMath.dart';

class node{ //currently just boolean nodes, will add multiple states in future classes

  String name;
  int stateCount; //keeps track of how many states this node has (e.g. 2 for a true/false node)
  List<String> stateLabels = ['not yet defined'];

  Map<node,link> outGoing = new Map();
  Map<node,link> inComing = new Map();

  // -------- Various State variables --------

  bool hasEvidence;
  bool hasHardEvidence;
  bool hasProperLinkMatrix; //(false= values in matrix needs updating, true = no updating required)

  // -------- Inference Related Items --------
  Matrix2 LinkMatrix; //2x2 matrix is default (this corresponds to no parents)
  Vector Posterior; //This would be equal in dimension to the amount of states the node can have

  //gained from other nodes
  Vector LambdaEvidence; //this should be set to 1 by default, which equates to no evidence
  Vector PiEvidence; //this should be set to 1 by default, which equates to no evidence

  //sent out to other nodes
  Vector LambdaMessage; //this should be set to 1 by default, which equates to no evidence
  Vector PiMessage; //this should be set to 1 by default, which equates to no evidence*/

  // ------------- METHODS --------------

  node(this.name, this.stateCount){ //constructor
    LinkMatrix = new Matrix2(stateCount,getIncomingStates());
    LinkMatrix.identity();
    hasProperLinkMatrix = true;

    Posterior = new Vector(stateCount);
    PiMessage = new Vector(stateCount);
    LambdaMessage = new Vector(stateCount);
    for(int i=0; i< stateCount;i++){
      PiMessage[i]=1.0; //this is the default and is equivalent to no evidence
      LambdaMessage[i]=1.0; //this is the default and is equivalent to no evidence
    }
    ComputePiEvidence();
    ComputeLambdaEvidence();
  }

  String getName(){
    return name;
  }

  int getStateCount(){
    return stateCount;
  }

  int getIncomingStates(){
    int incomingStateCount = 1 ;
    inComing.keys.forEach((node){
      incomingStateCount = incomingStateCount*node.getStateCount();
    });
    if (incomingStateCount == 1){ //this means this node must be a root node
      return stateCount; //we must therefore propagage a root Pi Message
    }
    else{
      return incomingStateCount; //this is not a root note, so probabilities will depend on the incoming nodes which
    }
  }

  setStateCount(int stateCountIn, List<String> labels){ //if you wish to alter the amount of states the node has, it is required you also add the proper new labels
    if (stateCount != stateCountIn) {
      stateCount = stateCountIn;
      resetLinkMatrixStructure(); //clearly, the link matrix must be altered
      stateLabels = labels; //also update the new labels
    }
    else{
      print('this is already the current amount of states this node has \n');
    }
  }

  setStateLabels(List<String> labels){ //allows for user set labels for each state (more easily to interpret for human being than linkmatrix[0] or something)
    if(labels.length == stateCount){
      stateLabels = labels;
    }
    else{
      print('sorry, the amount of labels should match the current amount of states of the nodes (' + stateCount.toString() + ") - if you also wish to to change the amount of states, use .setStateCount");
    }
  }

  resetLinkMatrixStructure(){ //to be called each time something regarding the link matrix is changed (so this would be a new state added to node, or a new parent node being added)
    PiEvidence = new Vector(stateCount);
    LambdaEvidence = new Vector(stateCount);
    for(int i=0; i< stateCount;i++){
      PiEvidence[i]=1.0; //this is the default and is equivalent to no evidence
      LambdaEvidence[i]=1.0; //this is the default and is equivalent to no evidence
    }
    LinkMatrix = new Matrix2(stateCount, getIncomingStates()); //this ensures the proper dimensions of the link matrix, but the user will still have to manually enter the accurate probabilities
    setLinkMatrixStatus(false); //indicates the values need to be updated (false= needs updating, true = no updating required)
  }

  setLinkMatrixStatus(bool boolIn){ //false means the LinkMatrix has to be changed, true means the LinkMatrix should be correct //FIX no longer make this a method (shouldnt be called outside node, but kept for debugging)
    hasProperLinkMatrix = boolIn;
  }

  bool getLinkMatrixStatus(){
    return hasProperLinkMatrix;
  }

  Matrix2 getLinkMatrix(){ //should be only for debugging //FIX
    return LinkMatrix;
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
    for(var i=0;i < stateLabels.length; i++ ){
      Buffer.write( 'row[' + i.toString() +  '] = '  + stateLabels[i] + ', ');
    };
    Buffer.write('\n' + LinkMatrix.toString());
    return Buffer.toString();
  }

  bool enterLinkMatrix(Matrix2 updatedMatrix){ //the link matrix contains the probalities of this node havign value x given the values of the parents (the amount of rows related to the amount of states of the node)
    LinkMatrix = updatedMatrix;
    setLinkMatrixStatus(true); //this should trigger if the updated matrix is valid
  }

  bool HardEvidenceStatus(){
    return hasHardEvidence;
  }

  Vector getProbability(){
    return Posterior;
  }

  UpdatePosterior(){

    Posterior[0]=PiEvidence[0]*LambdaEvidence[0]; //updating posterior with lambda and pi evidence (note that probabilities may not sum to one)
    Posterior[1]=PiEvidence[1]*LambdaEvidence[1]; //updating posterior with lambda and pi evidence (note that probabilities may not sum to one)
    Posterior.SumToOne(); //make sure probabilities sum to 1
    //print(Posterior);
  }

  EnterPiMessage(Vector piMessageIn){
    if(piMessageIn.getSize()==stateCount){
      PiMessage = piMessageIn;
      ComputePiEvidence();
    }
  }

  ComputePiEvidence(){
    PiEvidence = LinkMatrix*PiMessage;
  }

  ComputeLambdaEvidence(){
    LambdaEvidence = LambdaMessage; //FIX
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
    resetLinkMatrixStructure();
  }

  addOutgoing(node daughterNode, link connectingLink){
    var map ={};
    map[daughterNode]=connectingLink;
    outGoing.addAll(map);

    //daughterNode.setLinkMatrixStatus(false); //since this daughter node has a new parent, its link matrix is incomplete and needs to be updated
    //daughterNode.resetLinkMatrixStatus();
  }
}