import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'teach_service.dart';
import 'network_style_service.dart';

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

  bool isVisible = true; //show by default;

  WelcomeComponent(this.teachService,this.styleService);

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
    print('[WelcomeComponent]: loaded tutorial');
    enterCauseCade(); //closes the modal
  }
}