//This Component will hold the navigation and progress information for the
// CauseCade course (educational) part

import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:causecade/app_component.dart';
import 'package:causecade/course_lesson_component.dart';
import 'package:causecade/teach_service.dart';
import 'package:causecade/course.dart';
import 'package:causecade/lesson.dart';
import 'lesson_data.dart'; //FIX

@Component(
    selector: 'course-navigator',
    templateUrl: 'course_navigator_component.html',
    directives: const [materialDirectives, CourseLessonComponent],
    providers: const [materialProviders,AppComponent,TeachService])
class CourseNavigatorComponent {

  final TeachService _teachService;
  bool isExpanded = false; //hide by default;
  int navigationRatio =15;  //What fraction of window should the navigation
                            //header be? (percentage)
  int navigationRatioComplement;
  List<Course> CourseList;
  Course CourseSelect; //selected course
  List<Lesson> LessonList;

  //bool =true; //any lesson selected?

  CourseNavigatorComponent(this._teachService){/*this._teachService*/
    print('Course Navigator Component loaded...');
    navigationRatioComplement=100-navigationRatio;
    CourseList = _teachService.getCourses();
    configureCourses();
    print('Configured Courses');
  }

  void hideCourseMenu(){
    isExpanded=false;
    print('User Closed Course Navigator');
  }

  void openCourseMenu(){
    isExpanded=true;
    print('User Opened Course Navigator');
  }

  void selectCourse(Course courseIn){
    CourseSelect = courseIn; //set currently Selectd Course
    LessonList=CourseSelect.courseLessons; //find lessons (only) of this course
    //hasLessonSelected =false; //reset lesson selection status
  }

  void selectLesson(Lesson lessonIn){
    _teachService.currentLesson = lessonIn;
  }

  test_set(){ //fix
    _teachService.currentLesson = CourseList[0].courseLessons[0];
  }

  test_clear(){ //fix
    _teachService.clearCurrentLesson();
  }

}