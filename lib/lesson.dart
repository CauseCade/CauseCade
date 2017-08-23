// These are the most fundamental components of our course platform
import 'package:angular_components/angular_components.dart'; //for uiDisplay


class Lesson implements HasUIDisplayName{

  final String name;
  final String dateCreated;
  String description;
  String markdownPath;  //holds the path to the .md file that holds the
                        //information and text for this lesson
  int CourseIndex;

  List<String> goalList;

  Lesson(this.name,this.dateCreated);

  String get lessonName => name;

  set lessonDescription(String newDescription){
    description = newDescription;}

  String get lessonDescription => description;

  set lessonMarkdownPath(String newPath){
    markdownPath = newPath;}

  String get lessonMarkdownPath => markdownPath;

  set goals(List<String> newGoalList) => goalList=newGoalList;

  List<String> get goals => goalList;

  void addGoal(String newGoal){
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