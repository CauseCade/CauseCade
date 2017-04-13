import 'package:causecade/app_component.dart';
import 'package:causecade/vector_math.dart';
import 'package:causecade/data_converter.dart';



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
      TestMatrix2[0][1]=0.0;
      TestMatrix2[0][2]=1.0; //Penguin
      TestMatrix2[0][3]=0.9;
      TestMatrix2[0][4]=0.0; //Platypus
      TestMatrix2[0][5]=0.0;
      TestMatrix2[0][6]=1.0; //Rpbin
      TestMatrix2[0][7]=0.6;
      TestMatrix2[0][8]=0.0; //Turtle
      TestMatrix2[0][9]=0.0;

      TestMatrix2[1][0]=1.0;//
      TestMatrix2[1][1]=0.9;
      TestMatrix2[1][2]=0.0;//
      TestMatrix2[1][3]=0.1;
      TestMatrix2[1][4]=1.0;//
      TestMatrix2[1][5]=0.9;
      TestMatrix2[1][6]=0.0;//
      TestMatrix2[1][7]=0.4;
      TestMatrix2[1][8]=0.0;//
      TestMatrix2[1][9]=0.6;

      TestMatrix2[2][0]=0.0;//
      TestMatrix2[2][1]=0.1;
      TestMatrix2[2][2]=0.0;//
      TestMatrix2[2][3]=0.0;
      TestMatrix2[2][4]=0.0;//
      TestMatrix2[2][5]=0.1;
      TestMatrix2[2][6]=0.0;//
      TestMatrix2[2][7]=0.0;
      TestMatrix2[2][8]=1.0;//
      TestMatrix2[2][9]=0.4;
      myDAG.getNodes()[2].enterLinkMatrix(TestMatrix2);
      print(TestMatrix2.toString());


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


      Vector rootProb2 =new Vector(2);
      Vector rootProb =new Vector(5);
      rootProb2.setValues([1.0,0.0]);
      myDAG.setEvidence('Speed',rootProb2);
      rootProb.setValues([0.2,0.1,0.1,0.4,0.2]);
      myDAG.setPrior('Animal',rootProb);



      //print('--------------------------- STARTING UPDATES ----------------------');
      myDAG.checkNodes();
      myDAG.checkFlags();

      myDAG.updateNetwork();
      //print('<--  updated network  ->');
      //print(myDAG.toString());
      /*for (int i=0;i<2;i++){
    print(myDAG.getNodes()[2].getInComing().keys.elementAt(i).getName().toString());
  }*/

// Checking Multiple Parents

      myDAG.checkFlags();
      rootProb2.setValues([0.0,1.0]);
      myDAG.setEvidence('Speed',rootProb2);
      myDAG.checkFlags();
      //print('<--  updating network - TESTING MULTIPLE PARENTS ->');
      myDAG.updateNetwork();
      //print('<--  updated string - TESTING MULTIPLE PARENTS ->');
      //print(myDAG.toString());

