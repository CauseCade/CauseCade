import 'lesson.dart';
import 'course.dart';
import 'notification_service.dart'; //acces to class NetNotification


/*
* DEPECRATED - ALL DATA NOW FETCHED FROM JSON FILES REMOTELY
*/

 CourseHolder myCourses = new CourseHolder();
 List<Course> courseData = [
  new Course()..initialiseCourse('Tutorial','01-07-2017')..networkUrlList=['https://github.com/CauseCade/CauseCade-networks/blob/master/bayes_2.json','https://github.com/CauseCade/CauseCade-networks/blob/master/bayes_1.json'],
  new Course()..initialiseCourse('Probability','11-10-2017'),
  new Course()..initialiseCourse('bayes','11-10-2017'),
  new Course()..initialiseCourse('Compared to other Networks','03-12-2017'),
  new Course()..initialiseCourse('Applications in biology','03-12-2017')
];

void configureCourses(){
 Lesson lesson;

lesson = new Lesson();
lesson.initialiseLesson('Tutorial - L1','26-09-2017');
lesson..lessonDescription = 'Learning to navigate CauseCade'
 ..lessonNetworkIndices=[1,2]
..lessonMarkdownPath =  'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Tutorial_Pt_1.md'
..goals=([
 new NetNotification()..setTeachMode(),
 new NetNotification()..setNotificationDisplayStatus(true),
 new NetNotification()..setNodeDisplayMode("details"),
 new NetNotification()..setNewNetworkName()
]);
courseData[0].addLesson(lesson);

lesson = new Lesson();
lesson.initialiseLesson('Tutorial - L2','26-09-2017');
lesson..lessonDescription = 'Learning to load and manipulate a network'
..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Tutorial_Pt_2.md'
..goals=([
 new NetNotification()..setLoadMenuStatus(true),
 new NetNotification()..setLoadStatus("Animals"),
 new NetNotification()..setNodeSelectedDetail('Class'),
 new NetNotification()..setNodeSelectedDetail('WarmBlooded'),
 new NetNotification()..setNodeSelectedDetail('WarmBlooded')
]);
courseData[0].addLesson(lesson);

lesson = new Lesson();
lesson.initialiseLesson('Tutorial - L3','27-09-2017');
 lesson..lessonDescription = 'Learning to manipulate individual nodes'
 ..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Tutorial_Pt_3.md'
 ..goals=([
  new NetNotification()..setNodeAdderMenuStatus(true),
  new NetNotification()..setNewNode()
 ]);
courseData[0].addLesson(lesson);

 /*Course 2 -> Probability*/

 lesson = new Lesson();
lesson.initialiseLesson('Probability - L1','11-10-2017');
lesson..lessonDescription = 'Introduction to Probability'
..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Probability_Pt_1.md';
courseData[1].addLesson(lesson);

 lesson = new Lesson();
lesson.initialiseLesson('Probability - L2','11-10-2017');
 lesson..lessonDescription = 'Understanding Conditional Probability'
 ..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Probability_Pt_2.md';
courseData[1].addLesson(lesson);

/*Course 3 -> Bayes 1*/

 lesson = new Lesson();
lesson.initialiseLesson('Preface','03-12-2017');
  lesson..lessonDescription = 'Introduction and Motivation for a bayesian network'
  ..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Bayesian_Network_Pt_0.md';
 courseData[2].addLesson(lesson);

lesson = new Lesson();
lesson.initialiseLesson('Basic Bayes','11-10-2017');
lesson..lessonDescription = 'understanding the use of bayes'
..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Bayesian_Network_Pt_1.md';
courseData[2].addLesson(lesson);

lesson = new Lesson();
lesson.initialiseLesson('Basic Bayes 2','11-10-2017');
lesson..lessonDescription = 'downward propagation in a 2 node system'
..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Bayesian_Network_Pt_2.md';
courseData[2].addLesson(lesson);

 lesson = new Lesson();
lesson.initialiseLesson('Basic Bayes 3','11-10-2017');
  lesson..lessonDescription = 'upward propagation in a 2 node system'
  ..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Bayesian_Network_Pt_3.md';
 courseData[2].addLesson(lesson);

 lesson = new Lesson();
lesson.initialiseLesson('Independence 1','11-10-2017');
  lesson..lessonDescription = 'Independence relationships in a bayesian network'
  ..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Bayesian_Network_Pt_4.md';
 courseData[2].addLesson(lesson);

/*
 lesson = new Lesson('Independence 2','11-10-2017');
lesson.initialiseLesson()
  ..lessonDescription = 'Independence relationships in a bayesian network'
  ..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Bayesian_Network_Pt_5.md';
 courseData[2].addLesson(lesson);

 lesson = new Lesson('Independence 3','03-12-2017');
lesson.initialiseLesson()
  ..lessonDescription = 'Independence relationships in a bayesian network'
  ..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Bayesian_Network_Pt_6.md';
 courseData[2].addLesson(lesson);

 lesson = new Lesson('Bayes & Causality','03-12-2017');
lesson.initialiseLesson();
  ..lessonDescription = 'Understanding Causality and directionality of a bayesnet'
  ..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Bayesian_Network_Pt_7.md';
 courseData[2].addLesson(lesson);

 */
/*Course 4 -> Compared to boolean*//*


 lesson = new Lesson('Preface','03-12-2017');
lesson.initialiseLesson();
  ..lessonDescription = 'Introduction'
  ..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Other_Networks_Pt_0.md';
 courseData[3].addLesson(lesson);

 */
/*Course 5 -> Applications in biology*//*


 lesson = new Lesson('Preface','03-12-2017');
lesson.initialiseLesson();
  ..lessonDescription = 'Introduction'
  ..lessonMarkdownPath = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Applications_Biology_Pt_0.md';
 courseData[4].addLesson(lesson);
*/

print('All Lessons configured in proper Courses');
}