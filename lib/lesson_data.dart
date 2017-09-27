import 'lesson.dart';
import 'course.dart';
import 'notification_service.dart'; //acces to class NetNotification


 List<Course> courseData = [
  new Course('Tutorial','01-07-2017'),
  //new Course('Basics','22-07-2017'),
  //new Course('Intermediate','22-07-2017')
];

void configureCourses(){

Lesson lesson1 = new Lesson('Tutorial - L1','26-09-2017')
..lessonDescription = 'Learning to navigate CauseCade'
..lessonMarkdownPath =  'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Tutorial_Pt_1.md'
..goals=([
 new NetNotification()..setTeachMode(),
 new NetNotification()..setNotificationDisplayStatus(true),
 new NetNotification()..setNodeDisplayMode("details"),
 new NetNotification()..setNewNetworkName()
]);
courseData[0].addLesson(lesson1);

Lesson lesson2 = new Lesson('Tutorial - L2','26-09-2017')
..lessonDescription = 'Learning to load and manipulate a network'
..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Tutorial_Pt_2.md'
..goals=([
 new NetNotification()..setLoadMenuStatus(true),
 new NetNotification()..setLoadStatus("Animals"),
 new NetNotification()..setNodeSelectedDetail('Class'),
 new NetNotification()..setNodeSelectedDetail('WarmBlooded'),
 new NetNotification()..setNodeSelectedDetail('WarmBlooded')
]);
courseData[0].addLesson(lesson2);

Lesson lesson3 = new Lesson('Tutorial - L3','27-09-2017')
 ..lessonDescription = 'Learning to manipulate individual nodes'
 ..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Tutorial_Pt_3.md'
 ..goals=([
  new NetNotification()..setNodeAdderMenuStatus(true),
  new NetNotification()..setNewNode()
 ]);
courseData[0].addLesson(lesson3);

/*Lesson lesson4 = new Lesson('Probability','20-07-2017')
..lessonDescription = 'Introduction to Probability'
..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Probability.md';
courseData[1].addLesson(lesson4);*/

/*Lesson lesson4 = new Lesson('x1','01-07-2017')
..lessonDescription = 'dummy x1'
..lessonMarkdownPath = '/not/selected/yet.md';
courseData[2].addLesson(lesson4);

Lesson lesson5 = new Lesson('x2','01-07-2017')
..lessonDescription = 'dummy x2'
..lessonMarkdownPath = '/not/selected/yet.md';
courseData[2].addLesson(lesson5);*/

print('All Lessons configured in proper Courses');
}