// Checking Upwards Propagation (from bottom node)

      //print('<--  updating network - TESTING UPSTREAM INFERENCE ->');
      rootProb2.setValues([1.0,0.0]); //RESET SPEED NODE
      myDAG.setEvidence('Speed',rootProb2);
      Vector rootProb3 =new Vector(3);
      rootProb3.setValues([1.0,0.0,0.0]);
      myDAG.setEvidence('BodyCovering',rootProb3);

      myDAG.checkFlags();
      myDAG.updateNetwork();
      //print('<--  updated string - TESTING UPSTREAM INFERENCE ->');
      //print(myDAG.toString());

      // Checking Multiple Parents 2

      rootProb2.setValues([0.0,1.0]);
      myDAG.setEvidence('Speed',rootProb2);

      myDAG.updateNetwork();
     // print('<--  updated network - TESTING MULTIPLE PARENTS 2 ->');
     // print(myDAG.toString());

      rootProb3.setValues([0.0,0.0,1.0]);
      myDAG.setEvidence('BodyCovering',rootProb3);

      myDAG.updateNetwork();
     // print('<--  updated network - TESTING MULTIPLE PARENTS 3 ->');
     // print(myDAG.toString());

    //  print(myDAG.getNodes()[2].getMatrixLabels());
      // print(myDAG.getNodes()[2].getMatrixIndexes());
     // print(myDAG.getNodes()[2].getLinkMatrixInfo());
      myDAG.setName('Animals');
      visualiseNetwork();
  }

  LoadExample_CarStart(){
    myDAG.insertNode("Main fuse", 2); //0
    myDAG.insertNode("Battery age", 3); //1
    myDAG.insertNode("Alternator", 2); //2
    myDAG.insertNode("Charging system", 2); //3
    myDAG.insertNode("Headlights", 3); //4
    myDAG.insertNode("Battery voltage", 3); //5
    myDAG.insertNode("Voltage at plug", 3); //6
    myDAG.insertNode("Distributer", 2); //7
    myDAG.insertNode("Spark plugs", 3); //8
    myDAG.insertNode("Spark timing", 3); //9
    myDAG.insertNode("Spark quality", 3); //10
    myDAG.insertNode("Gas tank", 2); //11
    myDAG.insertNode("Air filter", 2); //12
    myDAG.insertNode("Gas filter", 2); //13
    myDAG.insertNode("Fuel system", 3); //14
    myDAG.insertNode("Air system", 2); //15
    myDAG.insertNode("Starter motor", 2); //16
    myDAG.insertNode("Starter system", 2); //17
    myDAG.insertNode("Car cranks", 2); //18
    myDAG.insertNode("Car starts", 2); //19

    myDAG.getNodes()[0].setStateLabels(['okay','blown']);
    myDAG.getNodes()[1].setStateLabels(['new','old','very old']);
    myDAG.getNodes()[2].setStateLabels(['okay','faulty']);
    myDAG.getNodes()[3].setStateLabels(['okay','faulty']);
    myDAG.getNodes()[4].setStateLabels(['bright','dim','off']);
    myDAG.getNodes()[5].setStateLabels(['strong','weak','dead']);
    myDAG.getNodes()[6].setStateLabels(['strong','weak','none']);
    myDAG.getNodes()[7].setStateLabels(['okay','faulty']);
    myDAG.getNodes()[8].setStateLabels(['okay','too wide','fouled']);
    myDAG.getNodes()[9].setStateLabels(['good','bad','very bad']);
    myDAG.getNodes()[10].setStateLabels(['good','bad','very bad']);
    myDAG.getNodes()[11].setStateLabels(['has gas','empty']);
    myDAG.getNodes()[12].setStateLabels(['clean','dirty']);
    myDAG.getNodes()[13].setStateLabels(['clean','dirty']);
    myDAG.getNodes()[14].setStateLabels(['good','poor', 'faulty']);
    myDAG.getNodes()[15].setStateLabels(['okay','faulty']);
    myDAG.getNodes()[16].setStateLabels(['okay','faulty']);
    myDAG.getNodes()[17].setStateLabels(['okay','faulty']);
    myDAG.getNodes()[18].setStateLabels(['true','false']);
    myDAG.getNodes()[19].setStateLabels(['true','false']);

    myDAG.insertLink(myDAG.getNodes()[0], myDAG.getNodes()[6]);
    myDAG.insertLink(myDAG.getNodes()[1], myDAG.getNodes()[5]);
    myDAG.insertLink(myDAG.getNodes()[2], myDAG.getNodes()[3]);
    myDAG.insertLink(myDAG.getNodes()[3], myDAG.getNodes()[5]);
    myDAG.insertLink(myDAG.getNodes()[5], myDAG.getNodes()[4]);
    myDAG.insertLink(myDAG.getNodes()[5], myDAG.getNodes()[6]);
    myDAG.insertLink(myDAG.getNodes()[7], myDAG.getNodes()[9]);
    myDAG.insertLink(myDAG.getNodes()[6], myDAG.getNodes()[10]);
    myDAG.insertLink(myDAG.getNodes()[8], myDAG.getNodes()[10]);
    myDAG.insertLink(myDAG.getNodes()[9], myDAG.getNodes()[19]);
    myDAG.insertLink(myDAG.getNodes()[10], myDAG.getNodes()[19]);
    myDAG.insertLink(myDAG.getNodes()[16], myDAG.getNodes()[17]);
    myDAG.insertLink(myDAG.getNodes()[17], myDAG.getNodes()[18]);
    myDAG.insertLink(myDAG.getNodes()[18], myDAG.getNodes()[19]);
    myDAG.insertLink(myDAG.getNodes()[11], myDAG.getNodes()[14]);
    myDAG.insertLink(myDAG.getNodes()[13], myDAG.getNodes()[14]);
    myDAG.insertLink(myDAG.getNodes()[12], myDAG.getNodes()[15]);
    myDAG.insertLink(myDAG.getNodes()[15], myDAG.getNodes()[19]);
    myDAG.insertLink(myDAG.getNodes()[14], myDAG.getNodes()[19]);

    if (myDAG.checkCyclic()) {
        print('this network is cyclic, dammit');
    }
    else {
        print('this network aint cyclic, cool!');
    }

    //battery voltage
    Matrix2 TestMatrix = new Matrix2(3,6); //2^1=2
    TestMatrix[0][0]=0.95;
    TestMatrix[0][1]=0.008;
    TestMatrix[0][2]=0.8;
    TestMatrix[0][3]=0.004;
    TestMatrix[0][4]=0.6;
    TestMatrix[0][5]=0.002;

    TestMatrix[1][0]=0.04;
    TestMatrix[1][1]=0.3;
    TestMatrix[1][2]=0.15;
    TestMatrix[1][3]=0.2;
    TestMatrix[1][4]=0.3;
    TestMatrix[1][5]=0.1;

    TestMatrix[2][0]=0.01;
    TestMatrix[2][1]=0.692;
    TestMatrix[2][2]=0.05;
    TestMatrix[2][3]=0.796;
    TestMatrix[2][4]=0.1;
    TestMatrix[2][5]=0.898;
    myDAG.getNodes()[5].enterLinkMatrix(TestMatrix);


    //charging system
    Matrix2 TestMatrix2 = new Matrix2(2,2); //2^1=2
    TestMatrix2[0][0]=0.5;
    TestMatrix2[0][1]=0.0;
    TestMatrix2[1][0]=0.5;
    TestMatrix2[1][1]=1.0;
    myDAG.getNodes()[3].enterLinkMatrix(TestMatrix2);

    //headlights
    Matrix2 TestMatrix3 = new Matrix2(3,3); //2^1=2
    TestMatrix3[0][0]=0.94;
    TestMatrix3[0][1]=0.0;
    TestMatrix3[0][2]=0.0;

    TestMatrix3[1][0]=0.01;
    TestMatrix3[1][1]=0.95;
    TestMatrix3[1][2]=0.0;

    TestMatrix3[2][0]=0.05;
    TestMatrix3[2][1]=0.05;
    TestMatrix3[2][2]=1.0;
    myDAG.getNodes()[4].enterLinkMatrix(TestMatrix3);

    //voltage at plugs
    Matrix2 TestMatrix4 = new Matrix2(3,6); //2^1=2
    TestMatrix4[0][0]=0.9;
    TestMatrix4[0][1]=0.0;
    TestMatrix4[0][2]=0.0;
    TestMatrix4[0][3]=0.0;
    TestMatrix4[0][4]=0.0;
    TestMatrix4[0][5]=0.0;

    TestMatrix4[1][0]=0.05;
    TestMatrix4[1][1]=0.9;
    TestMatrix4[1][2]=0.0;
    TestMatrix4[1][3]=0.0;
    TestMatrix4[1][4]=0.0;
    TestMatrix4[1][5]=0.0;

    TestMatrix4[2][0]=0.05;
    TestMatrix4[2][1]=0.1;
    TestMatrix4[2][2]=1.0;
    TestMatrix4[2][3]=1.0;
    TestMatrix4[2][4]=1.0;
    TestMatrix4[2][5]=1.0;
    myDAG.getNodes()[6].enterLinkMatrix(TestMatrix4);

    //spark timing
    Matrix2 TestMatrix5 = new Matrix2(3,2); //2^1=2
    TestMatrix5[0][0]=0.9;
    TestMatrix5[0][1]=0.2;

    TestMatrix5[1][0]=0.09;
    TestMatrix5[1][1]=0.30;

    TestMatrix5[2][0]=0.01;
    TestMatrix5[2][1]=0.50;
    myDAG.getNodes()[9].enterLinkMatrix(TestMatrix5);

    //starter system
    Matrix2 TestMatrix6 = new Matrix2(2,2); //2^1=2
    TestMatrix6[0][0]=0.98;
    TestMatrix6[0][1]=0.02;
    TestMatrix6[1][0]=0.02;
    TestMatrix6[1][1]=0.98;
    myDAG.getNodes()[17].enterLinkMatrix(TestMatrix6);

    //car cranks
    Matrix2 TestMatrix7 = new Matrix2(2,2); //2^1=2
    TestMatrix7[0][0]=0.8;
    TestMatrix7[0][1]=0.05;
    TestMatrix7[1][0]=0.2;
    TestMatrix7[1][1]=0.95;
    myDAG.getNodes()[18].enterLinkMatrix(TestMatrix7);

    //Air system
    Matrix2 TestMatrix8 = new Matrix2(2,2); //2^1=2
    TestMatrix8[0][0]=0.9;
    TestMatrix8[0][1]=0.3;
    TestMatrix8[1][0]=0.1;
    TestMatrix8[1][1]=0.7;
    myDAG.getNodes()[15].enterLinkMatrix(TestMatrix8);

    //Air system
    Matrix2 TestMatrix9 = new Matrix2(3,4); //2^1=2
    TestMatrix9[0][0]=0.9;
    TestMatrix9[0][1]=0.0;
    TestMatrix9[0][2]=0.0;
    TestMatrix9[0][3]=0.0;

    TestMatrix9[1][0]=0.07;
    TestMatrix9[1][1]=0.9;
    TestMatrix9[1][2]=0.0;
    TestMatrix9[1][3]=0.0;

    TestMatrix9[2][0]=0.03;
    TestMatrix9[2][1]=0.1;
    TestMatrix9[2][2]=1.0;
    TestMatrix9[2][3]=1.0;
    myDAG.getNodes()[14].enterLinkMatrix(TestMatrix9);

    //ASpark Quality
    Matrix2 TestMatrix10 = new Matrix2(3,9); //2^1=2
    TestMatrix10[0][0]=1.0;
    TestMatrix10[0][1]=0.0;
    TestMatrix10[0][2]=0.0;
    TestMatrix10[0][3]=0.0;
    TestMatrix10[0][4]=0.0;
    TestMatrix10[0][5]=0.0;
    TestMatrix10[0][6]=0.0;
    TestMatrix10[0][7]=0.0;
    TestMatrix10[0][8]=0.0;

    TestMatrix10[1][0]=0.0;
    TestMatrix10[1][1]=1.0;
    TestMatrix10[1][2]=0.0;
    TestMatrix10[1][3]=1.0;
    TestMatrix10[1][4]=0.0;
    TestMatrix10[1][5]=0.0;
    TestMatrix10[1][6]=1.0;
    TestMatrix10[1][7]=0.0;
    TestMatrix10[1][8]=0.0;

    TestMatrix10[2][0]=0.0;
    TestMatrix10[2][1]=0.0;
    TestMatrix10[2][2]=1.0;
    TestMatrix10[2][3]=0.0;
    TestMatrix10[2][4]=1.0;
    TestMatrix10[2][5]=1.0;
    TestMatrix10[2][6]=0.0;
    TestMatrix10[2][7]=1.0;
    TestMatrix10[2][8]=1.0;
    myDAG.getNodes()[10].enterLinkMatrix(TestMatrix10);

    //Car Starts
    Matrix2 TestMatrix11 = new Matrix2(2,108); //2^1=2
    TestMatrix11[0][0]=0.0;
    TestMatrix11[0][1]=0.0;
    TestMatrix11[0][2]=0.0;
    TestMatrix11[0][3]=0.0;
    TestMatrix11[0][4]=0.0;
    TestMatrix11[0][5]=0.0;
    TestMatrix11[0][6]=0.0;
    TestMatrix11[0][7]=0.0;
    TestMatrix11[0][8]=0.0;
    TestMatrix11[0][9]=0.0;
    TestMatrix11[0][10]=0.0;
    TestMatrix11[0][11]=0.0;
    TestMatrix11[0][12]=0.0;
    TestMatrix11[0][13]=0.0;
    TestMatrix11[0][14]=0.0;
    TestMatrix11[0][15]=0.0;
    TestMatrix11[0][16]=0.0;
    TestMatrix11[0][17]=0.0;
    TestMatrix11[0][18]=0.0;
    TestMatrix11[0][19]=0.0;
    TestMatrix11[0][20]=0.0;
    TestMatrix11[0][21]=0.0;
    TestMatrix11[0][22]=0.0;
    TestMatrix11[0][23]=0.0;
    TestMatrix11[0][24]=0.0;
    TestMatrix11[0][25]=0.0;
    TestMatrix11[0][26]=0.0;
    TestMatrix11[0][27]=0.0;
    TestMatrix11[0][28]=0.0;
    TestMatrix11[0][29]=0.0;
    TestMatrix11[0][30]=0.0;
    TestMatrix11[0][31]=0.0;
    TestMatrix11[0][32]=0.0;
    TestMatrix11[0][33]=0.0;
    TestMatrix11[0][34]=0.0;
    TestMatrix11[0][35]=0.0;
    TestMatrix11[0][36]=0.0;
    TestMatrix11[0][37]=0.0;
    TestMatrix11[0][38]=0.0;
    TestMatrix11[0][39]=0.0;
    TestMatrix11[0][40]=0.0;
    TestMatrix11[0][41]=0.0;
    TestMatrix11[0][42]=0.0;
    TestMatrix11[0][43]=0.0;
    TestMatrix11[0][44]=0.0;
    TestMatrix11[0][45]=0.0;
    TestMatrix11[0][46]=0.0;
    TestMatrix11[0][47]=0.0;
    TestMatrix11[0][48]=0.0;
    TestMatrix11[0][49]=0.0;
    TestMatrix11[0][50]=0.0;
    TestMatrix11[0][51]=0.0;
    TestMatrix11[0][52]=0.0;
    TestMatrix11[0][53]=0.0;
    TestMatrix11[0][54]=0.0;
    TestMatrix11[0][55]=0.0;
    TestMatrix11[0][56]=0.0;
    TestMatrix11[0][57]=0.0;
    TestMatrix11[0][58]=0.0;
    TestMatrix11[0][59]=0.0;
    TestMatrix11[0][60]=0.0;
    TestMatrix11[0][61]=0.0;
    TestMatrix11[0][62]=0.0;
    TestMatrix11[0][63]=0.0;
    TestMatrix11[0][64]=0.0;
    TestMatrix11[0][65]=0.0;
    TestMatrix11[0][66]=0.0;
    TestMatrix11[0][67]=0.0;
    TestMatrix11[0][68]=0.0;
    TestMatrix11[0][69]=0.0;
    TestMatrix11[0][70]=0.0;
    TestMatrix11[0][71]=0.0;
    TestMatrix11[0][72]=0.0;
    TestMatrix11[0][73]=0.0;
    TestMatrix11[0][74]=0.0;
    TestMatrix11[0][75]=0.0;
    TestMatrix11[0][76]=0.0;
    TestMatrix11[0][77]=0.0;
    TestMatrix11[0][78]=0.0;
    TestMatrix11[0][79]=0.0;
    TestMatrix11[0][80]=0.0;
    TestMatrix11[0][81]=0.0;
    TestMatrix11[0][82]=0.0;
    TestMatrix11[0][83]=0.0;
    TestMatrix11[0][84]=0.0;
    TestMatrix11[0][85]=0.0;
    TestMatrix11[0][86]=0.0;
    TestMatrix11[0][87]=0.0;
    TestMatrix11[0][88]=0.0;
    TestMatrix11[0][89]=0.0;
    TestMatrix11[0][90]=0.0;
    TestMatrix11[0][91]=0.0;
    TestMatrix11[0][92]=0.0;
    TestMatrix11[0][93]=0.0;
    TestMatrix11[0][94]=0.0;
    TestMatrix11[0][95]=0.0;
    TestMatrix11[0][96]=0.0;
    TestMatrix11[0][97]=0.0;
    TestMatrix11[0][98]=0.0;
    TestMatrix11[0][99]=0.0;
    TestMatrix11[0][100]=0.0;
    TestMatrix11[0][101]=0.0;
    TestMatrix11[0][102]=0.0;
    TestMatrix11[0][103]=0.0;
    TestMatrix11[0][104]=0.0;
    TestMatrix11[0][105]=0.0;
    TestMatrix11[0][106]=0.0;
    TestMatrix11[0][107]=0.0;

    TestMatrix11[1][0]=1.0;
    TestMatrix11[1][1]=1.0;
    TestMatrix11[1][2]=1.0;
    TestMatrix11[1][3]=1.0;
    TestMatrix11[1][4]=1.0;
    TestMatrix11[1][5]=1.0;
    TestMatrix11[1][6]=1.0;
    TestMatrix11[1][7]=1.0;
    TestMatrix11[1][8]=1.0;
    TestMatrix11[1][9]=1.0;
    TestMatrix11[1][10]=1.0;
    TestMatrix11[1][11]=1.0;
    TestMatrix11[1][12]=1.0;
    TestMatrix11[1][13]=1.0;
    TestMatrix11[1][14]=1.0;
    TestMatrix11[1][15]=1.0;
    TestMatrix11[1][16]=1.0;
    TestMatrix11[1][17]=1.0;
    TestMatrix11[1][18]=1.0;
    TestMatrix11[1][19]=1.0;
    TestMatrix11[1][20]=1.0;
    TestMatrix11[1][21]=1.0;
    TestMatrix11[1][22]=1.0;
    TestMatrix11[1][23]=1.0;
    TestMatrix11[1][24]=1.0;
    TestMatrix11[1][25]=1.0;
    TestMatrix11[1][26]=1.0;
    TestMatrix11[1][27]=1.0;
    TestMatrix11[1][28]=1.0;
    TestMatrix11[1][29]=1.0;
    TestMatrix11[1][30]=1.0;
    TestMatrix11[1][31]=1.0;
    TestMatrix11[1][32]=1.0;
    TestMatrix11[1][33]=1.0;
    TestMatrix11[1][34]=1.0;
    TestMatrix11[1][35]=1.0;
    TestMatrix11[1][36]=1.0;
    TestMatrix11[1][37]=1.0;
    TestMatrix11[1][38]=1.0;
    TestMatrix11[1][39]=1.0;
    TestMatrix11[1][40]=1.0;
    TestMatrix11[1][41]=1.0;
    TestMatrix11[1][42]=1.0;
    TestMatrix11[1][43]=1.0;
    TestMatrix11[1][44]=1.0;
    TestMatrix11[1][45]=1.0;
    TestMatrix11[1][46]=1.0;
    TestMatrix11[1][47]=1.0;
    TestMatrix11[1][48]=1.0;
    TestMatrix11[1][49]=1.0;
    TestMatrix11[1][50]=1.0;
    TestMatrix11[1][51]=1.0;
    TestMatrix11[1][52]=1.0;
    TestMatrix11[1][53]=1.0;
    TestMatrix11[1][54]=1.0;
    TestMatrix11[1][55]=1.0;
    TestMatrix11[1][56]=1.0;
    TestMatrix11[1][57]=1.0;
    TestMatrix11[1][58]=1.0;
    TestMatrix11[1][59]=1.0;
    TestMatrix11[1][60]=1.0;
    TestMatrix11[1][61]=1.0;
    TestMatrix11[1][62]=1.0;
    TestMatrix11[1][63]=1.0;
    TestMatrix11[1][64]=1.0;
    TestMatrix11[1][65]=1.0;
    TestMatrix11[1][66]=1.0;
    TestMatrix11[1][67]=1.0;
    TestMatrix11[1][68]=1.0;
    TestMatrix11[1][69]=1.0;
    TestMatrix11[1][70]=1.0;
    TestMatrix11[1][71]=1.0;
    TestMatrix11[1][72]=1.0;
    TestMatrix11[1][73]=1.0;
    TestMatrix11[1][74]=1.0;
    TestMatrix11[1][75]=1.0;
    TestMatrix11[1][76]=1.0;
    TestMatrix11[1][77]=1.0;
    TestMatrix11[1][78]=1.0;
    TestMatrix11[1][79]=1.0;
    TestMatrix11[1][80]=1.0;
    TestMatrix11[1][81]=1.0;
    TestMatrix11[1][82]=1.0;
    TestMatrix11[1][83]=1.0;
    TestMatrix11[1][84]=1.0;
    TestMatrix11[1][85]=1.0;
    TestMatrix11[1][86]=1.0;
    TestMatrix11[1][87]=1.0;
    TestMatrix11[1][88]=1.0;
    TestMatrix11[1][89]=1.0;
    TestMatrix11[1][90]=1.0;
    TestMatrix11[1][91]=1.0;
    TestMatrix11[1][92]=1.0;
    TestMatrix11[1][93]=1.0;
    TestMatrix11[1][94]=1.0;
    TestMatrix11[1][95]=1.0;
    TestMatrix11[1][96]=1.0;
    TestMatrix11[1][97]=1.0;
    TestMatrix11[1][98]=1.0;
    TestMatrix11[1][99]=1.0;
    TestMatrix11[1][100]=1.0;
    TestMatrix11[1][101]=1.0;
    TestMatrix11[1][102]=1.0;
    TestMatrix11[1][103]=1.0;
    TestMatrix11[1][104]=1.0;
    TestMatrix11[1][105]=1.0;
    TestMatrix11[1][106]=1.0;
    TestMatrix11[1][107]=1.0;
    myDAG.getNodes()[19].enterLinkMatrix(TestMatrix11);

    Vector rootProb = new Vector(2);
    rootProb.setValues([0.99,0.01]);
    myDAG.setPrior('Main fuse',rootProb);

    rootProb = new Vector(3);
    rootProb.setValues([0.4,0.4,0.2]);
    myDAG.setPrior('Battery age',rootProb);

    rootProb = new Vector(2);
    rootProb.setValues([0.997,0.003]);
    myDAG.setPrior('Alternator',rootProb);

    rootProb = new Vector(2);
    rootProb.setValues([0.99,0.01]);
    myDAG.setPrior('Distributer',rootProb);

    rootProb = new Vector(3);
    rootProb.setValues([0.7,0.1,0.2]);
    myDAG.setPrior('Spark plugs',rootProb);

    rootProb = new Vector(2);
    rootProb.setValues([0.995,0.005]);
    myDAG.setPrior('Starter motor',rootProb);

    rootProb = new Vector(2);
    rootProb.setValues([0.9,0.1]);
    myDAG.setPrior('Air filter',rootProb);

    rootProb = new Vector(2);
    rootProb.setValues([0.9,0.1]);
    myDAG.setPrior('Gas tank',rootProb);

    rootProb = new Vector(2);
    rootProb.setValues([0.97,0.03]);
    myDAG.setPrior('Gas filter',rootProb);

    myDAG.setName('Car Test');
    myDAG.updateNetwork();
    visualiseNetwork();
  }
