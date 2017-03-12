import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'node.dart';
import 'package:causecade/app_component.dart';
import 'package:causecade/card_barchart.dart';
import 'package:causecade/example_networks.dart';
import 'package:chartjs/chartjs.dart';

@Component(
    selector: 'net-info',
    templateUrl: 'info_component.html',
    styles: const ['''
                    main{
                      margin-left: 4em ;
                      margin-top: 4em ;
                    }
                   '''],
    directives: const [materialDirectives],
    providers: const [materialProviders])
class InfoComponent {
  var name = 'Angular';
  node SelectedNode;
  Chart ChartHolder;
  bool HasNodeSelected;


  //when the ''LOAD'' button is clicked
  loadData(){
    //This function will get improved functionality in the future
    LoadExample_Animals(); //loads the animals example
  }

  //this allows the user to manually type a node they want info about
  onKey(dynamic event){
    SelectedNode = myDAG.findNode(event.target.value);
    if (SelectedNode!=null) {
      print(SelectedNode.getName());

      if(ChartHolder!=null){updateBarChart(ChartHolder,SelectedNode);}
      else{
        HasNodeSelected=true;
        ChartHolder = GenerateBarchart(SelectedNode);

      }
    }
  }
}