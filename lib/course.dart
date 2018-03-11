// A course is a collection of Lessons, with a short description and version
import 'package:causecade/lesson.dart';
import 'package:angular_components/angular_components.dart'; //for uiDisplay
import 'package:dartson/dartson.dart'; //to convert to JSON


@Entity()
class Course implements HasUIDisplayName{

  String name;
  String dateCreated;
  List<Lesson> lessonList = new List<Lesson>();
  List<String> networkUrlList;
  List<String> networkNameList;
  String description;
  String category; //Serves as a tag for this (type of) course

  Course(); /*constructor*/

  void initialiseCourse(String nameIn, String dateIn){
    this.name=nameIn;
    this.dateCreated=dateIn;
  }

  String get courseName => name;

  String get dateOfCreation => dateCreated;

  List<String> get courseNetworkNameList => networkNameList;

  set courseDescription(String newDescription){
    description = newDescription;}

  String get courseDescription => description;

  set courseCategory(String newCategory){
    category = newCategory;}

  String get courseCategory => category;

  List<Lesson> get courseLessons => lessonList;

  List<String> getNetworkUrlList(){
    return networkUrlList;
  }

  void addLesson(Lesson lessonIn){
    lessonList.add(lessonIn);
    print('Added '+lessonIn.lessonName +' to course: ' + name);
  }

  void removeLesson(Lesson lessonIn){
    lessonList.remove(lessonIn);
    print('Removed '+lessonIn.lessonName +' from course: ' + name);
  }

  //make a list of the names of each lesson and return that list
  List<String> getLessonNames(){
    List<String> listToSend = new List<String>();
    lessonList.forEach((lesson){
      listToSend.add(lesson.lessonName);
    });
    return listToSend;
  }

  @override
  String get uiDisplayName => name; //just return the name

  @override
  String toString() => uiDisplayName;
}

@Entity()
class CourseHolder{
  @Property(name:"courselist")
  List<Course> courseListInternal=new List<Course>();

  set courseList(List<Course> newCourseList) => courseListInternal=newCourseList;

  List<Course> get courseList => courseListInternal;
}
