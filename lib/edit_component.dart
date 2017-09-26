import 'package:angular2/core.dart';
import 'package:angular2/common.dart';

import 'package:angular_components/angular_components.dart';
import 'network_selection_service.dart';

import 'node.dart';
import 'link.dart';
import 'vector_math.dart';
import 'package:causecade/app_component.dart';
import 'notification_service.dart';

import  'dart:html'; //to set height on linkmatrix
import 'dart:math';

@Component(
    selector: 'edit-node',
    templateUrl: 'edit_component.html',
    styleUrls: const ['edit_component.css'],
    styles: const ['''
                    main{
                      margin-left: 4em ;
                      margin-top: 45em ;
                    }
                   '''],
    directives: const [materialDirectives],
    providers: const [materialProviders])


class EditComponent implements OnInit, OnChanges {

  @Input()
  bool shouldBeLoaded;
  @Input()
  node selectedNode;

  NetworkSelectionService selectionService;
  NotificationService notifications;

   
  bool ShouldBeHidden;
  bool showMatrixEditor;
  int StateCount;

  Vector Observation; //these will be used
  Vector Prior;

  List<node> NodeList;

  Matrix2 LinkMatrix;
  List<List<double>> MatrixValues;

  static List<int> AllowedStateCounts = [2,3,4]; //TODO make this a global variable

  List ObservationList;
  List PriorList;
  List<double> Probability;
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

  EditComponent(this.selectionService,this.notifications);

  void ngOnInit() {
    print('[edit component initialised]');
    showMatrixEditor = false;
    NodeList=myDAG.NodeList;
    newLinkDaughter = new List<node>();
    newLinkParent = new List<node>();
  }

  /*void setNewLinkParent(dynamic event){newLinkParent=event.target.value;}*/ //TODO remove
 /* void setNewLinkDaughter(dynamic event){newLinkDaughter=event.target.value;} *///TODO remove

  void addNewParentLink(){
    newLinkParent=parentLinkSelection.selectedValues;
    if((newLinkParent.isNotEmpty)) {
      newLinkParent.forEach((node){
        myDAG.insertLink(node,selectedNode);
      });
      fetchLinks();
      parentLinkSelection.clear();
      daughterLinkSelection.clear(); //to prevent selected option in daughter window
      // to become disabled (not a huge problem,
      // but its good practice and prevents errors)
      notifications.addNotification(new NetNotification()..setUpdateNodeLinks());
    }
    else{
      print('DetailComponent: no node selected, no link formed.');
    }
  }

  void addNewDaughterLink(){
    newLinkDaughter=daughterLinkSelection.selectedValues;
    if((newLinkDaughter.isNotEmpty)) {
      newLinkDaughter.forEach((node){
        myDAG.insertLink(selectedNode,node);
      });
      fetchLinks();
      daughterLinkSelection.clear();
      parentLinkSelection.clear(); //to prevent selected option in parent window
      // to become disabled (not a huge problem,
      // but its good practice and prevents errors)
      notifications.addNotification(new NetNotification()..setUpdateNodeLinks());
    }
    else{
      print('DetailComponent: no node selected, no link formed.');
    }
  }

  void removeLink(LinkIn){
    myDAG.removeEdge(LinkIn);
    notifications.addNotification(new NetNotification()..setRemoveNodeLinks());
    fetchLinks();
  }

  void setupCard(){
    selectedNode = selectionService.selectedNode;
    IncomingNodes = selectedNode.getParents();
    OutGoingNodes = selectedNode.getDaughters();
    StateCount = selectedNode.getStateCount();
    LinkMatrix=selectedNode.getLinkMatrix();
    fetchOldLabels();
    fetchMatrixValues();

    LabelNew= new List<String>(StateCount);

   fetchLinks();

    ObservationList = new List(StateCount);
    Observation = new Vector(StateCount);
    PriorList = new List(StateCount);
    Prior = new Vector(StateCount);

    Probability = new List<double>();
    for(int i =0;i<selectedNode.getStateCount();i++){
      Probability.add(selectedNode.getProbability()[i]);
    }
    print('[edit]: refreshed data ');

  }

