import 'dart:html';
import 'DataConverter.dart';

/*This file contains two classes:
 - ModalNodeAdder
 - ModalNodeEditor
 */

class ModalNodeAdder{
  final DivElement _content;
  final DivElement _title;
  final DivElement _maincontentNodeInfo;
  final DivElement _maincontentParent;
  final DivElement _maincontentTarget;
  final DivElement _buttonholder;
  final DivElement _inputDiv;

  final ButtonElement _cancelButton;
  final ButtonElement _addButton;
  final FormElement _nodeName;
  final InputElement _inputName;
  final LabelElement _labelName;

  List NodeIDS;
  List LinkParentIDS;
  List LinkTargetIDS;
  List Data;

  var linkInputTrackerTargets = 0; /*ensures link input are properly index in storage array*/
  var linkInputTrackerParents = 0; /*ensures link input are properly index in storage array*/

  //Constructor
  ModalNodeAdder() :
  //constructor pre-init
        _content = new DivElement(),
        _title = new DivElement(),
        _maincontentNodeInfo = new DivElement(),
        _maincontentParent = new DivElement(),
        _maincontentTarget = new DivElement(),
        _buttonholder = new DivElement(),
        _cancelButton = new ButtonElement(),
        _addButton = new ButtonElement(),

        _nodeName = new FormElement(),
        _inputDiv = new DivElement(),
        _inputName = new InputElement(),
        _labelName = new LabelElement(),

        NodeIDS = new List(1),
        LinkParentIDS = new List(),
        LinkTargetIDS = new List(),
        Data = new List(3)
  {
    //constructor body


    /*setting some styling*/
    _content.id = "modalContent";
    _content.classes.add("mdl-card");
    _content.classes.add("mdl-shadow--4dp");//set the class for CSS

    _title.classes.add("mdl-card__title");
    _title.classes.add('mdl-card__title-text');
    _title.text = ("Add a Node");
    _title.style.fontSize = "20px";
    _title.style.color = "#fafafa";
    _title.style.height = "100px";

    _title.style.background = '#E91E63';

    //handling input fields

    _maincontentNodeInfo.classes.add("mdl-card__supporting-text");
    _maincontentNodeInfo.children.add(_nodeName);
    _maincontentNodeInfo.text = ("Enter your New Node name below");

    _maincontentParent.classes.add("mdl-card__supporting-text");
    _maincontentParent.text = ("Enter Parent name below");
    _maincontentParent.style.borderTop = '1px solid rgba(0,0,0,.1)';

    _maincontentTarget.classes.add("mdl-card__supporting-text");
    _maincontentTarget.text = ("Enter Target name below");
    _maincontentTarget.style.borderTop = '1px solid rgba(0,0,0,.1)';

    /*styling buttons*/

    _buttonholder.classes.add('mdl-card__actions');
    _buttonholder.classes.add('mdl-card--border');

    _cancelButton.classes.add('mdl-button');
    _cancelButton.classes.add('mdl-js-button');
    _cancelButton.classes.add('mdl-js-ripple-effect');

    _addButton.classes.add('mdl-button');
    _addButton.classes.add('mdl-js-button');
    _addButton.classes.add('mdl-js-ripple-effect');

    /*styling forms*/
    _nodeName.children.add(_inputDiv);
    _inputDiv.classes.add("mdl-textfield");
    _inputDiv.classes.add("mdl-js-textfield");

      _inputName.classes.add("mdl-textfield__input");
      _inputName.id = ("nodeInputBox");
      _inputName.onChange.listen(setNodeName);
      _inputDiv.children.add(_inputName);

      _labelName.classes.add("mdl-textfield__label");
      _labelName.text = ("Enter node name...");
      _labelName.htmlFor = ("nodeInputBox");
      _inputDiv.children.add(_labelName);

    //Filling our card
    _content.append(_title);
    _content.append(_maincontentNodeInfo);
    _content.append(_maincontentParent);
    _content.append(_maincontentTarget);
    _content.append(_buttonholder);
    _maincontentNodeInfo.append(_nodeName);
    addParentInput();
    addTargetInput();

    //Handling Button behaviour
    _cancelButton.text = "Cancel";
    _cancelButton.onClick.listen((event) {
      hide();
    });

    _addButton.text = "Add";
    _addButton.onClick.listen((event) {
       returnData();
    });


    _buttonholder.append(_cancelButton);
    _buttonholder.append(_addButton);
  }

  setNodeName(Event e){ /*this is currently setup for debugging*/
    NodeIDS[0] = (_inputName.value);
    window.console.debug(NodeIDS);
  }

