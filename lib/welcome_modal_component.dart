import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'teach_service.dart';
import 'network_style_service.dart';
//for fetching the welcome text from URL
import 'package:markdown/markdown.dart' as md;
import 'dart:html' as htmlDart;



@Component(
    selector: 'welcome-modal',
    templateUrl: 'welcome_modal_component.html',
    styleUrls: const ['welcome_modal_component.css'],
    directives: const [materialDirectives],
    providers: const [materialProviders])
class WelcomeComponent {
  @Input()
  bool teachModeStatus;
  @Output() EventEmitter teachModeStatusChange = new EventEmitter();

  TeachService teachService;
  NetworkStyleService styleService;

  //for the welcome text from URL
  final String path = 'https://raw.githubusercontent.com/NemoAndrea/CauseCade-lessons/master/Welcome_Text.md';//welcome text url
  var htmlFromMarkdown;


  bool isVisible = true; //show by default;

  WelcomeComponent(this.teachService,this.styleService){
    htmlDart.HttpRequest req = new htmlDart.HttpRequest();
    req
      ..open('GET', path)
      ..onLoadEnd.listen((e){
        ///print(req.responseText);
        htmlFromMarkdown=md.markdownToHtml(req.responseText,inlineSyntaxes: [new md.InlineHtmlSyntax()]);
      })
      ..send('');
  }

  //closes the modal
  void enterCauseCade(){
    isVisible=false;
    print('Closed Welcome Modal');
  }

  void takeTour(){

    teachModeStatus=true;
    teachModeStatusChange.emit(true);
    styleService.setUiColours('teach');
    //ensure the tutorial is selected as the current lesson (tutorial=tour)
    teachService.selectTutorial();
    //print(teachService.currentLesson.lessonDescription); //debugging
    print('[WelcomeComponent]: loaded tutorial') ;
    enterCauseCade(); //closes the modal
  }
}