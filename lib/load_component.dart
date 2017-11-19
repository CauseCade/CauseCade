import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'notification_service.dart';

//access to the lesson data
import 'package:causecade/example_networks.dart';

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

  NotificationService notifications;

  LoadComponent(this.notifications);

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

  void closeLoadMenu(){
    isVisible=false;
    isVisibleChange.emit(false); //let appcomponent know we closed it
  }
}