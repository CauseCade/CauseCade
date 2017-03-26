import 'package:angular2/core.dart';

import 'package:angular2_components/angular2_components.dart';
import 'package:angular2/router.dart';

import 'node.dart';
import 'package:causecade/app_component.dart';
import 'package:causecade/card_barchart.dart';
import 'package:chartjs/chartjs.dart';


@Component(
    selector: 'overview',
    templateUrl: 'overview_component.html',
    styles: const ['''
                    main{
                      margin-left: 4em ;
                      margin-top: 45em ;
                    }
                   '''],
    directives: const [materialDirectives],
    providers: const [materialProviders])

class OverviewComponent implements OnInit{
  final RouteParams _routeParams;
  final Router _router;

  node SelectedNode;
  Chart ChartHolder;
  bool ShouldBeHidden;
  bool IsRootNode; //holds information about the selected node
  bool HasEvidence; //holds information about the selected node
  List IncomingNodes; //holds information about the selected node
  List OutGoingNodes;//holds information about the selected node

  OverviewComponent(this._routeParams,this._router);

 ngOnInit(){
  print('node overview for: ' + _routeParams.get('id').toString()); //fetch searched string
  if(_routeParams.get('id')!=null) {
    print('not null, byos');
    SelectedNode = myDAG.findNode(_routeParams.get('id'));
    ChartHolder = GenerateBarchart(SelectedNode);

    IsRootNode = SelectedNode.getRootStatus();
    HasEvidence = SelectedNode.getEvidenceStatus();
    IncomingNodes = SelectedNode.getParents();
    OutGoingNodes = SelectedNode.getDaughters();
    makeBarChart();
  }
  else{
    //else, hide the component
    ShouldBeHidden=true;
  }

  }

  makeBarChart(){
    ChartHolder = GenerateBarchart(SelectedNode);
  }

  Navigate(String NameIn){
    print('navigating trough roter');
    _router.navigate(['overview',{'id':NameIn}]);
  }
}