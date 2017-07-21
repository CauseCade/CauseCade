//This Component will hold the navigation and progress information for the
// CauseCade course (educational) part

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'app_component.dart';

@Component(
    selector: 'course-navigator',
    templateUrl: 'course_navigator_component.html',
    directives: const [materialDirectives],
    providers: const [materialProviders,AppComponent])
class CourseNavigatorComponent {

  bool isVisible = false; //hide by default;

  CourseNavigatorComponent(){
    print('Course Navigator Component loaded...');
    isVisible=true; /*temporary override FIX*/
  }

  void HideCourseMenu(){
    isVisible=false;
    print('User Closed Course Navigator');
  }

}