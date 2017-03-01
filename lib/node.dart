/*This dart file will contain the node class*/
import 'package:causecade/link.dart';
import 'package:causecade/vector_math.dart';

class node{

  String name;
  int stateCount; //keeps track of how many states this node has (e.g. 2 for a true/false node)
  List<String> stateLabels = ['not yet defined'];

  Map<node,link> outGoing = new Map();
  Map<node,link> inComing = new Map();

  // -------- Various State variables --------

  bool isInstantiated=false; //true = has hard evidence/observed state

  //(false= values in matrix needs updating, true = no updating required)
  bool hasProperLinkMatrix;

  // this will tell the network if this node needs to be updated
  // (this will be triggered if new evidence is entered somewhere in the network)
  bool Flagged = false;
  String FlaggedID; //this will hold the identifier of which node last flagged this one //FIX replace with node object

  // -------- Inference Related Items --------

  Matrix2 LinkMatrix; //2x2 matrix is default (this corresponds to no parents)
  Vector Posterior; //This would be equal in dimension to the amount of states the node can have

  //gained from other nodes
  Vector LambdaEvidence; //this should be set to 1 by default, which equates to no evidence
  Vector PiEvidence; //this should be set to 1 by default, which equates to no evidence

  //sent out to other nodes
  Vector LambdaMessage; //this should be set to 1 by default, which equates to no evidence
  Vector PiMessage; //this should be set to 1 by default, which equates to no evidence*/

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
    _ComputePiEvidence();
    _ComputeLambdaEvidence();
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
    isInstantiated=true;
    FlaggedID=''; //We now have no more memory of what updated the node
    _FlagOtherNodes(name);
    print('posterior is' + Posterior.toString());
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

