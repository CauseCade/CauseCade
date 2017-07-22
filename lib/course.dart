// A course is a collection of Lessons, with a short description and version
import 'package:causecade/lesson.dart';

class Course{

  final String name;
  final String dateCreated;
  List<Lesson> lessonList = new List<Lesson>();
  int lessonCount;
  String description;
  String category; //Serves as a tag for this (type of) course

  Course(this.name,this.dateCreated); /*constructor*/

  String get courseName => name;

  String get dateOfCreation => dateCreated;

  set courseDescription(String newDescription){
    description = newDescription;}

  String get courseDescription => description;

  set courseCategory(String newCategory){
    category = newCategory;}

  String get courseCategory => category;

  void addLesson(Lesson lessonIn){
    lessonList.add(lessonIn);
    print('Added '+lessonIn.lessonName +' to course: ' + name);
    _updateLessonCount();
  }

  void removeLesson(Lesson lessonIn){
    lessonList.remove(lessonIn);
    print('Removed '+lessonIn.lessonName +' from course: ' + name);
    _updateLessonCount();
  }

  //make a list of the names of each lesson and return that list
  List<String> getLessonNames(){
    List<String> listToSend = new List<String>();
    lessonList.forEach((lesson){
      listToSend.add(lesson.lessonName);
    });
    return listToSend;
  }

  void _updateLessonCount(){
    lessonCount = lessonList.length;
  }
}
