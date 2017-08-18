import 'package:angular2/core.dart';

import 'package:angular_components/angular_components.dart';
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
  bool LinkMatrixInfo;
  Chart ChartHolder;



  //holds information about the selected node
  bool HasEvidence;

  //holds information about the selected node
  List IncomingNodes;

  //holds information about the selected node
  List OutGoingNodes;

  //holds information about indivdual lambda evidences (of one of teh daughters)
  List individualLambda;

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
    LinkMatrixInfo = SelectedNode.getLinkMatrixStatus();
    individualLambda = new List<double>();
    //Set Up the Flagging Name (name of node that last flagged this node)
    if (SelectedNode.getFlaggingNode()!=null){
      FlaggingName=SelectedNode.getFlaggingNode().getName();
    }
    else{
      FlaggingName='not flagged yet';
    }
  }

  //TODO see how we can make this work better with card_bartchart.dart
  void resetChart(){
    List LambdaHolderList = new List();
    List PiHolderList = new List();
    /*Vector LambdaVector;
  Vector PiVector;*/

    for(int i=0;i<SelectedNode.getStateCount();i++){
      LambdaHolderList.add(SelectedNode.getLambdaEvidence()[i]);
      PiHolderList.add(SelectedNode.getPiEvidence()[i]);
    }

    var data = new LinearChartData(labels:SelectedNode.getStateLabels(), datasets: <ChartDataSets>[
      new ChartDataSets(
          label: 'Lambda Evidence of Node: ' + SelectedNode.getName(),
          backgroundColor: "rgba(223,30,90,1.0)",
          data: LambdaHolderList),
      new ChartDataSets(
          label: 'Pi Evidence of Node: ' + SelectedNode.getName(),
          backgroundColor: "rgba(30,30,90,1.0)",
          data: PiHolderList)
    ]);

    ChartHolder.config = new ChartConfiguration(
        type: 'bar', data: data, options: new ChartOptions(responsive: true));
    ChartHolder.update();
  }

  void setChartLambda(node nodeIn){
    print('new chart requested for ' + nodeIn.getName());
    individualLambda.clear(); //we must clear this
    var lambdaVector = SelectedNode.getIndividualLambda(nodeIn);
    for(int i=0;i<SelectedNode.getStateCount();i++){
      individualLambda.add(lambdaVector[i]);
    }
    print('individual lambda for chart: ' + individualLambda.toString());

    var data = new LinearChartData(labels: SelectedNode.getStateLabels(), datasets: <ChartDataSets>[
      new ChartDataSets(
          label: 'Lambda Evidence from Node: ' + nodeIn.getName(),
          backgroundColor: "rgba(223,30,90,1.0)",
          data: individualLambda)]);

    ChartHolder.config = new ChartConfiguration(
        type: 'bar', data: data, options: new ChartOptions(responsive: true));
    ChartHolder.update();
  }

}