  List<String> getStateLabels(){
    return stateLabels;
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

  setFlagged(String FlaggedIDIn){
    Flagged = true;
    FlaggedID =FlaggedIDIn;
  }

  bool getFlaggedStatus(){
    return Flagged;
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

  bool enterLinkMatrix(Matrix2 updatedMatrix){
    if (_ValidateLinkMatrix(updatedMatrix)){
      LinkMatrix = updatedMatrix;
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
      Flagged = false;
    }
    else{
      print('This node is already instantiated, and cannot be affected');
    }
    _FlagOtherNodes(name);
    print('posterior is' + Posterior.toString());
  }

/*  // this should only be called when you enter evidence for a node //FIX COMMENTED 01-03-2017 Replaced by setProbability (may need a separate method again later)
  EnterPiMessage(Vector piMessageIn){
    if(piMessageIn.getSize()==stateCount){
      PiMessage = piMessageIn;
      _ComputePiEvidence();
     // _FlagOtherNodes(name); //FIX - CHANGED 01-03-2017 (seems already contained in UpdatePosterior)
    }
    else{
      print('sorry you need to have the right dimensionality of your vector');
    }
  }*/

  //this will be called if another node in the network has been updated
  //and this one is flagged to be updated in light of the new evidence
  FetchPiMessage(){

    if (isInstantiated){
      PiMessage=Posterior;
    }
    else{
      //the vector must have right dimensions
      PiMessage = new Vector(_getIncomingStates());
      //print(inComing.keys.length);
      // print('incoming nodes for Fetching: ');
      //inComing.keys.forEach((node){print(node.getName());});

      List<int> kappa = new List(inComing.keys.length); //FIX
      for(var i =0; i<kappa.length;i++){
        kappa[i]=0;
      }

      if(inComing.keys.length != 1) {
        _recursivePiFetch(kappa, 0);
      }
      else{
        PiMessage = inComing.keys.elementAt(0).getProbability();
      }

      //print('fetching pi message....');
    }
    print('our PiMessage is: ' + PiMessage.toString());
    _ComputePiEvidence();
  }

  _recursivePiFetch(List<int> LocationTracker,int vectorIndex){
    /*print('entering recursive loop');
    print('Vectorindex is: ' + vectorIndex.toString());
    print('LocationTracker is: ' + LocationTracker.toString());*/

    PiMessage[vectorIndex]=1.0; /*update the actual PiMessage*/
    for(var i=0; i<LocationTracker.length;i++) {
      /* print('debug message; index: ' + i.toString());
      print(inComing.keys.elementAt(i).getProbability());*/
      PiMessage[vectorIndex] = PiMessage[vectorIndex]*inComing.keys.elementAt(i).getProbability()[LocationTracker[i]];
    }

    vectorIndex++;
    LocationTracker[LocationTracker.length-1]++;

    if(vectorIndex<PiMessage.getSize()) { //trivial check to see if we are done

      for (var i = 0; i < LocationTracker.length; i++) {
        //increase vectorindex and update LocationTracker  /*these loops can have a lot fewer method calls*/ //FIX

        if (LocationTracker[LocationTracker.length -i-1]==inComing.keys.elementAt(LocationTracker.length-i-1).getStateCount()) {
          LocationTracker[LocationTracker.length - i-1] = 0;
          LocationTracker[LocationTracker.length - i-2]++;
        }
      }

      _recursivePiFetch(LocationTracker,vectorIndex); //recursive call
    }
  }

  fetchLambdaMessage(){ //FIX, only wokrs for 1 parent node atm, multiple parent support incoming
    /* inComing.keys.forEach((node){
        LambdaMessage.setValues([]);
      });*/
    outGoing.keys.forEach((node){ //we must check the OUTGOING nodes (they  send the lambda message to the node before it!
      //print(node.getName()+FlaggedID);
      if (node.getName()==FlaggedID){ //FIX, this can be done so much more efficiently
        print(node.getName()+FlaggedID);
        //inComing.keys.forEach((node){
        LambdaMessage=node.sendLambdaMessage();
        print('we are passing lambda message upwards');
        //});
        _ComputeLambdaEvidence();
      }
    });

  }

  Vector sendLambdaMessage(){

    Vector lambdaToSend= new Vector(LinkMatrix.getColumnCount());
    for (int i=0; i<LinkMatrix.getColumnCount();i++){
      double sum=0.0;
      for(int j=0; j<LinkMatrix.getRowCount();j++){
        sum=sum+LinkMatrix[j][i]*Posterior[j];
      }
      lambdaToSend[i]=sum;
    }
    print(lambdaToSend.toString());
    return lambdaToSend;
  }

  _ComputePiEvidence(){
    PiEvidence = LinkMatrix*PiMessage;
  }

  _ComputeLambdaEvidence(){
    LambdaEvidence=LambdaMessage;
    // If C is a node with Children D1,D2,D3,...,Dn then lambda evidence =
/*    // 1 if the node is instatiated.
    // if not instantiated then it is the product of all the
    // lambda messages from the children

    //This holds the value that will be assigned as lambda evidence
    //after a few loops
    Vector LambdaEvidenceHolder = new Vector(stateCount);
    LambdaEvidenceHolder.setAll(1.0);
    outGoing.keys.forEach((node){
      LambdaEvidenceHolder = LambdaEvidenceHolder*node.getLambdaMessage(this);
      //all vectors should be of size equal to the amount of states of this node
    });
    //LambdaEvidence = LambdaMessageHolder;
    LambdaEvidence = LambdaMessage; //FIX*/
  }

  //flags all directly connected node to be updated anc passes
  //from which node it has received evidence (to prevent circling evidence))
  _FlagOtherNodes(String NodeID){
    outGoing.keys.forEach((node){
      if(node.getName()!=FlaggedID) {
        node.setFlagged(NodeID);
      }
    });
    //uncomment when Upwards propagation is implemented
    inComing.keys.forEach((node){
      if(node.getName()!=FlaggedID) {
        node.setFlagged(NodeID);
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