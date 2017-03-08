/*This dart file will contain the node class*/
import 'link.dart';
import 'package:causecade/vector_math.dart';

class node{

  String name;
  int stateCount; //keeps track of how many states this node has (e.g. 2 for a true/false node)
  List<String> stateLabels = ['not yet defined'];
  List<String> matrixLabels = ['not yet defined']; //hold matrix labels
  List<Vector> matrixIndexes = [];

  Map<node,link> outGoing = new Map();
  Map<node,link> inComing = new Map();

  // -------- Various State variables --------

  bool isInstantiated=false; //true = has hard evidence/observed state
  bool isRootNode=false;

  //(false= values in matrix needs updating, true = no updating required)
  bool hasProperLinkMatrix;

  // this will tell the network if this node needs to be updated
  // (this will be triggered if new evidence is entered somewhere in the network)
  bool flagged = false;
  node flaggingNode; //this will hold the identifier of which node last flagged this one //FIX replace with node object

  // -------- Inference Related Items --------

  Matrix2 LinkMatrix; //2x2 matrix is default (this corresponds to no parents)
  Vector Posterior; //This would be equal in dimension to the amount of states the node can have

  //gained from other nodes
  Vector LambdaEvidence; //this should be set to 1 by default, which equates to no evidence
  Vector PiEvidence; //this should be set to 1 by default, which equates to no evidence

  //sent out to other nodes
  Vector LambdaMessage; //this should be set to 1 by default, which equates to no evidence
  Vector PiMessage; //this should be set to 1 by default, which equates to no evidence*/
  /*List<Vector> LambdaMessageHolder; //this will hold the lambda messages received //TODO: consider
  //this is required to allow for adequate piMessage Generation.*/

  // ------------- CONSTRUCTOR --------------

  node(this.name, this.stateCount){ //constructor
    LinkMatrix = new Matrix2(stateCount,_getIncomingStates());
    LinkMatrix.identity();
    hasProperLinkMatrix = true;

    Posterior = new Vector(stateCount);
    PiMessage = new Vector(stateCount);
    LambdaMessage = new Vector(stateCount);
    for(int i=0; i< stateCount;i++){
      PiMessage[i]=1.0; //this is the default and is equivalent to no evidence
      LambdaMessage[i]=1.0; //this is the default and is equivalent to no evidence
    }
    //_ComputePiEvidence();
    ComputeLambdaEvidence();
  }

  // ------------- OTHER METHODS --------------

  String getName(){
    return name;
  }

  int getStateCount(){
    return stateCount;
  }

  Vector getProbability(){
    return Posterior;
  }

//if you wish to alter the amount of states the node has,
//it is required you also add the proper new labels
  setStateCount(int stateCountIn, List<String> labels){
    if (stateCount != stateCountIn) {
      stateCount = stateCountIn;
      resetLinkMatrixStructure(); //clearly, the link matrix must be altered
      stateLabels = labels; //also update the new labels
    }
    else{
      print('this is already the current amount of states this node has \n');
    }
  }

  //allows for user set labels for each state
  //(more easily to interpret for human being than linkmatrix[0] or something)
  setStateLabels(List<String> labels){
    if(labels.length == stateCount){
      stateLabels = labels;
    }
    else{
      print('sorry, the amount of labels should match the current amount'
          ' of states of the nodes (' + stateCount.toString() +
          ") - if you also wish to to change the amount of states,"
              " use .setStateCount");
    }
  }

  setProbability(Vector observedProbability){
    //This method is called when hard evidence (observed state of variable)
    // is entered. This means other nodes can (logically) no longer affect it.
    Posterior=(observedProbability);
    Posterior.SumToOne();
    LambdaEvidence=Posterior; //TODO: done at 08-17
    PiEvidence=Posterior;//TODO: done at 08-17
    isInstantiated=true;
    flaggingNode=null; //We now have no more memory of what updated the node
    _FlagOtherNodes();// Networks needs to be updated

  }

  //false means the LinkMatrix has to be changed, true means the LinkMatrix
  //should be correct //FIX no longer make this a method
  _setLinkMatrixStatus(bool boolIn){
    hasProperLinkMatrix = boolIn;
  } //FIX probably want to remove this method to improve performance

  bool getLinkMatrixStatus(){
    return hasProperLinkMatrix;
  }

  Matrix2 getLinkMatrix(){ //should be only for debugging //FIX
    return LinkMatrix;
  }

