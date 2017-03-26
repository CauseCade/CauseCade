import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';

@Component(
    selector: 'welcome-modal',
    templateUrl: 'welcome_modal_component.html',
    directives: const [materialDirectives],
    providers: const [materialProviders])
class WelcomeComponent {

  bool IsVisible = true; //show by default;

  enterCauseCade(){
    IsVisible=false;
    print('Closed Welcome Modal');
  }

  takeTour(){
    print('currently not supported');
  }
}