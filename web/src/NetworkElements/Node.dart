/*This dart file will contain the node class*/
import 'Link.dart';

class node{ //currently just boolean nodes, will add multiple states in future classes

  String name;
  Map<node,link> outGoing = new Map();
  Map<node,link> inComing = new Map();

  bool hasEvidence = false;
  bool hasHardEvidence = false;
  Map<String,double> probDependency = new Map<String,double>(); //dependency on other nodes

  Map<bool,double> UnconditionalProbabilityDistribution = new Map<bool,double>();
  Map<bool,double> ProbabilityDistribution = new Map<bool,double>();

  node(this.name){}

  String getName(){
    return name;
  }

  bool getEvidenceStatus(){
    return hasEvidence;
  }

  bool HardEvidenceStatus(){
    return hasHardEvidence;
  }

  Map<bool,double> getProbability(){
    return ProbabilityDistribution;
  }

  enterUnconditionalProbability(var probTrue, var probFalse){
    if(probTrue+probFalse==1) {
      UnconditionalProbabilityDistribution[true] = probTrue;
      UnconditionalProbabilityDistribution[false] = probFalse;
      if (!hasEvidence) {
        ProbabilityDistribution[true] = probTrue;
        ProbabilityDistribution[false] = probFalse;
      }
    }
    else{
      print('[] sorry these probabilities do not sum to one, please make sure you entered these values correctly');
    }
  }

  enterDependency(Map<String,double> newDependency){
    probDependency = newDependency;
  }

  enterHardEvidence(bool BoolIn){
    hasEvidence = true;
    hasHardEvidence = true;
    if(BoolIn){
      ProbabilityDistribution[true]=1 as double;
      ProbabilityDistribution[false]=0 as double;
    }
    else{
      ProbabilityDistribution[true]=0 as double;
      ProbabilityDistribution[false]=1 as double;
    }
  }

  Map<bool,double> getProbDist(){
    return ProbabilityDistribution;
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