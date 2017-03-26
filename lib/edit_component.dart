import 'package:angular2/core.dart';

import 'package:angular2_components/angular2_components.dart';
import 'package:angular2/router.dart';

import 'node.dart';
import 'vector_math.dart';
import 'package:causecade/app_component.dart';

@Component(
    selector: 'edit-node',
    templateUrl: 'edit_component.html',
    styles: const ['''
                    main{
                      margin-left: 4em ;
                      margin-top: 45em ;
                    }
                   '''],
    directives: const [materialDirectives],
    providers: const [materialProviders])

// THIS IS STILL WIP
class EditComponent implements OnInit {
  final RouteParams _routeParams;

  node SelectedNode;
  bool ShouldBeHidden;
  bool showMatrixEditor;
  int StateCount;

  Vector Observation; //these will be used
  Vector Prior;
  Matrix2 LinkMatrix;

  int state_count_new;
  List<double> ObservationList;
  List<double> PriorList;
  List<double> Probability = new List<double>();
  List<String> LabelNew;
  List<String> LabelOld;
  String newLinkParent;
  String newLinkDaughter;

  //holds information about the selected node


  //holds information about the selected node
  List IncomingNodes;

  //holds information about the selected node
  List OutGoingNodes;

  List LinkList  = new List(); //holds links associated with this node

  //holds information about the selected node

  EditComponent(this._routeParams);

  void ngOnInit() {
    showMatrixEditor = false;
    if(_routeParams.get('id')!=null) {
      setupCard();
    }
    else{
      //else, we should hide this component
      ShouldBeHidden=true;
    }
  }

  void setNewLinkParent(dynamic event){newLinkParent=event.target.value;}
  void setNewLinkDaughter(dynamic event){newLinkDaughter=event.target.value;}

  void addNewParentLink(){
    if((newLinkParent!=null)) {
      myDAG.insertLink(myDAG.findNode(newLinkParent),SelectedNode);
      fetchLinks();
    }
    else{
      print('please enter proper node name, and try again');
    }
  }

  void addNewDaughterLink(){
    if((newLinkParent!=null)) {
      myDAG.insertLink(SelectedNode,myDAG.findNode(newLinkDaughter));
      fetchLinks();
    }
    else{
      print('please enter proper node name, and try again');
    }
  }

  removeLink(LinkIn){
    myDAG.removeEdge(LinkIn);
    fetchLinks();
  }

  void setupCard(){

    SelectedNode = myDAG.findNode(_routeParams.get('id'));
    IncomingNodes = SelectedNode.getParents();
    OutGoingNodes = SelectedNode.getDaughters();
    StateCount = SelectedNode.getStateCount();
    LinkMatrix=SelectedNode.getLinkMatrix();
    fetchOldLabels();
    LabelNew= new List<String>(StateCount);

   fetchLinks();

    ObservationList = new List<double>(StateCount);
    Observation = new Vector(StateCount);
    PriorList = new List<double>(StateCount);
    Prior = new Vector(StateCount);

    for(int i =0;i<SelectedNode.getStateCount();i++){
      Probability.add(SelectedNode.getProbability()[i]);
    }
  }

  fetchOldLabels(){
    LabelOld = new List<String>(StateCount);
    for(int i=0;i<StateCount;i++){
      LabelOld[i]='not yet defined';
    }
    for(int i=0;i<SelectedNode.getStateLabels().length;i++){
      LabelOld[i]=SelectedNode.getStateLabels()[i];
    }
  }

  fetchLinks(){
    LinkList.clear();
    SelectedNode.getInComing().values.forEach((link){
      LinkList.add(link);
    });
    SelectedNode.getOutGoing().values.forEach((link){
      LinkList.add(link);
    });
  }


  void setPriorValue(int index, dynamic event){
    PriorList[index] = double.parse(event.target.value);
    print(event.target.value.toString());
  }

  //actually set the value
  void setPrior(){
    Prior.setValues(PriorList);
    SelectedNode.setPiEvidence(Prior); //Sets the prior.
    SelectedNode.setRootStatus(true);
    //node will now have isRootNode=true;
  }

  //TODO: find a better implementation (that cant result in user error)
  void setObservationValue(int index, dynamic event){
    ObservationList[index] = double.parse(event.target.value);
    print(event.target.value.toString());
  }

  void setObservation(){
    Observation.setValues(ObservationList);
    SelectedNode.setProbability(Observation); //sets observation
    //node will now have Instantiated=true;
  }

  void setNewLabel(int index, dynamic event){
    LabelNew[index] = event.target.value;
  }

  void pushNewLabels(){
    SelectedNode.setStateLabels(LabelNew);
  }
  void pushNewMatrix(){
    SelectedNode.enterLinkMatrix(LinkMatrix); //sets the (possibly changed)
    showMatrixEditor = false;
    //matrix. If no changes are made in the ui this wont change anything.
  }

  void updateEdits(){
    myDAG.updateNetwork();
    print('pushing user edits, and forcing network update');
  }

  void printNetworkToConsole(){
    print(myDAG.toString());
  }

  void setNewStateCountValue(dynamic event){
    state_count_new = int.parse(event.target.value);
  }

  //TODO: make this bulletproof, currently just breaks a lot of things, not
  // very user friendly at all
  void setNewStateCount(){
    SelectedNode.setStateCount(state_count_new,LabelOld);
    print('updated the new count, but please change labels');
  }

}