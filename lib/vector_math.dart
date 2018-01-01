import 'dart:math';
import 'package:dartson/dartson.dart'; //to convert to JSON
//home brew solution for vector math
//perhaps look for a more robust pre-existing library to handle this later
//(for efficiency)

@Entity()
class Matrix2{

  List<List<double>> matrix;
  int rowCount;
  int columnCount;

  Matrix2(); //constructor - dont forget to call initialisematrix

  int getRowCount(){return rowCount;}

  int getColumnCount(){return columnCount;}

  List<List<double>> get currentMatrix => matrix;

  set currentMatrix(List<List<double>> matrixIn) => matrix;


  void initialiseMatrix(int rows, int columns){
    rowCount= rows;
    columnCount = columns;
    this.matrix = new List<List<double>>(rows);

    for (var i = 0; i < rows; i++) {
      List<double> list = new List<double>(columns);
      for (var j = 0; j < columns; j++) {
        list[j] = 0.0+0.1*j+i;
      }
      matrix[i] = list;
    }
  }

  List<double> operator [](int i){
    return matrix[i];
  }

  operator *(dynamic arg) {
    if (arg is double) {
      return scale(arg);
    }
    if (arg is Vector) {
      return transform(arg);
    }
    throw new ArgumentError(arg);
  }

  // this method needs to be fixed, to see whether a copy or a change
  // to the original matrix has to be changed //FIX
  scale(double scalingFactor){
    for(int i=0; i < rowCount; i++){
      for(int j=0; j < columnCount; j++){
        matrix[i][j]=matrix[i][j]*scalingFactor;
      }
    }
  }

  Vector transform(Vector vectorIn){
    if (vectorIn.size==columnCount) {
      Vector newVector = new Vector();
      newVector.initialiseVector(rowCount);

      for(int i =0; i<rowCount;i++){
        newVector[i]=0.0;
        for(int j=0; j< columnCount;j++){
          newVector[i]+=matrix[i][j]*vectorIn[j];
        }
      }
      return newVector;
    }
    throw new ArgumentError(vectorIn);
  } //FIX

  identity(){ //should only be called for root nodes and upon initialisation
    for(var i =0; i<rowCount;i++){
      for(var j=0; j<columnCount;j++){
        if(i==j){
          matrix[i][j]=1.0;
        }
        else{
          matrix[i][j]=0.0;
        }
      }
    }
  }

  String toString(){
    StringBuffer Buffer = new StringBuffer();
    Buffer.write('Matrix2 with ' + rowCount.toString() + ' rows and ' +
        columnCount.toString() + ' columns \n');
    for (var i =0;i < rowCount; i++) {
      Buffer.write('[');
      for (var j=0; j < columnCount; j++){
        Buffer.write(matrix[i][j].toString());
        if (j+1!=columnCount){
          Buffer.write(' , ');
        }
      }
      Buffer.write(']\n');
    }
    return Buffer.toString();
  }

}

@Entity()
class Vector{
  List<double> vector; //holds the values of the vector

  // dimensionality of the vector (not to be confused with the length
  // of the vector. I should maybe consider refactoring terminology here)
  int size;

  Vector(); // constructor

  void initialiseVector(int size){
    this.vector = new List<double>(size);
    this.size=size;
  }

  void setValues(List<double> newValues){ //if you wish to change values later on
    vector = newValues;
  }

  int getSize(){
    return size;
  }

  void setAll(double desiredValue){
    vector.fillRange(0,vector.length,desiredValue);
  }

  double getLength(){
    double squaredsum = 0.0;
    for (int i=0; i< size;i++){
      squaredsum += vector[i]*vector[i];
    }
    return sqrt(squaredsum);
  }

  double operator [](int i){
    return vector[i];
  }

  void operator []=(int i, double v) {
    vector[i] = v;
  }

  operator *(dynamic arg) {
    if (arg is double) {
      return scale(arg);
    }
    if (arg is Vector) {
      return multiplyPointswise(arg);
    }
    throw new ArgumentError(arg);
  }

  void scale(double scaleFactor){
    for(int i; i<size;i++){
      vector[i]=vector[i]*scaleFactor;
    }
  }

  Vector multiplyPointswise(Vector vectorIn){
    if(vectorIn.getSize()==size) {
      Vector newVector = new Vector();
      newVector.initialiseVector(size);
      for(int i=0; i< size;i++){
        newVector[i]=vector[i]*vectorIn[i];
      }
      return newVector;
    }
    throw new ArgumentError(vectorIn);
  }

  void normalise(){
    double squaredsum = 0.0;
    for (int i=0; i< size;i++){
      squaredsum += vector[i]*vector[i];
    }
    double factor = 1/sqrt(squaredsum);
    for (int i=0; i< size;i++){
      vector[i]=vector[i]*factor;
    }
  }

  void SumToOne(){
    double totalSum=0.0;
    double factor;
    for(var i=0;i<size;i++ ){
      totalSum += vector[i];
    }
    factor=1/totalSum;
    for(var i=0;i<size;i++ ){
      vector[i]=vector[i]*factor;
    }
  }

  String toString(){
    StringBuffer Buffer = new StringBuffer();
    Buffer.write('[');
    for (int i =0; i < size;i++){
      Buffer.write(vector[i]);
      if (i+1!=size){
        Buffer.write(' , ');
      }
    }
    Buffer.write(']');
    return Buffer.toString();
  }
}