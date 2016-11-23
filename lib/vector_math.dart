import 'dart:math';
//home brew solution for vector math
//perhaps look for a more robust pre-existing library to handle this later
//(for efficiency)

class Matrix2{

  List<List<double>> matrix;
  int rowCount;
  int columnCount;

  Matrix2(int rows, int columns){
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

  int getRowCount(){return rowCount;}

  int getColumnCount(){return columnCount;}

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
    if (vectorIn._size==columnCount) {
      Vector newVector = new Vector(rowCount);

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

class Vector{
  List<double> _vector; //holds the values of the vector

  // dimensionality of the vector (not to be confused with the length
  // of the vector. I should maybe consider refactoring terminology here)
  int _size;

  Vector(int size){
    this._vector = new List<double>(size);
    this._size=size;
  }

  setValues(List<double> newValues){ //if you wish to change values later on
    _vector = newValues;
  }

  int getSize(){
    return _size;
  }

  setAll(double desiredValue){
    _vector.fillRange(0,_vector.length,desiredValue);
  }

  double getLength(){
    double squaredsum = 0.0;
    for (int i=0; i< _size;i++){
      squaredsum += _vector[i]*_vector[i];
    }
    return sqrt(squaredsum);
  }

  double operator [](int i){
    return _vector[i];
  }

  void operator []=(int i, double v) {
    _vector[i] = v;
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

  scale(double scaleFactor){
    for(int i; i<_size;i++){
      _vector[i]=_vector[i]*scaleFactor;
    }
  }

  Vector multiplyPointswise(Vector vectorIn){
    if(vectorIn.getSize()==_size) {
      Vector newVector = new Vector(_size);
      for(int i=0; i< _size;i++){
        newVector[i]=_vector[i]*vectorIn[i];
      }
      return newVector;
    }
    throw new ArgumentError(vectorIn);
  }

  normalise(){
    double squaredsum = 0.0;
    for (int i=0; i< _size;i++){
      squaredsum += _vector[i]*_vector[i];
    }
    double factor = 1/sqrt(squaredsum);
    for (int i=0; i< _size;i++){
      _vector[i]=_vector[i]*factor;
    }
  }

  SumToOne(){
    double totalSum=0.0;
    double factor;
    for(var i=0;i<_size;i++ ){
      totalSum += _vector[i];
    }
    factor=1/totalSum;
    for(var i=0;i<_size;i++ ){
      _vector[i]=_vector[i]*factor;
    }
  }

  String toString(){
    StringBuffer Buffer = new StringBuffer();
    Buffer.write('[');
    for (int i =0; i < _size;i++){
      Buffer.write(_vector[i]);
      if (i+1!=_size){
        Buffer.write(' , ');
      }
    }
    Buffer.write(']');
    return Buffer.toString();
  }
}