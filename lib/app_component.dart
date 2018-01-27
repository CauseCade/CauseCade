import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';

import 'package:causecade/network.dart';
import 'package:causecade/bayesian_dag.dart';

import 'package:causecade/overview_component.dart';
import 'package:causecade/course_navigator_component.dart';
import 'package:causecade/detail_component.dart';
import 'package:causecade/edit_component.dart';
import 'package:causecade/node_adder_component.dart';
import 'package:causecade/welcome_modal_component.dart';
import 'package:causecade/load_component.dart';
import 'package:causecade/help_component.dart';


import 'dart:html';

import 'node.dart';
import 'link.dart';
import 'dart:async';
import 'package:dartson/dartson.dart';

import 'package:d3/d3.dart';

//injectable imports
import  'notification_service.dart';
import 'network_style_service.dart';
import 'network_selection_service.dart';
import 'teach_service.dart';

List networkInfo = new List();
Network myNet;
BayesianDAG myDAG;

@Component(
    selector: 'causecade',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
directives: const [NodeAdderComponent,materialDirectives,WelcomeComponent,CourseNavigatorComponent,OverviewComponent,DetailComponent,EditComponent,LoadComponent,HelpComponent],
providers: const [materialProviders,NotificationService,NetworkStyleService,NetworkSelectionService,TeachService]
)
class AppComponent implements OnInit {

  TeachService teachService;
  NotificationService notifications;
  NetworkStyleService styleService;
  NetworkSelectionService selectionService;


  //display settings
  var width = 900;
  var height = 900;
  var networkHolder;
  var svg;

  //handles info cards
  bool overviewActive;
  bool detailActive;
  bool editActive;

  String currentNodeName; //required due to tab interface FIX
  node currentNode;

  //hold record of the nodes in the network
  String networkName;

  bool openLoadMenu; //tracks load menu open/closed
  bool openHelpMenu; //tracks help menu open/closed
  bool loadedNetwork =false; //keeps track if a network is loaded
                              //required due to nature of network loading
  bool teachModeStatus;
  bool notificationModeStatus;

  BayesianDAG DAGreference; //testing

    //Holds the notification we wish to push
  NetNotification newNotification= new NetNotification();

  //constructor
  AppComponent(this.notifications,this.styleService,this.selectionService,this.teachService) {
    print('Appcomponent created');
  }

  void ngOnInit() {
    print('Appcomponent Initiated');

    networkHolder = querySelector('#GraphHolder');
    //svg = new Selection('#GraphHolder').append("svg"); // svg file we draw on
    //uses d3 import in order to load this

    myNet = new Network(width, height,styleService,selectionService);
    myDAG = new BayesianDAG();

    setScreenDimensions();
    window.onResize.listen((_) => setScreenDimensions());

    networkName = 'Set Network Name';
    openLoadMenu = false;
    DAGreference=myDAG;

  overviewActive=true; //set the default card info to 'overview'
     //ensure we load all the lessons meta info from json
    teachService.fetchCourses();


  }

  void activateLoadMenu(){
    openLoadMenu = true;
    notifications.addHiddenNotification(new NetNotification()..setLoadMenuStatus(openLoadMenu));
  }

  void setScreenDimensions() {
    /*sets the SVG Dimensions*/
    print("set screen dimensions");

    width = networkHolder.contentEdge.width;
    height = networkHolder.contentEdge.height;
    /*svg
      ..attr["width"] = width.toString()
      ..attr["height"] = height.toString();*/

    myNet.setSize(width, height);
  }

  void setNetworkName(dynamic event) {
    myDAG.hasName=event.target.value;
    refreshNetName();
  }

  void refreshNetName() {
    networkName = ('Net Name: ' + myDAG.hasName);
    notifications.addHiddenNotification(new NetNotification()..setNewNetworkName());
  }

  void toggleTeaching() {
    if (teachModeStatus) {
      teachModeStatus = false;
      print('Teach Mode Disabled');
      styleService.setUiColours('normal');
      //set notifications
      notifications.addNotification(new NetNotification()..setTeachModeOff());
    }
    else {
      teachModeStatus = true;
      print('Teach Mode Enabled');
      styleService.setUiColours('teach');
      //set notifications
      notifications.addNotification(new NetNotification()..setTeachMode());
    }
  }

  void toggleNotifications(){
    if (notificationModeStatus) {
      notificationModeStatus = false;
      notifications.addHiddenNotification(new NetNotification()..setNotificationDisplayStatus(false));
    }
    else{
      notificationModeStatus = true;
      notifications.addHiddenNotification(new NetNotification()..setNotificationDisplayStatus(true));
    }
  }

  void viewOverview(){ //when user has selected a node in dropdown and presses button
    selectionService.setNodeSelection(currentNode);
    styleService.setNodeSelection(selectionService.selectedNode);
    notifications.addNotification(new NetNotification()..setNodeSelected());
  }

  //display the right cards
  void displayCard(String userSelection){
    switch (userSelection){
      case 'overview':
        if (!overviewActive){
          overviewActive=true;
          print('toggled overview card on');
          notifications.addHiddenNotification(new NetNotification()..setNodeDisplayMode("overview"));
          detailActive=false;
          editActive=false;
        }
        else{ //we must already be looking at overview, so toggle off
          overviewActive=false;
        }
        break;
      case 'detail':
        if (!detailActive){
          detailActive=true;
          print('toggled detail card on');
          notifications.addHiddenNotification(new NetNotification()..setNodeDisplayMode("details"));
          overviewActive=false;
          editActive=false;
        }
        else{ //we must already be looking at overview, so toggle off
          detailActive=false;
        }
        break;
      case 'edit':
        if (!editActive){
          editActive=true;
          print('toggled edit card on');
          notifications.addHiddenNotification(new NetNotification()..setNodeDisplayMode("edit"));
          detailActive=false;
          overviewActive=false;
        }
        else{ //we must already be looking at overview, so toggle off
          editActive=false;
        }
        break;
      default:
        overviewActive=false;
        detailActive=false;
        editActive=false;
    }
  }

  void refreshDAG(){
    DAGreference=myDAG;
  }

  void reset(){
    //clear behind the scene network and clear canvas
    myDAG.clear();
    myNet.reset();
    selectionService.resetSelection(); //ensure we have no more node selected
    //add notification that we reset the network
    notifications.addNotification(new NetNotification()..setResetStatus());
    loadedNetwork=false; //we have no longer loaded a network
  }

  void testJSON(){
    print('testing JSON...');
    var dson = new Dartson.JSON();
    String jsonString = dson.encode(myDAG);
    print(jsonString);
  }

/* TODO: wait until angular components implements this
  @ViewChild(MaterialSelectSearchboxComponent)
  MaterialSelectSearchboxComponent searchbox;

  //copied from angular components demo page
  void onDropdownVisibleChange(bool visible) {
    if (visible) {
      Timer.run(() {
        print('Searchbox Not yet implemented');
      });
    }
  }*/

}