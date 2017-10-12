// These are the most fundamental components of our course platform
import 'package:angular_components/angular_components.dart'; //for uiDisplay
import 'notification_service.dart'; //to handle NetNotifications


class Lesson implements HasUIDisplayName{

  final String name;
  final String dateCreated;
  String description;
  String markdownPath;  //holds the path to the .md file that holds the
                        //information and text for this lesson
  int CourseIndex;

  List<NetNotification> goalList;
  List<bool> goalProgressList;

  Lesson(this.name,this.dateCreated);

  // Getters

  String get lessonName => name;

  int get goalCount => goalList.length;

  List<bool> get goalProgress => goalProgressList;

  set lessonDescription(String newDescription){
    description = newDescription;}

  String get lessonDescription => description;

  String get lessonMarkdownPath => markdownPath;

  List<NetNotification> get goals => goalList;

  // Setters

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