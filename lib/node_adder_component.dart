import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'app_component.dart';

import 'package:angular2_components/angular2_components.dart';
import 'data_converter.dart';
import 'node.dart';
@Component(
    selector: 'node-adder',
    templateUrl: 'node_adder_component.html',
    directives: const [materialDirectives],
    providers: const [materialProviders]
)
//TODO: give live feedback on validity of parents/daughter names
class NodeAdderComponent implements OnInit {

  List<node> NodeList = new List<node>();

  Set<String> ParentsToLink = new Set<String>();
  //List<String> ParentsCounter = new List<String>();

  Set<String> DaughtersToLink = new Set<String>();
  String NodeName;
  bool Visible;
  String NodeCount ='2'; //default amount of states = 2

  List<String> AllowedStates = ['2','3','4'];


  NodeAdderComponent();

  void ngOnInit(){
    NodeList = myDAG.getNodes();
    print(NodeList.length.toString());
    print('Ready To add Nodes');
  }

  void setNodeName(dynamic event){
    NodeName=event.target.value;
  }
 /* void setParentValue(int index,dynamic event){
    ParentsToLink[index]=event.target.value;
  }*/

/*
  void setDaughterValue(int index,dynamic event){
    DaughtersToLink[index]=event.target.value;

  }
*/

/*  void setStateCount(dynamic event){
    NodeCount=int.parse(event.target.value);
  }*/

/*  void increaseParents(){
    ParentsCounter.add('Parent' + ParentsCounter.length.toString());
    print(ParentsCounter.last.toString());
  }*/

  void addDaughter(String NodeIn){
    DaughtersToLink.add(NodeIn);
  }

  void addParent(String NodeIn){
    ParentsToLink.add(NodeIn);
  }
  void makeVisible(){
    if(!Visible){
      /*increaseParents();*/
      /*increaseDaughters();*/
    }
    Visible=true;
  }

  close(){
    Visible=false;
  }

  prepareLists(){
      ParentsToLink.remove('');
      DaughtersToLink.remove('');
  }

  //TODO: move form to ngModel implementation
  pushNodeLegacy(){
    if(NodeName!=null){
      print(NodeCount);
      List MainList = new List(3);
      List NodeList = new List(2);
      NodeList[0]=NodeName;
      NodeList[1]=NodeCount;
      MainList[0]=NodeList;
      prepareLists();
      MainList[1]=ParentsToLink.toList();
      MainList[2]=DaughtersToLink.toList();

      Implement(MainList);
      reset();
      close();
    }
    else{
      print('you have not entered a valid option');
    }
  }
  void reset(){
    NodeName=null;
    ParentsToLink.clear();
    DaughtersToLink.clear();
    NodeCount=2; //reset the default NodeCount;
  }

  void onSubmit() {
   print('pressed submit!');
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
}