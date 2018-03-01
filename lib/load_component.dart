import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'notification_service.dart';
import 'teach_service.dart';
import 'app_component.dart';
import 'course.dart';

//JSOn handling
import 'dart:html' as htmlDart;
import 'package:causecade/bayesian_dag.dart';
import  'data_converter.dart';

//access to the lesson data
import 'package:causecade/example_networks.dart';
import 'package:dartson/dartson.dart';


@Component(
    selector: 'load_menu',
    templateUrl: 'load_component.html',
    styleUrls: const ['load_component.css'],
    directives: const [materialDirectives],
    providers: const [materialProviders])
class LoadComponent {
  @Input()
  bool isVisible;
  @Output()
  EventEmitter loadEvent = new EventEmitter();
  @Output()
  EventEmitter isVisibleChange = new EventEmitter();

  bool inSubMenu;
  String searchString;
  int networkCount;
  List<String> networkList = new List();
  List<String> networkNameList = new List();

  NotificationService notifications;
  TeachService teachService;

  LoadComponent(this.notifications, this.teachService);

  void JSONload(String URL){
    htmlDart.HttpRequest.getString(URL).then((myjson) {
      //print(myjson);
      var dson = new Dartson.JSON();
      BayesianDAG newDag = dson.decode(myjson, new BayesianDAG());
      myDAG = newDag;
      //complete loading/setup of network
      myDAG.setupLoadedNetwork();
      visualiseNetwork(); //ensure the new network is loaded
      closeLoadMenu();
      loadEvent.emit(true);
      notifications.addNotification(new NetNotification()..setLoadStatus(myDAG.name));
    });
  }

  void localJSONload(htmlDart.Event e){
    //load file
    List fileInput = htmlDart.document.querySelector('#localnetworkinput').files;

    if (fileInput.length > 1) {
      // catch odd events
      print('Multiple files detected...');
    }
    else if (fileInput.isEmpty) {
      // catch odd events
      print('Empty file list detected...');
    }

    htmlDart.FileReader reader = new htmlDart.FileReader();
    reader.onLoad.listen((fileEvent) {
      String myjson = reader.result;
      // Code doing stuff with fileContent goes here!
      //decoding JSON
      var dson = new Dartson.JSON();
      BayesianDAG newDag = dson.decode(myjson, new BayesianDAG());
      myDAG = newDag;
      //complete loading/setup of network
      myDAG.setupLoadedNetwork();
      visualiseNetwork(); //ensure the new network is loaded
      closeLoadMenu();
      loadEvent.emit(true);
      notifications.addNotification(new NetNotification()..setLoadStatus(myDAG.name));

    });
    reader.readAsText(fileInput[0]);
  }

  void viewCourseNetworks(Course selectedCourse){
    inSubMenu=true; //enter submenu, hide overview of courses
    if(selectedCourse.getNetworkUrlList()!=null) { //ensuring we keep at least an empty list
           networkList = selectedCourse.getNetworkUrlList();
    }
    //so we can get a preview of the network names;
    //we first check if everythiung matches (fail safe)
    if(selectedCourse.networkNameList==null) {
      //no proper network names provided, use placeholders
      //print('null labels');
      for(int i=0;i<networkList.length;i++){
        networkNameList.add("unnamed network");
      }
    }
    //may be initialised, but have insufficient labels
    //in that case we just replace all the labesl with our fallback
    else if (selectedCourse.networkNameList.length!=networkList.length){
      //print('poor labels');
      for(int i=0;i<networkList.length;i++){
        networkNameList.add("unnamed network");
      }
    }
    else {
      //print('proper labels');
      networkNameList = selectedCourse.courseNetworkNameList;
    }
 }

  void closeLoadMenu(){
    inSubMenu=false; //exit submenu
    networkNameList = new List<String>();
    networkList = new List<String>(); //not strictly needed, but good practice
    isVisible=false;
    isVisibleChange.emit(false); //let appcomponent know we closed it
  }
}