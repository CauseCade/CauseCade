import 'package:angular2/core.dart';

import 'package:angular_components/angular_components.dart';
import  'network_selection_service.dart';
import 'network_style_service.dart';

import 'node.dart';
import 'package:causecade/app_component.dart';
import 'package:causecade/card_barchart.dart';
import 'package:chartjs/chartjs.dart';



@Component(
    selector: 'overview',
    templateUrl: 'overview_component.html',
    styleUrls: const ['overview_component.css'],
    styles: const ['''
                    main{
                      margin-left: 4em ;
                      margin-top: 45em ;
                    }
                   '''],
    directives: const [materialDirectives],
    providers: const [materialProviders])

class OverviewComponent implements OnInit, OnChanges{

  @Input()
  bool shouldBeLoaded;
  @Input()
  node selectedNode;

  NetworkSelectionService selectionService;
  NetworkStyleService styleService;


  Chart ChartHolder;
  bool ShouldBeHidden;
  bool IsRootNode; //holds information about the selected node
  bool HasEvidence; //holds information about the selected node
  List IncomingNodes; //holds information about the selected node
  List OutGoingNodes;//holds information about the selected node
  String nodeName;
  String cardStringRoot;
  String cardStringEvidence;

  OverviewComponent(this.selectionService,this.styleService);

 void ngOnInit(){
   print('[overview component initialised]');

   //get a barchart loaded with no data in it
   //will be modified once a node is selected (this chart should never be visible)
   ChartHolder =  generateEmptyBarChart();
  }

  void setupCard(){
    selectedNode=selectionService.selectedNode;
    nodeName=selectedNode.getName();
    IsRootNode = selectedNode.getRootStatus();
    HasEvidence = selectedNode.getEvidenceStatus();
    IncomingNodes = selectedNode.getParents();
    OutGoingNodes = selectedNode.getDaughters();
    configureStrings();
    configureChart();

    print('[overview]: refreshed data ');
  }

  void configureStrings(){
    if(IsRootNode){
      cardStringRoot='Node has no parents';
    }
    else{
      cardStringRoot='Node has parents';
    }

    if(HasEvidence){
      cardStringEvidence='This node has been observed';
    }
    else{
      cardStringEvidence='This node has not been observed';
    }
  }

  //update the chart, setting the data for the currently selected node
  void configureChart(){
    //create a new list to hold data
    List ProbabilityHolderList = new List();
    for(int i=0;i<selectedNode.getStateCount();i++){
      ProbabilityHolderList.add(selectedNode.getProbability()[i]);
    }

    var data = new LinearChartData(labels:selectedNode.getStateLabels(), datasets: <ChartDataSets>[
      new ChartDataSets(
          label: 'Probabilities per state',
          backgroundColor: "rgba(223,30,90,1.0)",
          data: ProbabilityHolderList)]);

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
    //print(SimpleChange);
    if( (changes.keys.last=='selectedNode')&&selectionService.selectedNode!=null){
      setupCard();
    }
  }
}