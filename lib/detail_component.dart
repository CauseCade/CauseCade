import 'package:angular2/core.dart';

import 'package:angular2_components/angular2_components.dart';
import 'package:angular2/router.dart';

import 'node.dart';
import 'package:causecade/app_component.dart';
import 'package:causecade/card_barchart.dart';
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
  String FlaggingName;
  bool ShouldBeHidden;
  bool IsRootNode;
  Chart ChartHolder;

  //holds information about the selected node
  bool HasEvidence;

  //holds information about the selected node
  List IncomingNodes;

  //holds information about the selected node
  List OutGoingNodes;

  //holds information about the selected node

  DetailComponent(this._routeParams);

  ngOnInit() {
    if(_routeParams.get('id')!=null) {
      setupCard();
    }
    else{
      //else, we should hide this component
      ShouldBeHidden=true;
    }
  }

  setupCard(){
    SelectedNode = myDAG.findNode(_routeParams.get('id'));
    IsRootNode = SelectedNode.getRootStatus();
    HasEvidence = SelectedNode.getEvidenceStatus();
    IncomingNodes = SelectedNode.getParents();
    OutGoingNodes = SelectedNode.getDaughters();
    ChartHolder = GenerateEvidenceBarChart(SelectedNode);
    //Set Up the Flagging Name (name of node that last flagged this node)
    if (SelectedNode.getFlaggingNode()!=null){
      FlaggingName=SelectedNode.getFlaggingNode().getName();
    }
    else{
      FlaggingName='not flagged yet';
    }
  }
}