  bool getEvidenceStatus(){
    return isInstantiated;
  }

  bool getRootStatus(){
    return isRootNode;
  }

  setRootStatus(bool BoolIn){
    isRootNode = BoolIn;
  }

  //Should be called only when setting prior probability.
  setPiEvidence(Vector ProbabilityIn){
    PiEvidence=ProbabilityIn;
  }

  List<String> getStateLabels(){
    return stateLabels;
  }
  //TODO: remove method
  List<String> getMatrixLabels(){
    return matrixLabels;
  }

  //TODO: remove method
  List<Vector> getMatrixIndexes(){
    return matrixIndexes;
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
    Buffer.write('\n ' + matrixLabels.toString());
    Buffer.write('\n' + LinkMatrix.toString());
    return Buffer.toString();
  }

  setFlagged(node FlaggingNodeIn){
    flagged = true;
    flaggingNode =FlaggingNodeIn;
  }

  bool getFlaggedStatus(){
    return flagged;
  }

  Vector getLambdaMessage(node NodeToBeUpdated){
    return LambdaMessage; //This needs some more work
  }

  Map<node,link> getOutGoing(){
    return outGoing;
  }

  Map<node,link>  getInComing(){
    return inComing;
  }

  // --------------- Changes to Network Structure --------------

  //to be called each time something fundamental regarding the link matrix
  //is changed(so this would be a new state added to node,
  // or a new parent node being added)
  resetLinkMatrixStructure(){
    PiEvidence = new Vector(stateCount);
    LambdaEvidence = new Vector(stateCount);
    for(int i=0; i< stateCount;i++){
      PiEvidence[i]=1.0;//this is the default and is equivalent to no evidence
      LambdaEvidence[i]=1.0;//this is the default and is equivalent to no evidence
    }
    // this ensures the proper dimensions of the link matrix,
    // but the user will still have to manually enter the accurate probabilities
    LinkMatrix = new Matrix2(stateCount, _getIncomingStates());
    // indicates the values need to be updated:
    // (false= needs updating, true = no updating required)
    _setLinkMatrixStatus(false);
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

    //daughterNode.setLinkMatrixStatus(false);
    // since this daughter node has a new parent,
    // its link matrix is incomplete and needs to be updated
    //daughterNode.resetLinkMatrixStatus();
  }

  // --------------- Changes to Values --------------

  //the link matrix contains the probabilities of this node having value x
  //given the values of the parents
  //(the amount of rows related to the amount of states of the node)

  _generateMatrixLabels(int currentParent, int Limit,String matrixLabelToAdd){
    for( int i =0; i<inComing.keys.elementAt(currentParent).getStateCount();i++){
      //print('Start-------------------');
      //print('our parent is '+inComing.keys.elementAt(currentParent).getName().toString());
      //print('our limit is '+Limit.toString());

      if(currentParent+1<Limit) {
        _generateMatrixLabels(currentParent+1,Limit, matrixLabelToAdd + '+' + inComing.keys.elementAt(currentParent).getName() + ':' + inComing.keys.elementAt(currentParent).getStateLabels()[i].toString());
      }
      else{
        matrixLabels.add(matrixLabelToAdd + '+' + inComing.keys.elementAt(currentParent).getName() + ':' + inComing.keys.elementAt(currentParent).getStateLabels()[i].toString());
        //print('matrixlabels right now' + matrixLabels.toString());
      }
    }
  }
  _generateMatrixIndexes(int currentParent, int Limit,String matrixIndexToAdd){
    for( int i =0; i<inComing.keys.elementAt(currentParent).getStateCount();i++){
      //print('Start-------------------');
      //print('our parent is '+inComing.keys.elementAt(currentParent).getName().toString());
      //print('our limit is '+Limit.toString());

      if(currentParent+1<Limit) {
        _generateMatrixIndexes(currentParent+1,Limit, matrixIndexToAdd + '+' + i.toString());
      }
      else{
        //matrixIndexToAdd=matrixIndexToAdd+ '+' + i.toString();
        //print('matrix index to add: ' +matrixIndexToAdd);
        Vector indexHolder  = new Vector(inComing.keys.length);
        indexHolder.setValues([]);
        matrixIndexes.add(indexHolder);
        //print('matrixlabels right now' + matrixLabels.toString());
      }
    }
  }


