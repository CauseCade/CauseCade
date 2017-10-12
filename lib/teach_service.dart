import 'package:angular2/core.dart';


import 'course.dart';
import 'lesson.dart';
import 'lesson_data.dart';

@Injectable()

class TeachService{

  Lesson SelectedLesson;
  bool hasLessonSelected = true;

  String tester='>';

 List<Course> getCourses()  => courseData ;

  //get a specific lesson (user enters the course name and lesson name)
  Lesson getLesson(String courseName,String lessonName)  =>
      ((getCourses()).firstWhere((course) => course.courseName == courseName)
      .courseLessons.firstWhere((lesson)=>lesson.lessonName == lessonName));

  //Get a list of the lesson names
  List<String> getCourseLessonNames(String courseName)=>
      (getCourses()).firstWhere((course) => course.courseName == courseName)
      .getLessonNames();

  void clearCurrentLesson(){
    SelectedLesson = null;
    //hasLessonSelected = false;
    //print('Cleared Current Lesson Selection...');
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

  bool getSelectionStatus(){
    return hasLessonSelected;
  }

  void setGoalProgress(int indexOfGoal){
    currentLesson.setGoalProgress(indexOfGoal); //set goal as achieved (in lesson Object)
    print('[teachService] set goal progress');
  }

  void selectTutorial(){
    SelectedLesson = courseData[0].courseLessons[0];
  }
}