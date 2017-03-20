import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';


@Component(
    selector: 'node-adder',
    templateUrl: 'node_adder_component.html',
    directives: const [materialDirectives],
    providers: const [materialProviders]
)
class NodeAdderComponent {

  List ParentsToLink = new List<String>();
  List<String> DaughtersToLink = new List<String>();
  String NodeName;

  NodeAdderComponent(){
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

  void increaseParents(){
    ParentsToLink.add('');
  }

  void increaseDaughters(){
    DaughtersToLink.add('');
  }

  //TODO: implement
  close(){

    }

  pushNodeLegacy(){
    if(NodeName!=null){

    }
  }

}