  setTargetName(inputIndex, inputValue){ /*this is currently setup for debugging*/
    LinkTargetIDS[inputIndex] = (inputValue);
    window.console.debug(LinkTargetIDS);
    linkInputTrackerTargets++; /*increases index by 1*/ /*currently means you cannot alter the value of this */
  }

  addTargetInput(){
    var newLinkElement = new DivElement();
    var newLinkButton = new ButtonElement();
    var newLinkInput = new FormElement();
    var newLinkDiv = new DivElement();
    var newTargetInput = new InputElement();
    var newTargetLabel = new LabelElement();
    LinkTargetIDS.add("placeholder"); /*ensures proper initialised values*/ /*FIX*/

    newLinkInput.style.display = ("inline-block");

    newLinkInput.children.add(newLinkDiv);
    newLinkDiv.classes.add("mdl-textfield");
    newLinkDiv.classes.add("mdl-js-textfield");

    newTargetInput.classes.add("mdl-textfield__input");
    newTargetInput.classes.add("linkInputBox");
    newTargetInput.onChange.listen((_) => setTargetName(linkInputTrackerTargets,newTargetInput.value));
    newLinkDiv.children.add(newTargetInput);

    newTargetLabel.classes.add("mdl-textfield__label");
    newTargetLabel.text = ("Enter target name...");
    newTargetLabel.htmlFor = ("nodeInputBox");
    newLinkDiv.children.add(newTargetLabel);

    newLinkButton.classes.add('mdl-button');
    newLinkButton.classes.add('mdl-js-button');
    newLinkButton.classes.add('mdl-js-ripple-effect');
    newLinkButton.style.display = ('inline-block');
    newLinkButton.text = ("Add Another target");
    newLinkButton.style.color = "rgba(0,0,0,.54)";
    newLinkButton.onClick.listen((event){
      window.console.debug(newTargetInput.value);
      if (newTargetInput.value != ''){
        addTargetInput();
        newLinkButton.remove();
      }
    });

    newLinkElement.append(newLinkInput);
    newLinkElement.append(newLinkButton);
    _maincontentTarget.append(newLinkElement);
  }

  setParentName(inputIndex, inputValue){ /*this is currently setup for debugging*/
    LinkParentIDS[inputIndex] = (inputValue);
    window.console.debug(LinkParentIDS);
    linkInputTrackerParents++; /*increases index by 1*/ /*currently means you cannot alter the value of this */
  }

  addParentInput(){
    var newLinkElement = new DivElement();
    var newLinkButton = new ButtonElement();
    var newLinkInput = new FormElement();
    var newLinkDiv = new DivElement();
    var newTargetInput = new InputElement();
    var newTargetLabel = new LabelElement();
    LinkParentIDS.add("placeholder"); /*ensures proper initialised values*/ /*FIX*/

    newLinkInput.style.display = ("inline-block");

    newLinkInput.children.add(newLinkDiv);
    newLinkDiv.classes.add("mdl-textfield");
    newLinkDiv.classes.add("mdl-js-textfield");

    newTargetInput.classes.add("mdl-textfield__input");
    newTargetInput.classes.add("linkInputBox");
    newTargetInput.onChange.listen((_) => setParentName(linkInputTrackerParents,newTargetInput.value));
    newLinkDiv.children.add(newTargetInput);

    newTargetLabel.classes.add("mdl-textfield__label");
    newTargetLabel.text = ("Enter parent name...");
    newTargetLabel.htmlFor = ("nodeInputBox");
    newLinkDiv.children.add(newTargetLabel);

    newLinkButton.classes.add('mdl-button');
    newLinkButton.classes.add('mdl-js-button');
    newLinkButton.classes.add('mdl-js-ripple-effect');
    newLinkButton.style.display = ('inline-block');
    newLinkButton.text = ("Add Another parent");
    newLinkButton.style.color = "rgba(0,0,0,.54)";
    newLinkButton.onClick.listen((event){
      window.console.debug(newTargetInput.value);
      if (newTargetInput.value != ''){
        addParentInput();
        newLinkButton.remove();
      }
    });

    newLinkElement.append(newLinkInput);
    newLinkElement.append(newLinkButton);
    _maincontentParent.append(newLinkElement);
  }

  returnData(){
    Data[0]=(NodeIDS);
    Data[1]=(LinkParentIDS);
    Data[2]=(LinkTargetIDS);
    window.console.debug(Data);
    Implement(Data);
    hide();
  }

  //remove the modal dialog div's from the dom.
  hide() {
        _content.remove();
  }
  //add the modal dialog div's to the dom
  show() {

    document.body.append(_content);
  }
}

class ModalNodeEditor {
  /*WIP*/
}








