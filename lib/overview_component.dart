import 'package:angular2/core.dart';

import 'package:angular_components/angular_components.dart';
import  'network_selection_service.dart';

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

class OverviewComponent implements OnInit, OnChanges{

  @Input()
  bool shouldBeLoaded;
  @Input()
  node selectedNode;

  NetworkSelectionService selectionService;


  Chart ChartHolder;
  bool ShouldBeHidden;
  bool IsRootNode; //holds information about the selected node
  bool HasEvidence; //holds information about the selected node
  List IncomingNodes; //holds information about the selected node
  List OutGoingNodes;//holds information about the selected node

  OverviewComponent(this.selectionService);

 void ngOnInit(){
   print('[overview component initialised]');

    if(selectionService.selectedNode!=null){
      setupCard();
    }
  }

  void setupCard(){
    selectedNode=selectionService.selectedNode;
    //ChartHolder = GenerateBarchart(selectedNode);
    IsRootNode = selectedNode.getRootStatus();
    HasEvidence = selectedNode.getEvidenceStatus();
    IncomingNodes = selectedNode.getParents();
    OutGoingNodes = selectedNode.getDaughters();
    //makeBarChart();
    print('[overview]: refreshed data ');
  }

  void makeBarChart(){
    ChartHolder = GenerateBarchart(selectedNode);
  }

 void changeNode(node NodeIn){
   selectedNode=NodeIn;
   print('OverviewComponent: changed node to: ' + selectedNode.getName());
 }

  //this function will be called if any of the @inputs change
  void ngOnChanges(SimpleChange){
    //print(SimpleChange);
    if(selectionService.selectedNode!=null){
      setupCard();
    }
  }
}