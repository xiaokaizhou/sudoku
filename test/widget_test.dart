// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:sudoku/sudoku.dart';

void main() {
  test("test sudoku", (){
    List<int> data =<int>[
      -1, 6, -1, -1, -1, -1, -1, -1, -1,
      -1, -1, -1, 5, -1, 9, 8, -1, 7,
      1, -1, -1, -1, 8, 6, -1, -1, -1,

      -1, -1, -1, -1, -1, -1, -1, -1, 2,
      -1, -1, -1, -1, 3, 1, 7, -1, -1,
      -1, -1, 9, 4, -1, -1, 3, -1, -1,

      4, -1, 3, -1, -1, -1, -1, -1, -1,
      8, -1, 1, 9, 4, -1, -1, -1, -1,
      -1, -1, -1, -1, -1, -1, -1, 3, 5,
    ];
    var sudoku = Sudoku(data);
    sudoku.debug();
  });
}