  bool enterLinkMatrix(Matrix2 updatedMatrix){
    if (_ValidateLinkMatrix(updatedMatrix)){
      LinkMatrix = updatedMatrix;
      matrixLabels.clear(); //clear before generating new ones
      matrixIndexes.clear(); //clear before generating new ones
      _generateMatrixLabels(0,inComing.keys.length,'');
      _generateMatrixIndexes(0,inComing.keys.length,'');
      _setLinkMatrixStatus(true); //this should trigger if the updated matrix is valid
      print('New Matrix Set');
    }
    else{
      print('sorry this is not a valid matrix');
    }
  }

  //checks if matrix is valid from a probability point of view
  bool _ValidateLinkMatrix(Matrix2 matrix){
    var Probabilityholder; //only used in this function
    for(var i =0; i<matrix.getColumnCount();i++){
      Probabilityholder =0;
      for(var j=0; j< matrix.getRowCount();j++){
        Probabilityholder = Probabilityholder + matrix[j][i];
      }
      //The probabilities should always sum to 1
      //(i have put >99 due to rounding errors for now //FIX
      if(Probabilityholder < 0.999){
        return false;
      }
    }
    //Also Check if matrix has the right dimensions
    if (matrix.getRowCount()!=stateCount || matrix.getColumnCount()!= _getIncomingStates()){
      print('The dimensionss should be:' + matrix.getRowCount().toString() + matrix.getColumnCount().toString());
      return false;
    }
    return true;
  }

  //this computes a new posterior value - this means you must have updated
  //either lambda evidence or pievidence for this to change the posterior
  UpdatePosterior(){
    if(!isInstantiated){
      //print('statecount is: ' + stateCount.toString());
      for(var i =0; i<stateCount;i++){
        //updating posterior with lambda and pi evidence
        // (note that probabilities may not sum to one - thats okay)
        Posterior[i]=PiEvidence[i]*LambdaEvidence[i];
      }
      Posterior.SumToOne(); //make sure probabilities sum to 1
      //if we have called this method we assume we have also updated
      //both our Pi and Lambda messages - we must set flagged status false,
      //we dont have to update this one anymore
      flagged = false;
    }
    else{
      print('This node is already instantiated, and cannot be affected');
    }
    _FlagOtherNodes();
    print('posterior is' + Posterior.toString());
  }

  //TODO: give this a better name + store vector to improve performance
  Vector sendPiProbability(node NodeToExclude){
    //the PiProbability must not include the eviudence from the node
    //Imagine A->B. If B gets evidence it will change A. This change in A could
    //then influence B again etc
    //this is a special version of computeLambdaEvidence()
    Vector PiProbability = new Vector(stateCount);
    PiProbability.setAll(1.0); //get a clean Vector

    outGoing.keys.forEach((node) {
      if(node!=NodeToExclude) {
        PiProbability= PiProbability*node.sendLambdaMessage(this);
      }
    });

    //This is essentiall the posterior, but now with the evidence from the node
    //we are excluding removed (this is apparent from the calculation.
    //the only difference is that we have a slightlychange LambdaEvidence
    return (PiEvidence*PiProbability);
  }

  //this will be called if another node in the network has been updated
  //and this one is flagged to be updated in light of the new evidence
  FetchPiMessage(){
    if(isRootNode){
      print('This is a root node, no Pi evidence change required.');
    }
    else{
      PiMessage = new Vector(_getIncomingStates());
      int ParentNodeCount = inComing.keys.length;


      //the vector must have right dimensions
      inComing.keys.forEach((node){print("incoming nodes(Pi)"+ node.getName());});
      _RecursivePiMessage(1.0,0,ParentNodeCount,PiMessage);

      print('our PiMessage is: ' + PiMessage.toString());
    }
  }

  _RecursivePiMessage(double probabilityOld, int currentParent, int Limit,Vector PiMessage){
    for( int i =0; i<inComing.keys.elementAt(currentParent).getStateCount();i++){
      double probability=inComing.keys.elementAt(currentParent).sendPiProbability(this)[i]*probabilityOld;

      //print('Start-------------------');
      //print('our parent is '+inComing.keys.elementAt(currentParent).getName().toString());
      //print('our probability is '+probability.toString());
      //print('our limit is '+Limit.toString());

      if(currentParent+1<Limit) {
        //print('is this broek?');
        //print('END-------------------');
        _RecursivePiMessage(probability, currentParent+1,Limit, PiMessage);
      }
      else{
        //print('at limit');
        for(int j=0;j<PiMessage.getSize();j++) {

          if(PiMessage[j] == null){
            PiMessage[j]=probability;
            break;
          }
        }
        // print('piMessage at limit' + PiMessage.toString());
        // print('END-------------------');
      }
    }
  }

