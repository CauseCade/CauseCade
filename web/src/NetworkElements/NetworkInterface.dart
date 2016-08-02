
import 'graph.dart';
import 'dart:html';

/*This should handle interactions with other dart files in NetworkElements*/
var width = 480;
var height =480;

class BayesNetCanvas{


  BayesNetCanvas(){
    getScreenDimensions();
    new Graph(width,height);
  }


}

getScreenDimensions(){
  var NetworkHolder = querySelector('#GraphHolder');
  width = NetworkHolder.contentEdge.width;
  print(width);
  height = NetworkHolder.contentEdge.height;
}

