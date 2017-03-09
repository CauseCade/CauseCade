import 'node.dart';
import 'package:chartjs/chartjs.dart';
//import 'dart:math' as math; //FIX
import 'dart:html';
import 'package:causecade/network_interface.dart'; //to acces global variables


var width = 300;
var height = 300; //?

Chart GenerateBarchart(node NodeIn) {
  node Node = NodeIn;
  //var rnd = new math.Random();
  //var months = <String>["January", "February", "March", "April", "May", "June"];
  List ProbabilityHolderList = new List();
  for(int i=0;i<Node.getProbability().getSize();i++){
    ProbabilityHolderList.add(Node.getProbability()[i]);
  }

  var data = new LinearChartData(labels: Node.getStateLabels(), datasets: <ChartDataSets>[
    new ChartDataSets(
        label: 'Info of Node: ' + Node.getName(),
        backgroundColor: "rgba(223,30,90,1.0)",
        data: ProbabilityHolderList)]);

  var config = new ChartConfiguration(
      type: 'bar', data: data, options: new ChartOptions(responsive: true));

  Chart myChart = new Chart(querySelector('#BarChartHolder') as CanvasElement, config);
  return myChart;
}

updateBarChart(Chart ChartIn, node NodeIn){
  node Node = NodeIn;
  //var rnd = new math.Random();
  //var months = <String>["January", "February", "March", "April", "May", "June"];
  List ProbabilityHolderList = new List();
  for(int i=0;i<Node.getProbability().getSize();i++){
    ProbabilityHolderList.add(Node.getProbability()[i]);
  }

  var data = new LinearChartData(labels: Node.getStateLabels(), datasets: <ChartDataSets>[
    new ChartDataSets(
        label: 'Node: ' + Node.getName(),
        backgroundColor: "rgba(223,30,90,1.0)",
        data: ProbabilityHolderList)]);

  var config = new ChartConfiguration(
      type: 'bar', data: data, options: new ChartOptions(responsive: true));

  ChartIn.config=config;
  ChartIn.update();
}