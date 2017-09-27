import 'package:angular2/core.dart';
import 'node.dart';
import 'link.dart';
import  'lesson.dart';
import 'package:causecade/vector_math.dart';

@Injectable()

class NotificationService {
  List<NetNotification> notificationList = new List<NetNotification>();
  List<NetNotification> hiddenNotificationList = new List<NetNotification>();
  int notificationCountLimit = 20; //how many notifications do we allow

  List<NetNotification> get notifications => notificationList;

  List<NetNotification> get hiddenNotifications => hiddenNotificationList;

  void addNotification(NetNotification newNotification){
    notificationList.add(newNotification);
    addHiddenNotification(newNotification);// also add to hidden

    //print('NotificationService: new added: ' + newNotification.text);
    //avoid list from growing too far.
    if (notificationList.length>notificationCountLimit){
      notificationList.removeAt(0); //clear oldest item
      print(notificationList.length.toString() + 'length visible'); //debugging
    }
  }

  void addHiddenNotification(NetNotification newNotification){
    hiddenNotificationList.add(newNotification);
    //avoid list from growing too far.
    if (hiddenNotificationList.length>notificationCountLimit){
      hiddenNotificationList.removeAt(0); //clear oldest item
      print(hiddenNotificationList.length.toString() + 'length hidden'); //debugging
    }
  }

  void clear(){
    notificationList.clear();
    hiddenNotificationList.clear();
    print('NotificationService: cleared notifications');
  }

  void removeNotification(NetNotification notification){
    print('NotificationService: removed: ' + notification.text);
    notificationList.remove(notification);
  }

}

class NetNotification { //holds all possible notifications;

  String notificationText;
  String notificationDetails;

  NetNotification();

  String get text => notificationText;

  void setTeachMode() {
    notificationText = 'Teach mode on';
  }

  void setTeachModeOff() {
    notificationText = 'Teach mode off';
  }

  void setNodeSelected([node nodeIn]){
    notificationText = 'Selected Node';
  }

  void setUpdateNodeName([node nodeIn, String newName]) {
    notificationText = 'Set node name';
  }

  void setUpdateNodeLabels([node nodeIn, List<String> newLabels]) {
    notificationText = 'Set node labels';
  }

  void setUpdateNodeLinks([node nodeIn, List<node> newNodesLinked, String descriptor]){
    notificationText = 'Added node links';
  }

  void setRemoveNodeLinks([node nodeIn, List<node> newNodesLinked, String descriptor]){
    notificationText = 'Removed node links';
  }

  void setNodeMultiplicity([node nodeIn,int newMultiplicity]){
    notificationText = 'Set Node States';
  }

  void setNodeMatrix([node nodeIn]){
    notificationText = 'Set LinkMatrix';
  }

  void setLoadStatus([String netName]){
    netName!=null ? notificationText = "Loaded Network:"+netName:
    notificationText = "Loaded Network";
  }

  void setSaveStatus([String netName]){
    notificationText = 'Saved Network';
  }

  void setResetStatus([int removedNodeCount,int removedLinkCount]){
    notificationText = 'Reset Network';
  }

  void setNewNode([node newNode,Map<node,link> nodeOutgoing,Map<node,link> nodeIncoming]){
    notificationText = 'Added node';
  }

  void setNodeEvidence([Vector newEvidence]){
    notificationText = 'Set node observation';
  }

  void clearNodeEvidence([node nodeIn]){
    notificationText = 'Clear node observation';
  }

  void setNodePrior([Vector newPrior]){
    notificationText = 'Set node prior';
  }

  void clearNodPrior([node nodeIn]){
    notificationText = 'Clear node prior';
  }

  //Lesson Related

  void setLessonSelection([Lesson LessonIn]){
    notificationText = 'Loaded Lesson';
  }

  //hidden only (should only be used for hidden
  void setNodeDisplayMode([String mode]){
    mode!=null ? notificationText = "set node display:"+mode:
    notificationText = "set node display";
    print(notificationText);
  }

  void setNotificationDisplayStatus([bool active]){
    active!=null ? notificationText="notifications:"+active.toString() :
      notificationText = "notifications:toggled";
  }

  void setNewNetworkName([String newName]){
    newName!=null ? notificationText="newNetworkName:"+newName.toString() :
    notificationText = "newNetworkName:modified";
  }

  void setLoadMenuStatus([bool loadMenuStatus]){
    loadMenuStatus!=null ? notificationText="load menu active:"+loadMenuStatus.toString() :
    notificationText = "load menu active:changed";
  }

  void setNodeSelectedDetail(String nodeIn){
    notificationText ="node selected:"+nodeIn;
  }

  void setNodeAdderMenuStatus([bool active]){
    active!=null ? notificationText="nodeAdder:"+active.toString() :
    notificationText = "nodeAdder:toggled";
  }

}