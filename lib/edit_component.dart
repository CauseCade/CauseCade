import 'package:angular2/core.dart';
import 'package:angular2/common.dart';

import 'package:angular_components/angular_components.dart';
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


class EditComponent implements OnInit {
  final RouteParams _routeParams;

  //TODO Remove
  String TestString;
  testTestString(double In){
    TestString=In.toString();
  }

  node SelectedNode;
  bool ShouldBeHidden;
  bool showMatrixEditor;
  int StateCount;

  Vector Observation; //these will be used
  Vector Prior;

  Matrix2 LinkMatrix;
  List<List<double>> MatrixValues;

  int state_count_new;
  List ObservationList;
  List PriorList;
  List<double> Probability = new List<double>();
  List<String> LabelNew;
  List<String> LabelOld;
  List<String> MatrixValueLabels;

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
    fetchMatrixValues();
    LabelNew= new List<String>(StateCount);


   fetchLinks();

    ObservationList = new List(StateCount);
    Observation = new Vector(StateCount);
    PriorList = new List(StateCount);
    Prior = new Vector(StateCount);

    for(int i =0;i<SelectedNode.getStateCount();i++){
      Probability.add(SelectedNode.getProbability()[i]);
    }
  }

  void fetchOldLabels(){
    LabelOld = new List<String>(StateCount);
    LabelNew = new List<String>(StateCount);
    for(int i=0;i<StateCount;i++){
      LabelOld[i]='not yet defined';
      LabelNew[i]='not yet defined';
    }
    for(int i=0;i<SelectedNode.getStateLabels().length;i++){
      LabelOld[i]=SelectedNode.getStateLabels()[i];
      LabelNew[i]=SelectedNode.getStateLabels()[i];
    }
  }

  //TODO: less duct-tape
  void fetchMatrixValues(){
    MatrixValueLabels=SelectedNode.getMatrixLabels();
    MatrixValues = new List<List<double>>(); //pointless type specification here
    for(int i=0;i<LinkMatrix.getRowCount();i++){
      List<double> valuesList = new List<double>();
      for(int j=0;j<LinkMatrix.getColumnCount();j++){
        valuesList.add(LinkMatrix[i][j]);
      }
      //print(valuesList);
      MatrixValues.add(valuesList);
    }
    //print(MatrixValues);
  }

  void fetchLinks(){
    LinkList.clear();
    SelectedNode.getInComing().values.forEach((link){
      LinkList.add(link);
    });
    SelectedNode.getOutGoing().values.forEach((link){
      LinkList.add(link);
    });
  }




  //TODO: avoid making all these lists
  void setPrior(){
    List<double> PriorListExtra = new List(StateCount);
    for(int i=0;i<PriorList.length;i++){
      PriorListExtra[i]=double.parse(PriorList[i]);
    }
    Prior.setValues(PriorListExtra);
    SelectedNode.setPiEvidence(Prior); //Sets the prior.
    SelectedNode.setRootStatus(true);
    //node will now have isRootNode=true;
  }

  void clearPrior(){
    SelectedNode.clearPiEvidence();
    SelectedNode.setRootStatus(false);
  }

 //TODO: avoid making all these lists
  void setObservation(){
    List<double> ObservationListExtra = new List(StateCount);
    print(ObservationList);
    for(int i=0;i<ObservationList.length;i++){
      ObservationListExtra[i]=double.parse(ObservationList[i]);
    }
    print(ObservationListExtra);
    Observation.setValues(ObservationListExtra);
    SelectedNode.setProbability(Observation); //sets observation

    //node will now have Instantiated=true;
  }

  void clearObservation(){
    print('Cleared Observation.');
    SelectedNode.clearProbability();
  }


  void setMatrixValue(int i, int j, dynamic event){
    LinkMatrix[i][j]=double.parse(event.target.value);
  }

  void setNewLabel(int index, dynamic event){
    LabelNew[index] = event.target.value;
  }

  void pushNewLabels(){
    SelectedNode.setStateLabels(LabelNew);
  }
  void pushNewMatrix(){
    SelectedNode.enterLinkMatrix(LinkMatrix); //sets the (possibly changed)
    LinkMatrix=SelectedNode.getLinkMatrix();
    SelectedNode.clearFlaggingNode();
    SelectedNode.FlagOtherNodes();
    fetchMatrixValues(); //we want to have the matrid values reflect the new matrix
    showMatrixEditor = false;
    //matrix. If no changes are made in the ui this wont change anything.
  }

  updateMatrixLabels(){
    print(SelectedNode.getInComing().keys.length);
    SelectedNode.clearMatrixLabels();
    SelectedNode.generateMatrixLabels(0,SelectedNode.getInComing().keys.length,'');
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

  //TODO give this some functionality
  void onSubmit() {
    print('pressed submit matrix!');
  }
  /// Returns a map of CSS class names representing the state of [control].
  Map<String, bool> controlStateClasses(NgControl control) => {
    'ng-dirty': control.dirty ?? false,
    'ng-pristine': control.pristine ?? false,
    'ng-touched': control.touched ?? false,
    'ng-untouched': control.untouched ?? false,
    'ng-valid': control.valid ?? false,
    'ng-invalid': control.valid == false
  };

  //TODO: make this bulletproof, currently just breaks a lot of things, not
  // very user friendly at all
  void setNewStateCount(){
    SelectedNode.setStateCount(state_count_new,LabelOld);
    print('updated the new count, but please change labels');
  }

  void forceNodeUpdate(){
    myDAG.updateNode(SelectedNode);
  }

}