import 'package:angular2/core.dart';
import 'package:angular2/common.dart'; //TODO remove?
import 'app_component.dart';

import 'package:angular_components/angular_components.dart';
import 'data_converter.dart';
import 'node.dart';
import 'dart:html';
import 'package:causecade/notification_service.dart';
@Component(
    selector: 'node-adder',
    templateUrl: 'node_adder_component.html',
    directives: const [materialDirectives],
    providers: const [materialProviders]
)
//TODO: give live feedback on validity of parents/daughter names
class NodeAdderComponent implements OnInit {

  NotificationService notifications;

  List<node> NodeList = new List<node>();

  Set<node> ParentsToLink = new Set<node>();
  //List<String> ParentsCounter = new List<String>();

  Set<node> DaughtersToLink = new Set<node>();
  String NodeName;
  bool Visible;
  int NodeCount; //default amount of states = 2

  static List<int> AllowedStates = [2,3,4]; //Limited to 4 for now

  NodeAdderComponent(this.notifications); //Constructor

  setName(dynamic event){
    if(event.target.value!=null){
     NodeName=event.target.value;
    }
  }

  void ngOnInit(){
    NodeList = myDAG.getNodes();
    print('Ready To add Nodes');
  }

  void makeVisible(){
    Visible=true;
  }

  void close(){
    resetSelections();
    Visible=false;
  }

  void pushNodeLegacy(){
    if(NodeName!=null){
      print('Pushing User Input...'); //debugging

      List MainList = new List(3);
      List NodeList = new List(2);
      NodeList[0]=NodeName;
      NodeList[1]=NodeCount;
      MainList[0]=NodeList;
      /*prepareLists();*/
      MainList[1]=ParentsToLink.toList();
      MainList[2]=DaughtersToLink.toList();

      print('Sending off to data converter...'); //debugging
      notifications.addNotification(new NetNotification()..setNewNode());
      Implement(MainList);
      resetSelections();
      close();
    }
    else{
      print('you have not entered a valid option');
    }
  }

  // Dropdown (Node Multiplicity)

  final SelectionModel<int> nodeMultiplicitySelection =
    new SelectionModel.withList();

  final SelectionOptions<int> nodeMultiplicityOptions =
    new SelectionOptions<int>.fromList(AllowedStates);

  String get nodeMultiplicityLabel {
    if(nodeMultiplicitySelection.selectedValues.isNotEmpty){
      NodeCount=nodeMultiplicitySelection.selectedValues.first;
      return nodeMultiplicitySelection.selectedValues.first.toString();
    }
    else{
      NodeCount=2;//default
      return '2';
    }
  }
    // Dropdown (renderer)

    static final ItemRenderer<node> NodeRenderer =
        (HasUIDisplayName node) => node.uiDisplayName;

    // Dropdowns (parent Node)

  final SelectionModel<node> parentNodeSelection =
  new SelectionModel.withList(allowMulti: true);

  StringSelectionOptions<node> get parentNodeOptions
  => new StringSelectionOptions<node>(NodeList);

  String get parentNodeSelectionLabel {
    var selectedValuesParent = parentNodeSelection.selectedValues;
    if (selectedValuesParent.isEmpty) {
      ParentsToLink.clear();
      return "None Selected";
    } else if (selectedValuesParent.length == 1) {
      ParentsToLink=parentNodeSelection.selectedValues.toSet();
      return NodeRenderer(selectedValuesParent.first);
    } else {
      ParentsToLink=parentNodeSelection.selectedValues.toSet();
      return "${NodeRenderer(selectedValuesParent.first)} + ${selectedValuesParent
          .length - 1} more";
    }
  }

  // Dropdowns (Daughter Node)

  final SelectionModel<node> daughterNodeSelection =
  new SelectionModel.withList(allowMulti: true);

  StringSelectionOptions<node> get daughterNodeOptions => new StringSelectionOptions<node>(NodeList);

  String get daughterNodeSelectionLabel {
    var selectedValues = daughterNodeSelection.selectedValues;
    if (selectedValues.isEmpty) {
      DaughtersToLink.clear();
      return "None Selected";
    } else if (selectedValues.length == 1) {
      DaughtersToLink=daughterNodeSelection.selectedValues.toSet();
      return NodeRenderer(selectedValues.first);
    } else {
      DaughtersToLink=daughterNodeSelection.selectedValues.toSet();
      return "${NodeRenderer(selectedValues.first)} + ${selectedValues
          .length - 1} more";
    }
  }

  void resetSelections(){
    daughterNodeSelection.clear();
    parentNodeSelection.clear();
    nodeMultiplicitySelection.clear();
  }


}