  //This sends the lambda message for ANOTHER node. Dont confuse it with
  //the lambda message for this node.
  Vector sendLambdaMessage(node NodeIn){
    // NodeIn = node requesting evidence, which must be a parent of this node
    Vector lambdaToSend = new Vector(NodeIn.getStateCount());
    //this lambdaToSend must have a probability for each state of the requesting
    //parent node. dimensionality=NodeIn.getStateCount();
    //print('Lambda Process: Generating Lambda Message by: ' + name);
    //First reduce the LinkMatrix to 1xn matrix with
    //n being amount of states of all parents. ex:
    // P(0.1)|[0.3][0.5][0.5] -> [0.1*0.3+0.9*0.7][0.1*0.5+0.9*0.5][0.1*0.5+0.9*0.5]
    // P(0.9)|[0.7][0.5][0.5]
    //print('Lambda Process: Found ReducedMatrix: ' + LinkMatrix.toString());
    Vector ReducedMatrix= new Vector(LinkMatrix.getColumnCount());
    for (int i=0; i<LinkMatrix.getColumnCount();i++){
      double sum=0.0;
      for(int j=0; j<LinkMatrix.getRowCount();j++){
        sum=sum+LinkMatrix[j][i]*LambdaEvidence[j];
      }
      ReducedMatrix[i]=sum;
    }//reduced Matrix is now a 1xn matrix, which we need to further work on.
    //print('Lambda Process: Found ReducedMatrix: ' + ReducedMatrix.toString());
    //In the case of a single parent, this reducedMatrix is simply the
    //lambda evidence, but in the case of multiple partens (e.g. A and B) it
    //contains the joint probabilities. If we want only the evidence for A
    //we must sum over all states of B.

    if(inComing.keys.length==1){
      lambdaToSend=ReducedMatrix;
      //print('Lambda Process: This node only has one parent.');
    }
    else{ //case > 1 (case = 0 should never happen)
      //print('Lambda Process: This node has multiple parents.');
      for (int i = 0; i < NodeIn.getStateCount(); i++) {
        lambdaToSend[i]=0.0;
        //print('Lambda Process: fetching state: ' + i.toString());
        _RecursiveLambdaMessage(1.0,0,inComing.keys.length,NodeIn,i,lambdaToSend,ReducedMatrix,false);
      }
      //this generates a new lambdaToSend
    }

    //lambdaToSend.SumToOne(); //optional rescaling;
    print('Lambda Process: final lambda message: ' + lambdaToSend.toString());
    return lambdaToSend;
  }

  //TODO: automate this for all states of interest - would reduce compuational time
  _RecursiveLambdaMessage(double probabilityIn,int currentParent,int Limit, node ParentOfInterest,int StateOfInterest, Vector LambdaMessageToChange,Vector ProbabilityVector,bool relevant){
    for( int i =0; i<inComing.keys.elementAt(currentParent).getStateCount();i++){

      double probability = probabilityIn; //to prevent other iterations of loop
      //modifying this value

      //We are looking to sum all the states with the parent we are sending
      //lambda message to with the right index
      if((inComing.keys.elementAt(currentParent)==ParentOfInterest)&&(i==StateOfInterest)){
        relevant=true;
        print('relevance found: ' + currentParent.toString()+ 'state: ' + StateOfInterest.toString());
      }
      //We should set it to false for the other states of this variable,
      //but not for any other layers (hard to explain)
      else if((inComing.keys.elementAt(currentParent)==ParentOfInterest)){
        relevant=false;
        print('no relevance');
      }
      else{
        probability=inComing.keys.elementAt(currentParent).getProbability()[i]*probability; //TODO: risky move, check if correct
        print('new probability: ' + probability.toString() + 'in parent: ' + inComing.keys.elementAt(currentParent).getName());
      }
      // print('Start-------------------');
      // print('our parent is '+inComing.keys.elementAt(currentParent).getName().toString());
      // print('our probability is '+probability.toString());
      // print('our limit is '+Limit.toString());

      if(currentParent+1<Limit) {
        // print('is this broek?');
        // print('END-------------------');
        _RecursiveLambdaMessage(probability, currentParent+1,Limit,ParentOfInterest,StateOfInterest,LambdaMessageToChange,ProbabilityVector,relevant);
      }
      else{
        //print('at limit');
        if(relevant){
          print('Found; we are adding to LambdaMessage: ' + probability.toString());
          for(int i=0; i<ProbabilityVector.getSize();i++) {
            if(ProbabilityVector[i]!=null) { //TODO: very inefficient
              LambdaMessageToChange[StateOfInterest] = LambdaMessageToChange[StateOfInterest] + probability*ProbabilityVector[i];
              ProbabilityVector[i]=null;
              print(ProbabilityVector.toString());
              break;
            }
          }
          //print(LambdaMessageToChange.toString());
        }
        // print('END-------------------');
      }
    }
  }

