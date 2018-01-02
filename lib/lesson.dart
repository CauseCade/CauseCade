// These are the most fundamental components of our course platform
import 'package:angular_components/angular_components.dart'; //for uiDisplay
import 'notification_service.dart'; //to handle NetNotifications
import 'package:dartson/dartson.dart'; //to convert to JSON

@Entity()
class Lesson implements HasUIDisplayName{

  String name;
  String dateCreated;
  String dateUpdated;
  String description;
  @Property(name:"lessonURL")
  String markdownPath;  //holds the path (URL) to the .md file that holds the
                        //information and text for this lesson
  List<int> lessonNetworkIndices; //which network listed in the course object
                          //are part of this lesson (allows for quick opening)

  //TODO: implement this from JSON
  @Property(ignore:true) //not yet implemented
  List<NetNotification> goalList;
  @Property(ignore:true) //only used at runtime
  List<bool> goalProgressList;

  Lesson();

  void initialiseLesson(String nameIn, String dateIn){
    this.name=nameIn;
    this.dateCreated=dateIn;
  }

  // Getters

  String get lessonName => name;

  int get goalCount => goalList.length;

  List<bool> get goalProgress => goalProgressList;

  List<int> get networkIndices => lessonNetworkIndices;

  String get lessonDescription => description;

  String get lessonMarkdownPath => markdownPath;

  List<NetNotification> get goals => goalList;

  // Setters

  set lessonDescription(String newDescription){
    description = newDescription;}

  set lessonMarkdownPath(String newPath){
    markdownPath = newPath;}

  set goals(List<NetNotification> newGoalList){
    goalList=newGoalList;
    goalProgressList=new List(newGoalList.length);
  }

  // Functions

  void setGoalProgress(int goalIndex) => goalProgressList[goalIndex]=true;

  void addGoal(NetNotification newGoal){ //will break preset goalProgress list. TODO: fix
    goalList.add(newGoal);
    print('added goal to lesson: ' + name);
  }

  void clearGoals(){
    goalList.clear();
    print('cleared goals of lesson: ' + name);
  }

  @override
  String get uiDisplayName => name; //just return the name

  @override
  String toString() => uiDisplayName;
}