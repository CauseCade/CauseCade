import 'dart:html';
import 'DataConverter.dart';

/*This file contains two classes:
 - ModalNodeAdder
 - ModalNodeEditor
 */

class ModalNodeAdder{
  final DivElement _content;
  final DivElement _title;
  final DivElement _maincontent;
  final DivElement _buttonholder;
  final DivElement _inputDiv;
  final ButtonElement _cancelButton;
  final ButtonElement _addButton;
  final FormElement _nodeName;
  final InputElement _inputName;
  final LabelElement _labelName;
  List NodeIDS;
  List LinkIDS;
  List Data;
  var linkInputTracker = 0; /*ensures link input are properly index in storage array*/

  //Constructor
  ModalNodeAdder() :
  //constructor pre-init
        _content = new DivElement(),
        _title = new DivElement(),
        _maincontent = new DivElement(),
        _buttonholder = new DivElement(),
        _cancelButton = new ButtonElement(),
        _addButton = new ButtonElement(),

        _nodeName = new FormElement(),
        _inputDiv = new DivElement(),
        _inputName = new InputElement(),
        _labelName = new LabelElement(),

        NodeIDS = new List(1),
        LinkIDS = new List(),
        Data = new List(2)
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

    _maincontent.classes.add("mdl-card__supporting-text");
    _maincontent.children.add(_nodeName);
    _maincontent.text = ("Enter Node details below");

    _buttonholder.classes.add('mdl-card__actions');
    _buttonholder.classes.add('mdl-card--border');

    /*styling buttons*/
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
    _content.append(_maincontent);
    _content.append(_buttonholder);
    _maincontent.append(_nodeName);
    addLinkInput();

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

  setLinkName(inputIndex, inputValue){ /*this is currently setup for debugging*/
    LinkIDS[inputIndex] = (inputValue);
    window.console.debug(LinkIDS);
    linkInputTracker++; /*increases index by 1*/ /*currently means you cannot alter the value of this */
  }

  addLinkInput(){
    var newLinkElement = new DivElement();
    var newLinkButton = new ButtonElement();
    var newLinkInput = new FormElement();
    var newLinkDiv = new DivElement();
    var newTargetInput = new InputElement();
    var newTargetLabel = new LabelElement();
    LinkIDS.add("placeholder"); /*ensures proper initialised values*/ /*FIX*/

    newLinkInput.style.display = ("inline-block");

    newLinkInput.children.add(newLinkDiv);
    newLinkDiv.classes.add("mdl-textfield");
    newLinkDiv.classes.add("mdl-js-textfield");

    newTargetInput.classes.add("mdl-textfield__input");
    newTargetInput.classes.add("linkInputBox");
    newTargetInput.onChange.listen((_) => setLinkName(linkInputTracker,newTargetInput.value));
    newLinkDiv.children.add(newTargetInput);

    newTargetLabel.classes.add("mdl-textfield__label");
    newTargetLabel.text = ("Enter target name...");
    newTargetLabel.htmlFor = ("nodeInputBox");
    newLinkDiv.children.add(newTargetLabel);

    newLinkButton.classes.add('mdl-button');
    newLinkButton.classes.add('mdl-js-button');
    newLinkButton.classes.add('mdl-js-ripple-effect');
    newLinkButton.style.display = ('inline-block');
    newLinkButton.text = ("Add Another Target");
    newLinkButton.style.color = "rgba(0,0,0,.54)";
    newLinkButton.onClick.listen((event){
      window.console.debug(newTargetInput.value);
      if (newTargetInput.value != ''){
        addLinkInput();
        newLinkButton.remove();
      }
    });

    newLinkElement.append(newLinkInput);
    newLinkElement.append(newLinkButton);
    _maincontent.append(newLinkElement);
  }

  returnData(){
    Data[0]=(NodeIDS);
    Data[1]=(LinkIDS);
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








