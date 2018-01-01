import 'node.dart';
import 'package:chartjs/chartjs.dart';
//import 'dart:math' as math; //FIX
import 'dart:html';
import 'package:causecade/app_component.dart'; //to acces global variables


var width = 300;
var height = 300; //?

//------------- THIS could be made more flexible -----------------------------

Chart generateEmptyBarChart(){


  //configure the axis of the barchart
  TickOptions myTickOptions = new TickOptions();
  myTickOptions.max=1;
  myTickOptions.min=0;
  List yAxes = []; //hold y axis information
  ChartYAxe yAxe = new ChartYAxe();
  yAxe.ticks=myTickOptions;
  yAxes.add(yAxe);
  ChartScales chartScales = new ChartScales(yAxes: yAxes);

  var data = new LinearChartData(labels: ['none'], datasets: <ChartDataSets>[
    new ChartDataSets(
        label: 'empty chart',
        backgroundColor: "rgba(223,30,90,1.0)",
        data: [1.0])]);

  var config = new ChartConfiguration(
      type: 'bar', data: data, options: new ChartOptions(responsive: true,scales: chartScales));

  Chart myChart = new Chart(querySelector('#BarChartHolderOverview') as CanvasElement, config);
  return myChart;
}

//TODO: see if this class needs to be removed
Chart GenerateBarchart(node NodeIn) {  node Node = NodeIn;


   List ProbabilityHolderList = new List();
  for(int i=0;i<Node.getStateCount();i++){
    ProbabilityHolderList.add(Node.getProbability()[i]);
  }

  var data = new LinearChartData(labels: Node.getStateLabels(), datasets: <ChartDataSets>[
    new ChartDataSets(
        label: 'Info of Node: ' + Node.getName(),
        backgroundColor: "rgba(223,30,90,1.0)",
        data: ProbabilityHolderList)]);

  var config = new ChartConfiguration(
      type: 'bar', data: data, options: new ChartOptions(responsive: true));

  Chart myChart = new Chart(querySelector('#BarChartHolderOverview') as CanvasElement, config);
  return myChart;
}


//TODO conosider reworking this (see detailcomponent)
Chart GenerateEvidenceBarChart(node NodeIn){

  List LambdaHolderList = new List();
  List PiHolderList = new List();
  /*Vector LambdaVector;
  Vector PiVector;*/

  //configure the axis of the barchart
  TickOptions myTickOptions = new TickOptions();
  myTickOptions.max=1;
  myTickOptions.min=0;
  List yAxes = []; //hold y axis information
  ChartYAxe yAxe = new ChartYAxe();
  yAxe.ticks=myTickOptions;
  yAxes.add(yAxe);
  ChartScales chartScales = new ChartScales(yAxes: yAxes);

  for(int i=0;i<NodeIn.getStateCount();i++){
    LambdaHolderList.add(NodeIn.getLambdaEvidence()[i]);
    PiHolderList.add(NodeIn.getPiEvidence()[i]);
  }

  var data = new LinearChartData(labels: NodeIn.getStateLabels(), datasets: <ChartDataSets>[
    new ChartDataSets(
        label: 'Lambda Evidence of Node: ' + NodeIn.getName(),
        backgroundColor: "rgba(223,30,90,1.0)",
        data: LambdaHolderList),
    new ChartDataSets(
      label: 'Pi Evidence of Node: ' + NodeIn.getName(),
      backgroundColor: "rgba(30,30,90,1.0)",
      data: PiHolderList)
  ]);

  var config = new ChartConfiguration(
      type: 'bar', data: data, options: new ChartOptions(responsive: true,scales: chartScales));

  Chart myChart = new Chart(querySelector('#BarChartHolderDetail') as CanvasElement, config);
  return myChart;
}
