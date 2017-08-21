import 'package:angular2/core.dart';
import 'node.dart';
import 'link.dart';
import  'lesson.dart';
import 'package:causecade/vector_math.dart';

@Injectable()

class NotificationService {
  List<NetNotification> notificationList = new List<NetNotification>();

  List<NetNotification> get notifications => notificationList;

  void addNotification(NetNotification newNotification){
    notificationList.add(newNotification);
    print('NotificationService: new added: ' + newNotification.text);
   /* StringBuffer kappa = new StringBuffer();
    notificationList.forEach((notification){
      kappa.write(notification.text);
    });
    print('NotificationService: ' + kappa.toString());*/
  }

  void clear(){
    notificationList.clear();
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
    notificationText = 'Loaded Network';
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

}