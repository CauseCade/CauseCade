import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';


@Component(
    selector: 'help_modal',
    templateUrl: 'help_component.html',
    styleUrls: const ['help_component.css'],
    directives: const [materialDirectives],
    providers: const [materialProviders])
class HelpComponent {
  @Input()
  bool isVisible;
  @Output() EventEmitter isVisibleChange = new EventEmitter();

  HelpComponent();

  void closeHelpMenu(){ //hide component and tell parent component weve done so
    isVisible=false;
    isVisibleChange.emit(false); //let appcomponent know we closed it
  }
}