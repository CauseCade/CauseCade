import 'dart:html';

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
  final _NodeIDS;
  final _LinkIDS;

  //Constructor
  ModalNodeAdder() :
  //constructor pre-init
        _content = new DivElement(),
        _title = new DivElement(),
        _maincontent = new DivElement(),
        _buttonholder = new DivElement(),
        _inputDiv = new DivElement(),
        _cancelButton = new ButtonElement(),
        _addButton = new ButtonElement(),
        _nodeName = new FormElement(),
        _inputName = new InputElement(),
        _labelName = new LabelElement(),
        _NodeIDS = new List(),
        _LinkIDS = new List()
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
      _inputName.onChange.listen(returnNodeName);
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

    //Handling Button behaviour
    _cancelButton.text = "Cancel";
    _cancelButton.onClick.listen((event) {
      hide();
    });

    _addButton.text = "Add";
    _cancelButton.onClick.listen((event) {
     /* addNode()*/; /*needs to have method that adds new node*/
    });


    _buttonholder.append(_cancelButton);
    _buttonholder.append(_addButton);
  }

  returnNodeName(Event e){ /*this is currently setup for debugging*/
    _NodeIDS.add(_inputName.value);
    window.console.debug(_NodeIDS);
  }

  addLinkInput(){
    /*will add another LinkInputForm to the Modal*/
    /*WIP*/
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








