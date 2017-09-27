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
    styleUrls: const ['course_lesson_component.css'],
    directives: const [materialDirectives],
    providers: const [materialProviders,CourseNavigatorComponent])
class CourseLessonComponent implements OnChanges{
  @Input()
  Lesson currentLesson;
  @Input() //this is another workaround (to listen to changes)
  NetNotification lastNotification;

  //services
  TeachService _teachService;
  NotificationService notifications;

  //variables
  var client = new BrowserClient();
  var url =  'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Tutorial_1?token=AIcQjC852NXVpSAispVCK_GSQOoyC8AWks5Z0S7-wA%3D%3D';
  var response;

  int goalCount = 6; //Dummy Value //FIX
  List<NetNotification> goalList;
  var htmlFromMarkdown;

  String lessonName;

   CourseLessonComponent(this._teachService,this.notifications)  {
      print('Course Lesson Component loaded...');
   }

  void refreshLesson(){
    //update notifications
    notifications.addNotification(new NetNotification()..setLessonSelection());
    //load the markdown from github repo
    lessonName=currentLesson.lessonName;
    String path = currentLesson.markdownPath;
    htmlDart.HttpRequest req = new htmlDart.HttpRequest();
    req
      ..open('GET', path)
      ..onLoadEnd.listen((e){
        ///print(req.responseText);
        htmlFromMarkdown=md.markdownToHtml(req.responseText,inlineSyntaxes: [new md.InlineHtmlSyntax()]);
      })
      ..send('');
    goalList=currentLesson.goalList;
  }

  void checkGoals(){
    //this is called every time a new notificaiton is added
    NetNotification newNotification = lastNotification;
    //check if this netNotificaiton is in the list of goals (i.e. notifications)
    for (int i=0;i<goalList.length;i++){
      if(goalList[i].notificationText==newNotification.notificationText){
        htmlDart.querySelector('#goal_'+(i+1).toString()).style.backgroundColor='green';
        htmlDart.querySelector('.goal_icon_'+(i+1).toString()).style.borderColor='green';
        break; //to allow for the same command twice in a single lesson
      }
    };
    // most of the time this will evaluate to false.
  }

  void ngOnChanges(Map<String, SimpleChange> changes){
    //print('[lesson] change to: '+changes.keys.last);
    if (changes.keys.last=='lastNotification'&&goalList!= null){
      checkGoals();
    }
    else if (changes.keys.last=='currentLesson'){
      if (currentLesson != null) {
        refreshLesson();
      }
    }
    else{
      print('[lesson]: unknown change detected.');
    }

  }
}