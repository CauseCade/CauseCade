import 'dart:math';
//home brew solution for vector math
//perhaps look for a more robust pre-existing library to handle this later (for efficiency)
//TODO: implement linear operations (matrix multiplication etc)

class Matrix2{

  List<List<double>> matrixInternal;
  int rowCount;
  int columnCount;

  Matrix2(int rows, int columns){
    rowCount= rows;
    columnCount = columns;
    List<List<double>> matrix = new List<List<double>>(rows);

    for (var i = 0; i < rows; i++) {
      List<double> list = new List<double>(columns);
      for (var j = 0; j < columns; j++) {
        list[j] = 0.0+0.1*j+i;
      }
      matrix[i] = list;
    }
    matrixInternal = matrix;
  }

  List<double> operator [](int i){
    return matrixInternal [i];
  }

  String toString(){
    StringBuffer Buffer = new StringBuffer();
    Buffer.write('Matrix2 with ' + rowCount.toString() + ' rows and ' + columnCount.toString() + ' columns \n');
    for (var i =0;i < rowCount; i++) {
      Buffer.write('[');
      for (var j=0; j < columnCount; j++){
        Buffer.write(matrixInternal[i][j].toString());
        if (j+1!=columnCount){
          Buffer.write(' , ');
        }
      }
      Buffer.write(']\n');
    }
    return Buffer.toString();
  }

}

class Vector2{

  List<double> vectorInternal;
  int length = 2;

  Vector2(double entry1, double entry2){
    List<double> vector = new List<double>(2);
    vector[0]=entry1;
    vector[1]=entry2;
    vectorInternal = vector;
  }

  double operator [](int i){
    return vectorInternal[i];
  }

  void operator []=(int i, double v) {
    vectorInternal[i] = v;
  }

  normalise(){
    double squaredsum = 0.0;
    for (int i=0; i< length;i++){
      squaredsum += vectorInternal[i]*vectorInternal[i];
    }
    double factor = 1/sqrt(squaredsum);
    for (int i=0; i< length;i++){
      vectorInternal[i]=vectorInternal[i]*factor;
    }
  }

  double getSize(){
    double squaredsum = 0.0;
    for (int i=0; i< length;i++){
      squaredsum += vectorInternal[i]*vectorInternal[i];
    }
    return sqrt(squaredsum);
  }

  String toString(){
    StringBuffer Buffer = new StringBuffer();
    Buffer.write('[');
    for (int i =0; i < length;i++){
      Buffer.write(vectorInternal[i]);
      if (i+1!=length){
        Buffer.write(' , ');
      }
    }
    Buffer.write(']\n');
    return Buffer.toString();
  }
}

class Vector3{

  List<double> vectorInternal;
  int length = 3;

  Vector3(double entry1, double entry2, double entry3){
    List<double> vector = new List<double>(3);
    vector[0]=entry1;
    vector[1]=entry2;
    vector[2]=entry3;
    vectorInternal = vector;
  }

  double operator [](int i){
    return vectorInternal[i];
  }

  void operator []=(int i, double v) {
    vectorInternal[i] = v;
  }

  normalise(){
    double squaredsum = 0.0;
    for (int i=0; i< length;i++){
      squaredsum += vectorInternal[i]*vectorInternal[i];
    }
    double factor = 1/sqrt(squaredsum);
    for (int i=0; i< length;i++){
      vectorInternal[i]=vectorInternal[i]*factor;
    }
  }

  double getSize(){
    double squaredsum = 0.0;
    for (int i=0; i< length;i++){
      squaredsum += vectorInternal[i]*vectorInternal[i];
    }
    return sqrt(squaredsum);
  }

  String toString(){
    StringBuffer Buffer = new StringBuffer();
    Buffer.write('[');
    for (int i =0; i < length;i++){
      Buffer.write(vectorInternal[i]);
      if (i+1!=length){
        Buffer.write(' , ');
      }
    }
    Buffer.write(']\n');
    return Buffer.toString();
  }
}

class Vector4{

  List<double> vectorInternal;
  int length = 4;

  Vector4(double entry1, double entry2, double entry3, double entry4){
    List<double> vector = new List<double>(4);
    vector[0]=entry1;
    vector[1]=entry2;
    vector[2]=entry3;
    vector[3]=entry4;
    vectorInternal = vector;
  }

  double operator [](int i){
    return vectorInternal[i];
  }

  void operator []=(int i, double v) {
    vectorInternal[i] = v;
  }

  normalise(){
    double squaredsum = 0.0;
    for (int i=0; i< length;i++){
      squaredsum += vectorInternal[i]*vectorInternal[i];
    }
    double factor = 1/sqrt(squaredsum);
    for (int i=0; i< length;i++){
      vectorInternal[i]=vectorInternal[i]*factor;
    }
  }

  double getSize(){
    double squaredsum = 0.0;
    for (int i=0; i< length;i++){
      squaredsum += vectorInternal[i]*vectorInternal[i];
    }
    return sqrt(squaredsum);
  }

  String toString(){
    StringBuffer Buffer = new StringBuffer();
    Buffer.write('[');
    for (int i =0; i < length;i++){
      Buffer.write(vectorInternal[i]);
      if (i+1!=length){
        Buffer.write(' , ');
      }
    }
    Buffer.write(']\n');
    return Buffer.toString();
  }
}