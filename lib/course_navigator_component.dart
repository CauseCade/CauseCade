//This Component will hold the navigation and progress information for the
// CauseCade course (educational) part

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:causecade/app_component.dart';
import 'package:causecade/course_lesson_component.dart';




@Component(
    selector: 'course-navigator',
    templateUrl: 'course_navigator_component.html',
    directives: const [materialDirectives, CourseLessonComponent],
    providers: const [materialProviders,AppComponent])
class CourseNavigatorComponent {

  bool isExpanded = false; //hide by default;
  int navigationRatio =15;  //What fraction of window should the navigation
                            //header be? (percentage)
  int navigationRatioComplement;

  CourseNavigatorComponent(){
    print('Course Navigator Component loaded...');
    navigationRatioComplement=100-navigationRatio;

  }

  void hideCourseMenu(){
    isExpanded=false;
    print('User Closed Course Navigator');
  }

  void openCourseMenu(){
    isExpanded=true;
    print('User Opened Course Navigator');
  }

}