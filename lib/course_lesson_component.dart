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
import 'dart:async';
import 'package:http/browser_client.dart';
import 'dart:html' as htmlDart;

//import 'package:causecade/tester_markdown.md';


@Component(
    selector: 'course-lesson',
    templateUrl: 'course_lesson_component.html',
    directives: const [materialDirectives],
    providers: const [materialProviders,CourseNavigatorComponent])
class CourseLessonComponent implements OnChanges{
  @Input()
  Lesson currentLesson;
  @Input()
  bool lessonSelected;

  //services
  TeachService _teachService;
  NotificationService notifications;

  //variables
  var client = new BrowserClient();
  var url =  'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Tutorial_1?token=AIcQjC852NXVpSAispVCK_GSQOoyC8AWks5Z0S7-wA%3D%3D';
  var response;

  int goalCount = 6; //Dummy Value //FIX
  List<String> goalList;
  var htmlFromMarkdown;// = md.markdownToHtml("#Lesson Test \n Why is dart *incompetent*?");



   CourseLessonComponent(this._teachService,this.notifications)  {
      print('Course Lesson Component loaded...');
   }

  void refreshLesson(){
    //update notifications
    notifications.addNotification(new NetNotification()..setLessonSelection());
    //load the markdown from github repo
    String path = currentLesson.markdownPath;
    htmlDart.HttpRequest req = new htmlDart.HttpRequest();
    req
      ..open('GET', path)
      ..onLoadEnd.listen((e){
        ///print(req.responseText);
        htmlFromMarkdown=md.markdownToHtml(req.responseText);
      })
      ..send('');
  }

  void deselectLesson(){
    lessonSelected=false;
  }

  void selectLesson(){
    lessonSelected = true;
  }

  void ngOnChanges(SimpleChange){
    if(currentLesson!=null){
      refreshLesson();
    }
  }
}