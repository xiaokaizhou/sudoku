
List<int> nums = List.generate(9, (index) => index + 1);

class Matrix {
  static int getRow(index) {
    return index % 9;
  }

  static int getCol(index) {
    return index ~/ 9;
  }

  static int getZone(row, {int col}) {
    var index;
    if (col == null) {
      index = row;
    } else {
      index = col * 9 + row;
    }

    row = getRow(index);
    col = getCol(index);

    var x = row ~/ 3;
    var y = col ~/ 3;
    return y * 3 + x;
  }

  static int getIndex(row, col) {
    return col * 9 + row;
  }
}

bool calculate(List<int> answer, List<List<bool>> rows, List<List<bool>> cols,
    List<List<bool>> zones, int index) {
  var row = Matrix.getRow(index);
  var col = Matrix.getCol(index);
  var zone = Matrix.getZone(index);

  if (index >= 81) {
    return true;
  }
  if (answer[index] != -1) {
    return calculate(answer, rows, cols, zones, index + 1);
  }

  for (var num in nums) {
    if (!rows[row][num] && !cols[col][num] && !zones[zone][num]) {
      answer[index] = num;
      rows[row][num] = true;
      cols[col][num] = true;
      zones[zone][num] = true;

      if (calculate(answer, rows, cols, zones, index + 1)) {
        return true;
      } else {
        answer[index] = -1;
        rows[row][num] = false;
        cols[col][num] = false;
        zones[zone][num] = false;
      }
    }
  }
  return false;
}
class Sudoku {
  List<int> source;
  List<int> answer;
  int timecount;


  Sudoku(this.source){
    if (source==null||source.isEmpty) {
      source = <int>[];
    }
    if (source==null||source.isEmpty || source.length != 81) {
      throw  ArgumentError('数独题目错误，不是 9 * 9 矩阵');
    }

    List<int> answer = <int>[];
    List<List<bool>> rows = List.generate(9, (num) => List.generate(10, (index) => false));
    List<List<bool>> cols = List.generate(9, (num) => List.generate(10, (index) => false));
    List<List<bool>> zones = List.generate(9, (num) => List.generate(10, (index) => false));

    int row, col, zone;
    this.source.forEach((num) {
      var index = this.source.indexOf(num);
      row = Matrix.getRow(index);
      col = Matrix.getCol(index);
      zone = Matrix.getZone(index);
      if (num != -1) {
        rows[row][num] = true;
        cols[col][num] = true;
        zones[zone][num] = true;
      }
      answer.add(num);
    });


    var isSuccess = true;
    var timeBegin = DateTime.now().millisecondsSinceEpoch;
    for (var index = 0; index < 81; ++index) {
      if (answer[index] == -1) {
        isSuccess = calculate(answer, rows, cols, zones, index);
        break;
      }
    }

    if(!isSuccess){
      throw  AssertionError('错误数独，无法计算');
    }

    this.answer = answer;
    this.timecount = (DateTime.now().millisecondsSinceEpoch - timeBegin);
  }

  getSource() {
    return this.source;
  }

  getAnswer() {
    return this.answer;
  }

  debug() {
    print('--- debug info ---');
    print('source');
    print(this.getSource());
    print('answer');
    print(this.getAnswer());
    print('耗时 : ${this.timecount}ms');
    print('--- debug end ---');
  }
}