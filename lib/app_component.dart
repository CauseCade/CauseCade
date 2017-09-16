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

import 'package:causecade/example_networks.dart';
import 'dart:html';

import 'node.dart';
import 'dart:async';

import 'package:d3/d3.dart';

//injectable imports
import  'notification_service.dart';
import 'network_style_service.dart';
import 'network_selection_service.dart';

List networkInfo = new List();
Network myNet;
BayesianDAG myDAG;

@Component(
    selector: 'causecade',
    templateUrl: 'app_component.html',
directives: const [NodeAdderComponent,materialDirectives,WelcomeComponent,CourseNavigatorComponent,OverviewComponent,DetailComponent,EditComponent],
providers: const [materialProviders,NotificationService,NetworkStyleService,NetworkSelectionService]
)
class AppComponent implements OnInit {

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
  List<node> NodeList;

  //hold record of the nodes in the network
  String networkName;

  bool openLoadMenu;
  bool teachModeStatus;
  bool notificationModeStatus;

  //user has teach mode on or off
  String loadMessage;


  //Holds the notification we wish to push
  NetNotification newNotification= new NetNotification();

  //constructor
  AppComponent(this.notifications,this.styleService,this.selectionService) {
    print('Appcomponent created');
  }

  void ngOnInit() {
    print('Appcomponent Initiated');

    networkHolder = querySelector('#GraphHolder');
    svg = new Selection('#GraphHolder').append("svg"); // svg file we draw on
    //uses d3 import in order to load this

    myNet = new Network(svg, width, height,styleService,selectionService);
    myDAG = new BayesianDAG();

    setScreenDimensions();
    window.onResize.listen((_) => setScreenDimensions());

    networkName = 'Set Network Name';
    NodeList = myDAG.NodeList; //fetch the current nodes in the network
    openLoadMenu = false;

    overviewActive=true; //set the default card info to 'overview'

  }

  //when the ''LOAD'' button is clicked
  loadData(String example_name) {
    //This function will get improved functionality in the future
    switch (example_name) {
      case "Animals":
        LoadExample_Animals();
        loadMessage = 'Last Loaded: ' + example_name;
        openLoadMenu = false;
        refreshNetName();
        notifications.addNotification(new NetNotification()..setLoadStatus());
        break;
      case "CarTest":
        LoadExample_CarStart();
        loadMessage = 'Last Loaded: ' + example_name;
        openLoadMenu = false;
        refreshNetName();
        notifications.addNotification(new NetNotification()..setLoadStatus());
        break;
      default:
        loadMessage = 'Sorry This is node a valid network';
    }
  }

  void setScreenDimensions() {
    /*sets the SVG Dimensions*/
    window.console.debug("set screen dimensions");

    width = networkHolder.contentEdge.width;
    height = networkHolder.contentEdge.height;

    svg
      ..attr["width"] = width.toString()
      ..attr["height"] = height.toString();

    myNet.setSize(width, height);
  }

  void setNetworkName(dynamic event) {
    myDAG.setName(event.target.value);
    refreshNetName();
  }

  void refreshNetName() {
    networkName = ('Net Name: ' +myDAG.getName());
  }

  void toggleTeaching() {
    if (teachModeStatus) {
      teachModeStatus = false;
      print('Teach Mode Disabled');
      updateColours('normal');
      //set notifications
      notifications.addNotification(new NetNotification()..setTeachModeOff());
    }
    else {
      teachModeStatus = true;
      print('Teach Mode Enabled');
      updateColours('teach');
      //set notifications
      notifications.addNotification(new NetNotification()..setTeachMode());
    }
  }

  void updateColours(String input){
    switch (input) {
      case 'normal':
    querySelectorAll('.themeColour').style.backgroundColor =  '#E91E63'; //Pink.
    querySelectorAll('.themeColourSecondary').style.backgroundColor = '#D81B60'; //darker pink;
        print('Colours: normal');
        break;
      case 'teach':
        querySelectorAll('.themeColour').style.backgroundColor = '#00BCD4'; //Blue

        querySelectorAll('.themeColourSecondary').style.backgroundColor = '#00ACC1'; //darker blue;
        print('Colours: teach');
        break;

    }
  }

  void toggleNotifications(){
    if (notificationModeStatus) {
      notificationModeStatus = false;
      print('Notification Menu Disabled');
    }
    else{
      notificationModeStatus = true;
      print('Notification Menu Enabled');
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


  // Dropdown (Node Search Dropdown)

  static final ItemRenderer<node> NodeRenderer =
      (HasUIDisplayName node) => node.uiDisplayName;

  final SelectionModel<node> nodeSearchSelection =
  new SelectionModel.withList();

  StringSelectionOptions<node> get nodeSearchOptions =>
      new StringSelectionOptions<node>(NodeList);

  String get nodeSearchLabel {
    if (nodeSearchSelection.selectedValues.length > 0) {
      currentNode = nodeSearchSelection.selectedValues.first;
      currentNodeName=currentNode.getName();
      return (nodeSearchSelection.selectedValues.first.uiDisplayName);
    }
    else {
      currentNode = null;
      currentNodeName=null;
      return 'Choose Node';
    }
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