//This Component will hold the navigation and progress information for the
// CauseCade course (educational) part

import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'course_navigator_component.dart';
import 'package:markdown/markdown.dart' as md;
import 'dart:io';
import 'package:causecade/teach_service.dart';
import 'lesson.dart';
import 'notification_service.dart';

//import 'package:causecade/tester_markdown.md';


@Component(
    selector: 'course-lesson',
    templateUrl: 'course_lesson_component.html',
    directives: const [materialDirectives],
    providers: const [materialProviders,CourseNavigatorComponent])
class CourseLessonComponent {
  @Input()
  Lesson currentLesson;
  @Input()
  bool lessonSelected;

  final TeachService _teachService;
   NotificationService notifications;
  int goalCount = 6; //Dummy Value //FIX
  List<String> goalList;
  var htmlFromMarkdown = md.markdownToHtml("<h1>Lesson Test</h1> <br> Why is dart **incompetent**?");


  CourseLessonComponent(this._teachService,this.notifications){
    print('Course Lesson Component loaded...');
    goalList = new List<String>(goalCount);
    notifications.addNotification(new NetNotification()..setLessonSelection()); //fix, make this work onchange
  }

  void deselectLesson(){
    lessonSelected=false;
  }

  void selectLesson(){
    lessonSelected = true;
  }
}