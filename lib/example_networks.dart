import 'package:causecade/network_interface.dart';
import 'package:causecade/vector_math.dart';



  LoadExample_Animals(){
    myDAG.insertNode("Animal", 5);
    // myDAG.getNodes()[0].enterUnconditionalProbability(0.99,0.01);
    //print(myDAG.numNodes());
    myDAG.insertNode("Environment", 3);
    //myDAG.getNodes()[1].enterUnconditionalProbability(0.8,0.2);
    // print(myDAG.numNodes());
    myDAG.insertNode("Class", 3);
    // myDAG.getNodes()[2].enterUnconditionalProbability(0.7,0.3);
    myDAG.insertNode("HasSHell", 2);
    //print(myDAG.numNodes());
    myDAG.insertNode('BearsYoungAs', 2);
    // myDAG.getNodes()[4].enterUnconditionalProbability(0.4,0.6);

    myDAG.insertNode('WarmBlooded', 2);
    myDAG.insertNode('BodyCovering', 3);
    myDAG.insertNode('Speed', 2);

    myDAG.insertLink(myDAG.getNodes()[0], myDAG.getNodes()[1]);
    myDAG.insertLink(myDAG.getNodes()[7], myDAG.getNodes()[2]);
    myDAG.insertLink(myDAG.getNodes()[0], myDAG.getNodes()[2]);
    myDAG.insertLink(myDAG.getNodes()[0], myDAG.getNodes()[3]);
    myDAG.insertLink(myDAG.getNodes()[0], myDAG.getNodes()[4]);
    myDAG.insertLink(myDAG.getNodes()[2], myDAG.getNodes()[5]);
    myDAG.insertLink(myDAG.getNodes()[2], myDAG.getNodes()[6]);

    //a tester  - uncommenting will make this cyclic
    // myDAG.insertLink(myDAG.getNodes()[5],myDAG.getNodes()[2]);

    print('                 tester Cyclic - 1');

    if (myDAG.checkCyclic()) {
      print('this network is cyclic, dammit');
    }
    else {
      print('this network aint cyclic, cool!');
    }

    //print(myDAG.getNodes()[5].getLinkMatrixInfo());


    myDAG.getNodes()[0].setStateLabels(['monkey','penguin','platypus','robin','turtle']);
    myDAG.getNodes()[1].setStateLabels(['air','land','water']);
    myDAG.getNodes()[2].setStateLabels(['bird','mammal','reptile']);
    myDAG.getNodes()[3].setStateLabels(['true','false']);
    myDAG.getNodes()[4].setStateLabels(['live','egg']);
    myDAG.getNodes()[5].setStateLabels(['true','false']);
    myDAG.getNodes()[6].setStateLabels(['fur','feathers','scales']);
    myDAG.getNodes()[7].setStateLabels(['Fast','Slow']);


    Matrix2 TestMatrix = new Matrix2(3,5); //2^1=2
    TestMatrix[0][0]=0.0;
    TestMatrix[0][1]=0.0;
    TestMatrix[0][2]=0.0;
    TestMatrix[0][3]=0.5;
    TestMatrix[0][4]=0.0;

    TestMatrix[1][0]=1.0;
    TestMatrix[1][1]=0.5;
    TestMatrix[1][2]=0.0;
    TestMatrix[1][3]=0.5;
    TestMatrix[1][4]=0.5;

    TestMatrix[2][0]=0.0;
    TestMatrix[2][1]=0.5;
    TestMatrix[2][2]=1.0;
    TestMatrix[2][3]=0.0;
    TestMatrix[2][4]=0.5;
    myDAG.getNodes()[1].enterLinkMatrix(TestMatrix);



    Matrix2 TestMatrix2 = new Matrix2(3,10); //2^1=2
    TestMatrix2[0][0]=0.0; //Monkey
    TestMatrix2[0][1]=1.0;
    TestMatrix2[0][2]=0.0; //Penguin
    TestMatrix2[0][3]=1.0;
    TestMatrix2[0][4]=0.0; //Platypus
    TestMatrix2[0][5]=0.0;
    TestMatrix2[0][6]=0.9; //Rpbin
    TestMatrix2[0][7]=0.0;
    TestMatrix2[0][8]=0.6; //Turtle
    TestMatrix2[0][9]=0.0;

    TestMatrix2[1][0]=1.0;
    TestMatrix2[1][1]=0.0;
    TestMatrix2[1][2]=1.0;
    TestMatrix2[1][3]=0.0;
    TestMatrix2[1][4]=0.0;
    TestMatrix2[1][5]=0.9;
    TestMatrix2[1][6]=0.1;
    TestMatrix2[1][7]=0.9;
    TestMatrix2[1][8]=0.4;
    TestMatrix2[1][9]=0.6;

    TestMatrix2[2][0]=0.0;
    TestMatrix2[2][1]=0.0;
    TestMatrix2[2][2]=0.0;
    TestMatrix2[2][3]=0.0;
    TestMatrix2[2][4]=1.0;
    TestMatrix2[2][5]=0.1;
    TestMatrix2[2][6]=0.0;
    TestMatrix2[2][7]=0.1;
    TestMatrix2[2][8]=0.0;
    TestMatrix2[2][9]=0.4;
    myDAG.getNodes()[2].enterLinkMatrix(TestMatrix2);


    Matrix2 TestMatrix3 = new Matrix2(2,5); //2^1=2
    TestMatrix3[0][0]=0.0;
    TestMatrix3[0][1]=0.0;
    TestMatrix3[0][2]=0.0;
    TestMatrix3[0][3]=0.0;
    TestMatrix3[0][4]=1.0;

    TestMatrix3[1][0]=1.0;
    TestMatrix3[1][1]=1.0;
    TestMatrix3[1][2]=1.0;
    TestMatrix3[1][3]=1.0;
    TestMatrix3[1][4]=0.0;
    myDAG.getNodes()[3].enterLinkMatrix(TestMatrix3);

    Matrix2 TestMatrix4 = new Matrix2(2,5); //2^1=2
    TestMatrix4[0][0]=1.0;
    TestMatrix4[0][1]=0.0;
    TestMatrix4[0][2]=0.0;
    TestMatrix4[0][3]=0.0;
    TestMatrix4[0][4]=0.0;

    TestMatrix4[1][0]=0.0;
    TestMatrix4[1][1]=1.0;
    TestMatrix4[1][2]=1.0;
    TestMatrix4[1][3]=1.0;
    TestMatrix4[1][4]=1.0;
    myDAG.getNodes()[4].enterLinkMatrix(TestMatrix4);

    Matrix2 TestMatrix5 = new Matrix2(2,3); //2^1=2
    TestMatrix5[0][0]=1.0;
    TestMatrix5[0][1]=1.0;
    TestMatrix5[0][2]=0.0;

    TestMatrix5[1][0]=0.0;
    TestMatrix5[1][1]=0.0;
    TestMatrix5[1][2]=1.0;
    myDAG.getNodes()[5].enterLinkMatrix(TestMatrix5);

    Matrix2 TestMatrix6 = new Matrix2(3,3); //2^1=2
    TestMatrix6[0][0]=0.0; //true given input = true
    TestMatrix6[0][1]=1.0; //false given input = true
    TestMatrix6[0][2]=0.0; //true given input = false

    TestMatrix6[1][0]=1.0; //true given input = true
    TestMatrix6[1][1]=0.0; //false given input = true
    TestMatrix6[1][2]=0.0; //true given input = false

    TestMatrix6[2][0]=0.0; //true given input = true
    TestMatrix6[2][1]=0.0; //false given input = true
    TestMatrix6[2][2]=1.0; //true given input = false
    myDAG.getNodes()[6].enterLinkMatrix(TestMatrix6);



    Vector rootProb =new Vector(5);
    rootProb.setValues([0.2,0.1,0.1,0.4,0.2]);
    myDAG.setPrior('Animal',rootProb);
    Vector rootProb2 =new Vector(2);
    rootProb2.setValues([1.0,0.0]);
    myDAG.setEvidence('Speed',rootProb2);


    myDAG.checkNodes();

    myDAG.updateNetwork();
    print('<--  updated network  ->');
    print(myDAG.toString());
  }