  void fetchOldLabels(){
    LabelOld = new List<String>(StateCount);
    LabelNew = new List<String>(StateCount);
    for(int i=0;i<StateCount;i++){
      LabelOld[i]='not yet defined';
      LabelNew[i]='not yet defined';
    }
    for(int i=0;i<selectedNode.getStateLabels().length;i++){
      LabelOld[i]=selectedNode.getStateLabels()[i];
      LabelNew[i]=selectedNode.getStateLabels()[i];
    }
    print(LabelOld.toString());
    print(LabelNew.toString());
  }

  //TODO: less duct-tape
  void fetchMatrixValues(){
    MatrixValueLabels=selectedNode.getMatrixLabels();
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
    selectedNode.getInComing().values.forEach((link){
      LinkList.add(link);
    });
    selectedNode.getOutGoing().values.forEach((link){
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
    selectedNode.setPiEvidence(Prior); //Sets the prior.
    selectedNode.setRootStatus(true);
    //node will now have isRootNode=true;
    notifications.addNotification(new NetNotification()..setNodePrior());
  }

  void clearPrior(){
    selectedNode.clearPiEvidence();
    selectedNode.setRootStatus(false);
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
    selectedNode.setProbability(Observation); //sets observation
    notifications.addNotification(new NetNotification()..setNodeEvidence());
    //node will now have Instantiated=true;
  }

  void clearObservation(){
    print('Cleared Observation.');
    selectedNode.clearProbability();
    notifications.addNotification(new NetNotification()..clearNodeEvidence());
  }


  void setMatrixValue(int i, int j, dynamic event){
    LinkMatrix[i][j]=double.parse(event.target.value);
  }

/*  void setNewLabel(int index, dynamic event){
    LabelNew[index] = event.target.value;
  }*/

  void pushNewLabels(){
    selectedNode.setStateLabels(LabelNew);
    print('EditComponent: pushed labels to node');
    notifications.addNotification(new NetNotification()..setUpdateNodeLabels());
  }
  void pushNewMatrix(){
    selectedNode.enterLinkMatrix(LinkMatrix); //sets the (possibly changed)
    LinkMatrix=selectedNode.getLinkMatrix();
    selectedNode.clearFlaggingNode();
    selectedNode.FlagOtherNodes();
    fetchMatrixValues(); //we want to have the matrid values reflect the new matrix
    showMatrixEditor = false;
    //matrix. If no changes are made in the ui this wont change anything.
    notifications.addNotification(new NetNotification()..setNodeMatrix());

  }

  updateMatrixLabels(){
    print(selectedNode.getInComing().keys.length);
    selectedNode.clearMatrixLabels();
    selectedNode.generateMatrixLabels(0,selectedNode.getInComing().keys.length,'');
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

  //toDO (remove?)
  /// Returns a map of CSS class names representing the state of [control].
  Map<String, bool> controlStateClasses(NgControl control) => {
    'ng-dirty': control.dirty ?? false,
    'ng-pristine': control.pristine ?? false,
    'ng-touched': control.touched ?? false,
    'ng-untouched': control.untouched ?? false,
    'ng-valid': control.valid ?? false,
    'ng-invalid': control.valid == false
  };

  void setNewStateCount(){
    StateCount=nodeMultiplicitySelection.selectedValues.first;
    nodeMultiplicitySelection.clear(); //clear selection
    selectedNode.setStateCount(StateCount,LabelOld);
    fetchOldLabels();
    pushNewLabels();
    print('updated the new count, but please change labels');
    notifications.addNotification(new NetNotification()..setNodeMultiplicity());
  }

  void forceNodeUpdate(){
    myDAG.updateNode(selectedNode);
  }

  void openMatrixEditor(){
    showMatrixEditor=true;
    print('opened matrixeditor');
    //prepare the window
    double constant = 4.0; //TODO make this more robust, now just trial and error
    double newheight=min((querySelector('.linkMatrixLabelHolder').text.length*1.41*constant)+20,1000.0);
    print(newheight.toString()+'is the height');
    querySelectorAll('.linkMatrixLabelTop').style.height=(newheight.toString()+'px');
  }

  //this function will be called if any of the @inputs change
  void ngOnChanges(SimpleChange){
    //print(SimpleChange);
    if(selectionService.selectedNode!=null){
      setupCard();
    }
  }

  // Dropdown (renderer)

  static final ItemRenderer<node> NodeRenderer =
      (HasUIDisplayName node) => node.uiDisplayName;

  //for both parents and daughter nodes
  NewEditLinkSelectionOptions get LinkOptions
  => new NewEditLinkSelectionOptions<node>(NodeList,selectedNode);

  // Dropdowns (parent Link)

  final SelectionModel<node> parentLinkSelection =
  new SelectionModel.withList(allowMulti: true);

  String get parentLinkSelectionLabel {
    var selectedValuesParent = parentLinkSelection.selectedValues;
    if (selectedValuesParent.isEmpty) {
      /*newLinkParent.clear();*/
      return "None Selected";
    } else if (selectedValuesParent.length == 1) {
      /*newLinkParent=parentLinkSelection.selectedValues;*/
      return NodeRenderer(selectedValuesParent.first);
    } else {
      /*newLinkParent=parentLinkSelection.selectedValues;*/
      return "${NodeRenderer(selectedValuesParent.first)} + ${selectedValuesParent
          .length - 1} more";
    }
  }

  // Dropdowns (daughter Link)

  final SelectionModel<node> daughterLinkSelection =
  new SelectionModel.withList(allowMulti: true);

  String get daughterLinkSelectionLabel {
    var selectedValuesParent = daughterLinkSelection.selectedValues;
    if (selectedValuesParent.isEmpty) {
      /*newLinkDaughter.clear();*/
      return "None Selected";
    } else if (selectedValuesParent.length == 1) {
      /*newLinkDaughter=selectedValuesParent;*/
      return NodeRenderer(selectedValuesParent.first);
    } else {
      /*newLinkDaughter=selectedValuesParent;*/
      return "${NodeRenderer(selectedValuesParent.first)} + ${selectedValuesParent
          .length - 1} more";
    }
  }

  // Dropdown (Node Multiplicity)

  final SelectionModel<int> nodeMultiplicitySelection =
  new SelectionModel.withList();

  NewEditStateSelectionOptions<int> get nodeMultiplicityOptions
  => new NewEditStateSelectionOptions<int>(AllowedStateCounts,StateCount);

  String get nodeMultiplicityLabel {
    if(nodeMultiplicitySelection.selectedValues.isNotEmpty){
        return nodeMultiplicitySelection.selectedValues.first.toString();
    }
    else{
      return 'None selected';
    }
  }
}


//so we can disable nodes (that are selected in other parent)
//prevents users from selecting the same node as a parent AND a daughter
//NOTE: slightly different to the one in node adder component
class NewEditLinkSelectionOptions<T> extends StringSelectionOptions<T>
    implements Selectable {

    node currentNode;

  NewEditLinkSelectionOptions(List<T> options,this.currentNode)
      : super(options, toFilterableString: (T option) => option.toString());

  NewEditLinkSelectionOptions.withOptionGroups(List<OptionGroup> optionGroups,this.currentNode)
      : super.withOptionGroups(optionGroups,
      toFilterableString: (T option) => option.toString());

  @override
  SelectableOption getSelectable(item) =>

      item is node && (currentNode.getOutGoing().keys.contains(item) || currentNode.getInComing().keys.contains(item) || item==currentNode) //is this node contained in the list of the other selector?
          ? SelectableOption.Disabled
          : SelectableOption.Selectable;
}

//prevents user from setting the number of states that the node already has
class NewEditStateSelectionOptions<T> extends StringSelectionOptions<T>
    implements Selectable {

  int currentStateCount;

  NewEditStateSelectionOptions(List<T> options,this.currentStateCount)
      : super(options, toFilterableString: (T option) => option.toString());

  NewEditStateSelectionOptions.withOptionGroups(List<OptionGroup> optionGroups,this.currentStateCount)
      : super.withOptionGroups(optionGroups,
      toFilterableString: (T option) => option.toString());

  @override
  SelectableOption getSelectable(item) =>

      item is int && (item==currentStateCount) //is this node contained in the list of the other selector?
          ? SelectableOption.Disabled
          : SelectableOption.Selectable;
}