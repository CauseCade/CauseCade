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

  int getRowCount(){return rowCount;}

  int getColumnCount(){return columnCount;}

  List<double> operator [](int i){
    return matrixInternal [i];
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

  transform(Vector){} //FIX

  scale(double scalingFactor){ //this method needs to be fixed, to see whetehr a copy or a change to the original matrix has to be changed //FIX
    for(int i=0; i < rowCount; i++){
      for(int j=0; j < columnCount; j++){
        matrixInternal[i][j]=matrixInternal[i][j]*scalingFactor;
      }
    }
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

class Vector{
  List<double> _vector; //holds the values of the vector
  int _size; //dimensionality of the vector (not to be confused with the length of the vector. I should maybe consider refactoring terminology here)

  Vector(int length){
    this._vector = new List<double>(length);
    this._size=length;
  }

  setValues(List<double> newValues){ //if you wish to change values later on
    _vector = newValues;
  }

  int getSize(){
    return _size;
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

  String toString(){
    StringBuffer Buffer = new StringBuffer();
    Buffer.write('[');
    for (int i =0; i < _size;i++){
      Buffer.write(_vector[i]);
      if (i+1!=_size){
        Buffer.write(' , ');
      }
    }
    Buffer.write(']\n');
    return Buffer.toString();
  }
}

/*class Vector2 implements Vector{

  List<double> vectorInternal;
  int _length = 2;

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
    for (int i=0; i< _length;i++){
      squaredsum += vectorInternal[i]*vectorInternal[i];
    }
     double factor = 1/sqrt(squaredsum);
    for (int i=0; i< _length;i++){
      vectorInternal[i]=vectorInternal[i]*factor;
    }
  }

  double getSize(){
    double squaredsum = 0.0;
    for (int i=0; i< _length;i++){
      squaredsum += vectorInternal[i]*vectorInternal[i];
    }
    return sqrt(squaredsum);
  }

  String toString(){
    StringBuffer Buffer = new StringBuffer();
    Buffer.write('[');
    for (int i =0; i < _length;i++){
      Buffer.write(vectorInternal[i]);
      if (i+1!=_length){
        Buffer.write(' , ');
      }
    }
    Buffer.write(']\n');
    return Buffer.toString();
  }
}

class Vector3 implements Vector{

  List<double> vectorInternal;
  int _length = 3;

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
    for (int i=0; i< _length;i++){
      squaredsum += vectorInternal[i]*vectorInternal[i];
    }
    double factor = 1/sqrt(squaredsum);
    for (int i=0; i< _length;i++){
      vectorInternal[i]=vectorInternal[i]*factor;
    }
  }

  double getSize(){
    double squaredsum = 0.0;
    for (int i=0; i< _length;i++){
      squaredsum += vectorInternal[i]*vectorInternal[i];
    }
    return sqrt(squaredsum);
  }

  String toString(){
    StringBuffer Buffer = new StringBuffer();
    Buffer.write('[');
    for (int i =0; i < _length;i++){
      Buffer.write(vectorInternal[i]);
      if (i+1!=_length){
        Buffer.write(' , ');
      }
    }
    Buffer.write(']\n');
    return Buffer.toString();
  }
}

class Vector4 implements Vector{

  List<double> vectorInternal;
  int _length = 4;

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
    for (int i=0; i< _length;i++){
      squaredsum += vectorInternal[i]*vectorInternal[i];
    }
    double factor = 1/sqrt(squaredsum);
    for (int i=0; i< _length;i++){
      vectorInternal[i]=vectorInternal[i]*factor;
    }
  }

  double getSize(){
    double squaredsum = 0.0;
    for (int i=0; i< _length;i++){
      squaredsum += vectorInternal[i]*vectorInternal[i];
    }
    return sqrt(squaredsum);
  }

  String toString(){
    StringBuffer Buffer = new StringBuffer();
    Buffer.write('[');
    for (int i =0; i < _length;i++){
      Buffer.write(vectorInternal[i]);
      if (i+1!=_length){
        Buffer.write(' , ');
      }
    }
    Buffer.write(']\n');
    return Buffer.toString();
  }*/
//}