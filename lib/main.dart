//@JS('Sudoku')
//library core.js;

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/sudoku.dart';
import 'package:toast/toast.dart';
//import 'package:js/js.dart';

//@JS()
//@anonymous
//class Sudoku {
//  external Sudoku();
//  external List<int> getSource();
//  external List<int> getAnswer();
//}
//external Sudoku get sudoku;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '数独小游戏'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Size screen;
  int selectNum;

  //120分钟
  var maxProgress = 10;
  var progress = 1.0;

  Timer _countdownTimer;

  List<int> data = List.generate(81, (index) => -1);
  List<int> answer = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    screen = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //进度条
          Container(
//                height: 15,
//            margin: EdgeInsets.only(bottom: 24),
            child: LinearProgressIndicator(
              minHeight: 15,
              value: progress,
              backgroundColor: Colors.orange[200],
              valueColor: AlwaysStoppedAnimation(Colors.red[300]),
            ),
          ),
          //表格
          GridView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
              itemBuilder: ((BuildContext context, int index) {
                return buildCell(index, data[index], getNormalColor(index));
              })),
          //选择数字
          Container(
            margin: EdgeInsets.only(top: 24),
            height: 50,
            color: Colors.blueGrey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(10, (index) => index + 1)
                  .map((e) => InkWell(
                        onTap: () {
                          setState(() {
                            selectNum = e;
                          });
                        },
                        child: Container(
                          color: selectNum != null && selectNum == e
                              ? Colors.lightBlue
                              : (e % 2 == 0 ? Colors.white : Colors.grey[100]),
                          width: screen.width / 10,
                          alignment: Alignment.center,
                          child: Text(
                            "$e",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: reGetCountdown,
        tooltip: 'Increment',
        child: Icon(Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Color getNormalColor(int index) {
    var rowCell = index % 9;
    return (index < 30 && rowCell > 2 && rowCell < 6) ||
            (index > 26 && index < 54 && (rowCell < 3 || rowCell > 5)) ||
            (index > 55 && rowCell > 2 && rowCell < 6)
        ? Colors.grey[100]
        : Colors.white;
  }

  //单元格
  Widget buildCell(int index, int num, Color color) {
    return InkWell(
      child: Center(
        child: Container(
          color: color,
          alignment: Alignment.center,
          margin: EdgeInsets.all(1),
          child: Text(
            '${num == -1 ? '' : num}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          if (data[index] == -1) {
            if (selectNum != null) {
              if (selectNum == answer[index]) {
                data[index] = selectNum;
                selectNum = null;
              } else {
                Toast.show("不对哦！再想想", context);
              }
            } else {
              Toast.show("请先选择下方的数字", context);
            }
            var hasComplete =
                data.firstWhere((element) => element == -1, orElse: () => -2);
            if (hasComplete == -2) {
              var duration = maxProgress-progress;
              progress = 0;
              _countdownTimer.cancel();
              _countdownTimer = null;
              //挑战成功
              showDialog(
                  context: context,
                  child: CupertinoAlertDialog(
                    title: Text('恭喜，挑战成功！'),
                    content: Text('用时:$duration秒'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text('取消'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text('继续挑战'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          reGetCountdown();
                        },
                      ),
                    ],
                  ));
            }
          }
        });
      },
    );
  }

  void reGetCountdown() {
    setState(() {
      if (_countdownTimer != null) {
        return;
      }
      List<int> data = <int>[
        -1,
        6,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        5,
        -1,
        9,
        8,
        -1,
        7,
        1,
        -1,
        -1,
        -1,
        8,
        6,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        2,
        -1,
        -1,
        -1,
        -1,
        3,
        1,
        7,
        -1,
        -1,
        -1,
        -1,
        9,
        4,
        -1,
        -1,
        3,
        -1,
        -1,
        4,
        -1,
        3,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        8,
        -1,
        1,
        9,
        4,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        3,
        5,
      ];
      setState(() {
        var sudoku = Sudoku(data);
        this.data = sudoku.getSource();
        answer = sudoku.getAnswer();
      });
      // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
      progress = 1;
      _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          if (progress > 0) {
            progress -= 1 / maxProgress;
          } else {
            progress = 0;
            _countdownTimer.cancel();
            _countdownTimer = null;
            showDialog(
                context: context,
                child: CupertinoAlertDialog(
                  title: Text('挑战失败！'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('取消'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text('重新开始'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        reGetCountdown();
                      },
                    ),
                  ],
                ));
          }
        });
      });
    });
  }

  // 不要忘记在这里释放掉Timer
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }
}
