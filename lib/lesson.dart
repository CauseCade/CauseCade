// These are the most fundamental components of our course platform
import 'package:angular_components/angular_components.dart'; //for uiDisplay


class Lesson implements HasUIDisplayName{

  final String name;
  final String dateCreated;
  String description;
  String markdownPath;  //holds the path to the .md file that holds the
                        //information and text for this lesson
  int CourseIndex;

  Lesson(this.name,this.dateCreated);

  String get lessonName => name;

  set lessonDescription(String newDescription){
    description = newDescription;}

  String get lessonDescription => description;

  set lessonMarkdownPath(String newPath){
    markdownPath = newPath;}

  String get lessonMarkdownPath => markdownPath;

  @override
  String get uiDisplayName => name; //just return the name

  @override
  String toString() => uiDisplayName;
}