import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'data_converter.dart';


@Component(
    selector: 'node-adder',
    templateUrl: 'node_adder_component.html',
    directives: const [materialDirectives],
    providers: const [materialProviders]
)
//TODO: give live feedback on validity of parents/daughter names
class NodeAdderComponent implements OnInit {

  List<String> ParentsToLink = new List<String>();
  List<String> DaughtersToLink = new List<String>();
  String NodeName;
  bool Visible;
  int NodeCount=2; //default amount of states = 2



  NodeAdderComponent(){

  }

  void ngOnInit(){
    ParentsToLink.add("");
    DaughtersToLink.add("");
  }

  void setNodeName(dynamic event){
    NodeName=event.target.value;
  }
  void setParentValue(int index,dynamic event){
    ParentsToLink[index]=event.target.value;
  }

  void setDaughterValue(int index,dynamic event){
    DaughtersToLink[index]=event.target.value;

  }

  void setStateCount(dynamic event){
    NodeCount=int.parse(event.target.value);
  }

  void increaseParents(){
    ParentsToLink.add('');
  }

  void increaseDaughters(){
    DaughtersToLink.add('');
  }

  makeVisible(){
    Visible=true;
  }

  close(){
    Visible=false;
  }

  //TODO: prevent issues with empty string

  //currently doesnt check for empty strings. This causes some errors but does
  //not fatally break anything.
  pushNodeLegacy(){
    if(NodeName!=null){
      List MainList = new List(3);
      List NodeList = new List(2);
      NodeList[0]=NodeName;
      NodeList[1]=NodeCount;
      MainList[0]=NodeList;
      MainList[1]=ParentsToLink;
      MainList[2]=DaughtersToLink;
      Implement(MainList);
      close();
    }
    else{
      print('you have not entered a valid option');
    }
  }

}