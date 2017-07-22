//This Component will hold the navigation and progress information for the
// CauseCade course (educational) part

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'course_navigator_component.dart';
import 'package:markdown/markdown.dart' as md;
import 'dart:io';


//import 'package:causecade/tester_markdown.md';


@Component(
    selector: 'course-lesson',
    templateUrl: 'course_lesson_component.html',
    directives: const [materialDirectives],
    providers: const [materialProviders,CourseNavigatorComponent])
class CourseLessonComponent {

  bool lessonSelected = false; //hide by default;
  int goalCount = 6; //Dummy Value //FIX
  List<String> goalList;


  var htmlFromMarkdown = md.markdownToHtml("<h1>Lesson Test</h1> <br> Why is dart **incompetent**?");


  CourseLessonComponent(){
    print('Course Lesson Component loaded...');
    goalList = new List<String>(goalCount);
  }

  void deselectLesson(){
    lessonSelected=false;
  }

  void selectLesson(){
    lessonSelected = true;
  }
}