  // --------------------- Computing Pi&Lambda Evidences ----------------------

  //Compute the Pi Evidence (vector of dimensionality(StateCount)
  ComputePiEvidence(){
    //P(Node)=P(Node|Evidence)*P(Evidence)
    //This operation is just matrix-vector multiplication
    //The hard part is generating the PiMessage (in the case of multiple parents)
    if((!isInstantiated)&&(!isRootNode)) {
      print('Pi Process: START - Computing Pi Evidence');
      FetchPiMessage();
      PiEvidence = LinkMatrix * PiMessage;
      print('Pi Process: END - Pi Evidence Set: ' +
          PiEvidence.toString());
    }
    else if(isInstantiated) {
      print('this node is instantiated, so Pi evidence has no effect.');
    }
    else{
      print('this node is a root node, so Pi evidence has no effect.');
    }
  }

  //Compute the Lambda Evidence (vector of dimensionality(StateCount)
  ComputeLambdaEvidence(){
    if(!isInstantiated) {
      print('Lambda Process: START - Computing Lambda Evidence');
      LambdaMessage.setAll(1.0); //get a clean Lambda Message

      //Lambda Evidence is the product of the lambda messages from all the
      //daughter nodes. we must multiply them together for this to work
      outGoing.keys.forEach((node) {
        //sendLambdaMessage calls the daughter nodes to send the lambda message
        //for this specific node. This then handles the multiplication.
        LambdaMessage = LambdaMessage * node.sendLambdaMessage(this);
      });

      //The lambda evidence then just setting it to this product
      //remember that .updatePosterior has to be called in other for this to
      //result in the change of the posterior of the node.

      LambdaEvidence = LambdaMessage;
      print('Lambda Process: END - Lambda Evidence Set: ' +
          LambdaEvidence.toString());
    }
    else{
      print('this node is instantiated, so Lambda evidence has no effect.');
    }
  }

  //flags all directly connected node to be updated anc passes
  //from which node it has received evidence (to prevent circling evidence))
  _FlagOtherNodes(){
    if(flaggingNode!=null) {
      print('the flagging node was: ' + flaggingNode.getName());
    }
    outGoing.keys.forEach((node){
      if(node!=(flaggingNode)&&(node.getEvidenceStatus()!=true)) {
        print('this node is: ' + this.getName().toString());
        print('and we are flagging(child): ' + node.getName().toString() + ' <');
        node.setFlagged(this);
      }
    });
    //uncomment when Upwards propagation is implemented
    inComing.keys.forEach((node){
      if(node!=(flaggingNode)&&(node.getEvidenceStatus()!=true)) {
        print('this node is: ' + this.getName().toString());
        print('and we are flagging(parent): ' + node.getName().toString() + ' <');
        node.setFlagged(this);
      }
    });
  }

  // --------------------- No Category ----------------------

  //returns how many states this node's causes have
  //(ex:  1 parent node A with three states and 1 parent B with 2 states
  // will ensure this returns 6 options: A1B1 A2B1 A3B1 A1B2 A2B2 A3B2)
  int _getIncomingStates(){
    int incomingStateCount = 1 ;
    inComing.keys.forEach((node){
      incomingStateCount = incomingStateCount*node.getStateCount();
    });
    if (incomingStateCount == 1){ //this means this node must be a root node
      return stateCount;  //we must therefore propagage a root Pi Message
      //(this means the amount of input states must be
      //equal to the amount of states of This node)
    }
    else{
      return incomingStateCount;  //this is not a root note,
      // so probabilities will depend
      //on the incoming nodes which
    }
  }
}