import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'notification_service.dart';
import 'teach_service.dart';
import 'app_component.dart';

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
  @Output() EventEmitter isVisibleChange = new EventEmitter();

  bool inSubMenu;
  String searchString;
  int networkCount;
  List networkList;

  NotificationService notifications;
  TeachService teachService;

  LoadComponent(this.notifications, this.teachService);

  //when the ''LOAD'' button is clicked
  void loadData(String exampleName) {
    //This function will get improved functionality in the future
    switch (exampleName) {
      case "Animals":
        LoadExample_Animals();
        //loadMessage = 'Last Loaded: ' + example_name;
        closeLoadMenu();
        //refreshNetName();
        notifications.addNotification(new NetNotification()..setLoadStatus('Animals'));
        break;
      case "CarTest":
        LoadExample_CarStart();
        //loadMessage = 'Last Loaded: ' + example_name;
        closeLoadMenu();
        //refreshNetName();
        notifications.addNotification(new NetNotification()..setLoadStatus("CarTest"));
        break;
      case "Bayes_1_2_3":
        LoadExample_Lesson_Bayes_1_2_3();
        //loadMessage = 'Last Loaded: ' + example_name;
        closeLoadMenu();
        //refreshNetName();
        notifications.addNotification(new NetNotification()..setLoadStatus("Bayes_1_2_3"));
        break;
      case "Bayes_1_2_3_semantic":
        LoadExample_Lesson_Bayes_1_2_3_semantic();
        //loadMessage = 'Last Loaded: ' + example_name;
        closeLoadMenu();
        //refreshNetName();
        notifications.addNotification(new NetNotification()..setLoadStatus("Bayes_1_2_3_semantic"));
        break;
      case "Bayes_4":
        LoadExample_Lesson_Bayes_4();
        //loadMessage = 'Last Loaded: ' + example_name;
        closeLoadMenu();
        //refreshNetName();
        notifications.addNotification(new NetNotification()..setLoadStatus("Bayes_4"));
        break;
      case "Bayes_4_semantic":
        LoadExample_Lesson_Bayes_4_semantic();
        //loadMessage = 'Last Loaded: ' + example_name;
        closeLoadMenu();
        //refreshNetName();
        notifications.addNotification(new NetNotification()..setLoadStatus("Bayes_4_Semantic"));
        break;
      default:
        //loadMessage = 'Sorry This is node a valid network';
        closeLoadMenu();
    }
  }

  void JSONload(String URI){
    htmlDart.HttpRequest.getString(URI).then((myjson) {
      //print(myjson);
      var dson = new Dartson.JSON();
      myDAG = dson.decode(myjson, new BayesianDAG());
      //complete loading/setup of network
      myDAG.setupLoadedNetwork();
      visualiseNetwork(); //ensure the new network is loaded
      closeLoadMenu();
      notifications.addNotification(new NetNotification()..setLoadStatus(myDAG.name));
    });
  }

  void viewCourseNetworks(String courseName){
    inSubMenu=true; //enter submenu, hide overview of courses
    searchString=
        'https://raw.githubusercontent.com/CauseCade/CauseCade-networks/master/'
            + courseName + '_'; //ex: ./bayes_4

    //recursively check if url is valid and update list to display items
    determineNetworkCount(1);
   }

  void determineNetworkCount(int startingIndex){
    //print(searchString+startingIndex.toString()+'.json');
    htmlDart.HttpRequest.getString(searchString+startingIndex.toString()+'.json')
        .then((myjson) {
      //we found valid URL, check next one
      determineNetworkCount(startingIndex+1);
    })
        .catchError((Error error) {
      //404 error -> no more valid file
      networkCount=(startingIndex-1);
      networkList = new List(networkCount);
    });
  }

  void closeLoadMenu(){
    inSubMenu=false; //exit submenu
    isVisible=false;
    isVisibleChange.emit(false); //let appcomponent know we closed it
  }
}