//This Component will hold the navigation and progress information for the
// CauseCade course (educational) part

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'course_navigator_component.dart';

@Component(
    selector: 'course-lesson',
    templateUrl: 'course_lesson_component.html',
    directives: const [materialDirectives],
    providers: const [materialProviders,CourseNavigatorComponent])
class CourseLessonComponent {

  bool lessonSelected = false; //hide by default;

  CourseLessonComponent(){
    print('Course Lesson Component loaded...');
  }
}