import 'package:angular2/core.dart';
import 'package:angular2/common.dart';

import 'package:angular_components/angular_components.dart';
import 'package:angular2/router.dart';

import 'node.dart';
import 'vector_math.dart';
import 'package:causecade/app_component.dart';
import 'notification_service.dart';

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
  NotificationService notifications;

   node SelectedNode;
  bool ShouldBeHidden;
  bool showMatrixEditor;
  int StateCount;

  Vector Observation; //these will be used
  Vector Prior;

  List<node> NodeList;

  Matrix2 LinkMatrix;
  List<List<double>> MatrixValues;

  int state_count_new;
  static List<int> AllowedStateCounts = [2,3,4]; //TODO make this a global variable

  List ObservationList;
  List PriorList;
  List<double> Probability = new List<double>();
  List<String> LabelNew;
  List<String> LabelOld;
  List<String> MatrixValueLabels;

  List<node> newLinkParent;
  List<node> newLinkDaughter;

  //holds information about the selected node


  //holds information about the selected node
  List IncomingNodes;

  //holds information about the selected node
  List OutGoingNodes;

  List LinkList  = new List(); //holds links associated with this node

  //holds information about the selected node

  EditComponent(this._routeParams,this.notifications);

  //TODO Remove
  String TestString;
  testTestString(double In){
    TestString=In.toString();
  }

  void ngOnInit() {
    showMatrixEditor = false;
    if(_routeParams.get('id')!=null) {
      setupCard();
    }
    else{
      //else, we should hide this component
      ShouldBeHidden=true;
    }
    NodeList=myDAG.NodeList;
    newLinkDaughter = new List<node>();
    newLinkParent = new List<node>();
  }

  /*void setNewLinkParent(dynamic event){newLinkParent=event.target.value;}*/ //TODO remove
 /* void setNewLinkDaughter(dynamic event){newLinkDaughter=event.target.value;} *///TODO remove

  void addNewParentLink(){
    if((newLinkParent!=null)) {
      newLinkParent.forEach((node){
        myDAG.insertLink(node,SelectedNode);
      });
      fetchLinks();
      parentLinkSelection.clear();
      notifications.addNotification(new NetNotification()..setUpdateNodeLinks());
    }
    else{
      print('DetailComponent: no node selected, no link formed.');
    }
  }

  void addNewDaughterLink(){
    if((newLinkDaughter!=null)) {
      newLinkDaughter.forEach((node){
        myDAG.insertLink(SelectedNode,node);
      });
      fetchLinks();
      daughterLinkSelection.clear();
      notifications.addNotification(new NetNotification()..setUpdateNodeLinks());
    }
    else{
      print('DetailComponent: no node selected, no link formed.');
    }
  }

  removeLink(LinkIn){
    myDAG.removeEdge(LinkIn);
    notifications.addNotification(new NetNotification()..setRemoveNodeLinks());
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
    print(LabelOld.toString());
    print(LabelNew.toString());
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
    notifications.addNotification(new NetNotification()..setNodePrior());
  }

  void clearPrior(){
    SelectedNode.clearPiEvidence();
    SelectedNode.setRootStatus(false);
    notifications.addNotification(new NetNotification()..clearNodPrior());
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
    notifications.addNotification(new NetNotification()..setNodeEvidence());
    //node will now have Instantiated=true;
  }

  void clearObservation(){
    print('Cleared Observation.');
    SelectedNode.clearProbability();
    notifications.addNotification(new NetNotification()..clearNodeEvidence());
  }


  void setMatrixValue(int i, int j, dynamic event){
    LinkMatrix[i][j]=double.parse(event.target.value);
  }

  void setNewLabel(int index, dynamic event){
    LabelNew[index] = event.target.value;
  }

  void pushNewLabels(){
    SelectedNode.setStateLabels(LabelNew);
    print('EditComponent: pushed labels to node');
    notifications.addNotification(new NetNotification()..setUpdateNodeLabels());
  }
  void pushNewMatrix(){
    SelectedNode.enterLinkMatrix(LinkMatrix); //sets the (possibly changed)
    LinkMatrix=SelectedNode.getLinkMatrix();
    SelectedNode.clearFlaggingNode();
    SelectedNode.FlagOtherNodes();
    fetchMatrixValues(); //we want to have the matrid values reflect the new matrix
    showMatrixEditor = false;
    //matrix. If no changes are made in the ui this wont change anything.
    notifications.addNotification(new NetNotification()..setNodeMatrix());

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

 /* refreshOldLabels(){ //when statecount changes we must change the old labels
    List<String> refreshedLabels = new List<String>(StateCount);
    for(int i=0;i<StateCount;i++){
      if(i<LabelOld[i].length-1) {
        refreshedLabels[i] = LabelOld[i];
      }
      else{
        refreshedLabels[i] = 'not yet defined';
      }
    }
    LabelOld=refreshedLabels;
    print('EditComponent: refreshed labels');
  }*/

  void printNetworkToConsole(){
    print(myDAG.toString());
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
    StateCount=state_count_new;
    fetchOldLabels();
    pushNewLabels();
    print('updated the new count, but please change labels');
    notifications.addNotification(new NetNotification()..setNodeMultiplicity());
  }

  void forceNodeUpdate(){
    myDAG.updateNode(SelectedNode);
  }

  // Dropdown (renderer)

  static final ItemRenderer<node> NodeRenderer =
      (HasUIDisplayName node) => node.uiDisplayName;

  // Dropdowns (parent Link)

  final SelectionModel<node> parentLinkSelection =
  new SelectionModel.withList(allowMulti: true);

  StringSelectionOptions<node> get parentLinkOptions
  => new StringSelectionOptions<node>(NodeList);

  String get parentLinkSelectionLabel {
    var selectedValuesParent = parentLinkSelection.selectedValues;
    if (selectedValuesParent.isEmpty) {
      newLinkParent.clear();
      return "None Selected";
    } else if (selectedValuesParent.length == 1) {
      newLinkParent=parentLinkSelection.selectedValues;
      return NodeRenderer(selectedValuesParent.first);
    } else {
      newLinkParent=parentLinkSelection.selectedValues;
      return "${NodeRenderer(selectedValuesParent.first)} + ${selectedValuesParent
          .length - 1} more";
    }
  }

  // Dropdowns (daughter Link)

  final SelectionModel<node> daughterLinkSelection =
  new SelectionModel.withList(allowMulti: true);

  StringSelectionOptions<node> get daughterLinkOptions
  => new StringSelectionOptions<node>(NodeList);

  String get daughterLinkSelectionLabel {
    var selectedValuesParent = daughterLinkSelection.selectedValues;
    if (selectedValuesParent.isEmpty) {
      newLinkDaughter.clear();
      return "None Selected";
    } else if (selectedValuesParent.length == 1) {
      newLinkDaughter=selectedValuesParent;
      return NodeRenderer(selectedValuesParent.first);
    } else {
      newLinkDaughter=selectedValuesParent;
      return "${NodeRenderer(selectedValuesParent.first)} + ${selectedValuesParent
          .length - 1} more";
    }
  }

  // Dropdown (Node Multiplicity)

  final SelectionModel<int> nodeMultiplicitySelection =
  new SelectionModel.withList();

  final SelectionOptions<int> nodeMultiplicityOptions =
  new SelectionOptions<int>.fromList(AllowedStateCounts);

  String get nodeMultiplicityLabel {
    if(nodeMultiplicitySelection.selectedValues.isNotEmpty){
      state_count_new=nodeMultiplicitySelection.selectedValues.first;
      return nodeMultiplicitySelection.selectedValues.first.toString();
    }
    else{
      state_count_new=StateCount;//default
      return StateCount.toString();
    }
  }
}