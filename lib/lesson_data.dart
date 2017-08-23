import 'lesson.dart';
import 'course.dart';


 List<Course> courseData = [
  new Course('Tutorial','01-07-2017'),
  new Course('Basics','22-07-2017'),
  new Course('Intermediate','22-07-2017')
];

void configureCourses(){

Lesson lesson1 = new Lesson('Tutorial Pt 1','01-07-2017')
..lessonDescription = 'The very Basics of CauseCade'
..lessonMarkdownPath = '/not/selected/yet.md';
courseData[0].addLesson(lesson1);

Lesson lesson2 = new Lesson('Tutorial Pt 2','19-07-2017')
..lessonDescription = 'The very Basics of CauseCade 2'
..lessonMarkdownPath = '/not/selected/yet.md'
..goals=(['doggo','snek','pupper','test4']);
courseData[0].addLesson(lesson2);

Lesson lesson3 = new Lesson('Probability','20-07-2017')
..lessonDescription = 'Introduction to Probability'
..lessonMarkdownPath = '/not/selected/yet.md';
courseData[1].addLesson(lesson3);

Lesson lesson4 = new Lesson('x1','01-07-2017')
..lessonDescription = 'dummy x1'
..lessonMarkdownPath = '/not/selected/yet.md';
courseData[2].addLesson(lesson4);

Lesson lesson5 = new Lesson('x2','01-07-2017')
..lessonDescription = 'dummy x2'
..lessonMarkdownPath = '/not/selected/yet.md';
courseData[2].addLesson(lesson5);

print('All Lessons configured in proper Courses');
}