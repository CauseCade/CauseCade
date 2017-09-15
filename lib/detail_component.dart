import 'package:angular2/core.dart';

import 'package:angular_components/angular_components.dart';

import 'node.dart';
import 'package:causecade/app_component.dart';
import 'package:causecade/card_barchart.dart';
import 'package:chartjs/chartjs.dart';

import 'network_selection_service.dart';

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
  @Input()
  bool shouldBeLoaded;
  @Input()
  node selectedNode;

  NetworkSelectionService selectionService;


  String FlaggingName;
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

  DetailComponent(this.selectionService);

  void ngOnInit() {
    if(selectionService.selectedNode!=null) {
      setupCard();
    }
  }

  void setupCard(){
    selectedNode = selectionService.selectedNode;
    IsRootNode = selectedNode.getRootStatus();
    HasEvidence = selectedNode.getEvidenceStatus();
    IncomingNodes = selectedNode.getParents();
    OutGoingNodes = selectedNode.getDaughters();
    ChartHolder = GenerateEvidenceBarChart(selectedNode);
    LinkMatrixInfo = selectedNode.getLinkMatrixStatus();
    individualLambda = new List<double>();
    //Set Up the Flagging Name (name of node that last flagged this node)
    if (selectedNode.getFlaggingNode()!=null){
      FlaggingName=selectedNode.getFlaggingNode().getName();
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

    for(int i=0;i<selectedNode.getStateCount();i++){
      LambdaHolderList.add(selectedNode.getLambdaEvidence()[i]);
      PiHolderList.add(selectedNode.getPiEvidence()[i]);
    }

    var data = new LinearChartData(labels:selectedNode.getStateLabels(), datasets: <ChartDataSets>[
      new ChartDataSets(
          label: 'Lambda Evidence of Node: ' + selectedNode.getName(),
          backgroundColor: "rgba(223,30,90,1.0)",
          data: LambdaHolderList),
      new ChartDataSets(
          label: 'Pi Evidence of Node: ' + selectedNode.getName(),
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
    var lambdaVector = selectedNode.getIndividualLambda(nodeIn);
    for(int i=0;i<selectedNode.getStateCount();i++){
      individualLambda.add(lambdaVector[i]);
    }
    print('individual lambda for chart: ' + individualLambda.toString());

    var data = new LinearChartData(labels: selectedNode.getStateLabels(), datasets: <ChartDataSets>[
      new ChartDataSets(
          label: 'Lambda Evidence from Node: ' + nodeIn.getName(),
          backgroundColor: "rgba(223,30,90,1.0)",
          data: individualLambda)]);

    ChartHolder.config = new ChartConfiguration(
        type: 'bar', data: data, options: new ChartOptions(responsive: true));
    ChartHolder.update();
  }

  //this function will be called if any of the @inputs change
  void ngOnChanges(SimpleChange){
    //print(SimpleChange);
    if(selectionService.selectedNode!=null){
     //
    }
  }

}