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

  node SelectedNode;
  Chart ChartHolder;
  bool ShouldBeHidden;
  bool IsRootNode; //holds information about the selected node
  bool HasEvidence; //holds information about the selected node
  List IncomingNodes; //holds information about the selected node
  List OutGoingNodes;//holds information about the selected node

  OverviewComponent(this._routeParams);

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
/*

  //this allows the user to manually type a node they want info about
  onKey(dynamic event){
    SelectedNode = myDAG.findNode(event.target.value);
    if (SelectedNode!=null) {
      print(SelectedNode.getName());

      IsRootNode = SelectedNode.getRootStatus();
      HasEvidence = SelectedNode.getEvidenceStatus();
      IncomingNodes = SelectedNode.getParents();
      OutGoingNodes = SelectedNode.getDaughters();

      //Handling Updating the Bar Chart
      if(ChartHolder!=null){updateBarChart(ChartHolder,SelectedNode);}
      else{
        HasNodeSelected=true;

        ChartHolder = GenerateBarchart(SelectedNode);

      }
    }
  }*/
}