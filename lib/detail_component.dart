import 'package:angular2/core.dart';

import 'package:angular2_components/angular2_components.dart';
import 'package:angular2/router.dart';

import 'node.dart';
import 'package:causecade/app_component.dart';
import 'package:chartjs/chartjs.dart';

@Component(
    selector: 'detail',
    templateUrl: 'detail_component.html',
    styles: const ['''
                    main{
                      margin-left: 4em ;
                      margin-top: 45em ;
                    }
                   '''],
    directives: const [materialDirectives],
    providers: const [materialProviders])

// THIS IS STILL WIP
class DetailComponent implements OnInit {
  final RouteParams _routeParams;

  node SelectedNode;
  bool ShouldBeHidden;
  bool IsRootNode;

  //holds information about the selected node
  bool HasEvidence;

  //holds information about the selected node
  List IncomingNodes;

  //holds information about the selected node
  List OutGoingNodes;

  //holds information about the selected node

  DetailComponent(this._routeParams);

  ngOnInit() {
    print('node overview for: ' +
        _routeParams.get('id').toString()); //fetch searched string
    if(_routeParams.get('id')!=null) {
      print('not null, byos');
      SelectedNode = myDAG.findNode(_routeParams.get('id'));
      IsRootNode = SelectedNode.getRootStatus();
      HasEvidence = SelectedNode.getEvidenceStatus();
      IncomingNodes = SelectedNode.getParents();
      OutGoingNodes = SelectedNode.getDaughters();
    }
    else{
      //else, we should hide this component
      ShouldBeHidden=true;
    }
  }
}