import 'package:angular2/core.dart';

import 'package:angular_components/angular_components.dart';

import 'node.dart';
import 'package:causecade/app_component.dart';
import 'package:causecade/card_barchart.dart';
import 'package:chartjs/chartjs.dart';

import 'network_selection_service.dart';
import 'network_style_service.dart';

@Component(
    selector: 'detail',
    templateUrl: 'detail_component.html',
    styleUrls: const ['detail_component.css'],
    styles: const ['''
                    main{
                      margin-left: 4em ;
                      margin-top: 45em ;
                    }
                   '''],
    directives: const [materialDirectives],
    providers: const [materialProviders])

// THIS IS STILL WIP
class DetailComponent implements OnInit,OnChanges {
  @Input()
  bool shouldBeLoaded;
  @Input()
  node selectedNode;

  NetworkSelectionService selectionService;
  NetworkStyleService styleService;


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
  List<double> individualLambda;

  DetailComponent(this.selectionService,this.styleService);

  void ngOnInit() {
    print('[detail component initialised]');
  }

  void setupCard(){
    selectedNode = selectionService.selectedNode;
    IsRootNode = selectedNode.getRootStatus();
    HasEvidence = selectedNode.getEvidenceStatus();
    IncomingNodes = selectedNode.getParents();
    OutGoingNodes = selectedNode.getDaughters();
    LinkMatrixInfo = selectedNode.getLinkMatrixStatus();
    individualLambda = new List<double>();

    //Set Up the Flagging Name (name of node that last flagged this node)
    if (selectedNode.getFlaggingNode()!=null){
      FlaggingName=selectedNode.getFlaggingNode().getName();
    }
    else{
      FlaggingName='not flagged yet';
    }

    testChart();
  }

  void testChart(){
    if (ChartHolder==null){ // generate a new chart
      ChartHolder = GenerateEvidenceBarChart(selectedNode);
        print('generating brand new chart');
    }
    else{ //already have a chart, just update its data
        //print('updating existing chart');
      resetChart();
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
    //print(lambdaVector);
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

  void changeNode(node nodeClicked){
    selectionService.setNodeSelection(nodeClicked);
    styleService.setNodeSelection(selectionService.selectedNode);
  }

  //this function will be called if any of the @inputs change
  void ngOnChanges(changes){
    if( (changes.keys.last=='selectedNode')&&selectionService.selectedNode!=null){
      setupCard();
    }
  }

}