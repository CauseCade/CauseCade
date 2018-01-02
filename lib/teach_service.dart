import 'package:angular2/core.dart';


import 'course.dart';
import 'lesson.dart';
/*
import 'lesson_data.dart';
*/

//access to the course data
import 'dart:html' as htmlDart;
import 'package:dartson/dartson.dart';

@Injectable()

class TeachService{

  Lesson SelectedLesson;
  Course SelectedCourse;
  bool hasLessonSelected = true;
  CourseHolder courseDataRemote;
  String courseURL = 'https://raw.githubusercontent.com/CauseCade/CauseCade-lessons/master/meta.json';

  String tester='>';

 CourseHolder getCourses()  => courseDataRemote ;

  //fetch the course info from the server JSON file
  void fetchCourses(){
    htmlDart.HttpRequest.getString(courseURL).then((myjson) {
      //print(myjson);
      var dson = new Dartson.JSON();
      courseDataRemote = dson.decode(myjson, new CourseHolder());
      print('[teachservice]: loaded meta info...');
    });
  }

  //get a specific lesson (user enters the course name and lesson name)
  Lesson getLesson(String courseName,String lessonName)  =>
      ((getCourses().courseList).firstWhere((course) => course.courseName == courseName)
      .courseLessons.firstWhere((lesson)=>lesson.lessonName == lessonName));

  //Get a list of the lesson names
  List<String> getCourseLessonNames(String courseName)=>
      (getCourses().courseList).firstWhere((course) => course.courseName == courseName)
      .getLessonNames();

  void clearCurrentLesson(){
    SelectedLesson = null;
    //hasLessonSelected = false;
    //print('Cleared Current Lesson Selection...');
  }

  void clearCurrentCourse(){
    SelectedCourse=null;
  }

  set currentLesson(Lesson lessonIn){
    SelectedLesson = lessonIn;
    //hasLessonSelected =true;
    //print('Entered a Current Lesson Selection...');
    //tester=tester+'*';
    //print(tester  );
  }

  Lesson get currentLesson{
    return SelectedLesson;
  }

  set currentCourse(Course courseIn){
    SelectedCourse = courseIn;
  }

  Course get currentCourse => SelectedCourse;


  bool getSelectionStatus(){
    return hasLessonSelected;
  }

  void setGoalProgress(int indexOfGoal){
    currentLesson.setGoalProgress(indexOfGoal); //set goal as achieved (in lesson Object)
    print('[teachService] set goal progress');
  }

  void selectTutorial(){
    SelectedLesson = courseDataRemote.courseList[0].courseLessons[0];
  }
}