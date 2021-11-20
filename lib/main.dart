import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const SnakeGame());
}

class SnakeGame extends StatelessWidget {
  const SnakeGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //لأخفاء الشريط الاساسي الذي بالاعلي الذي يظهر فيه الوقت والتاريخ والبطاريه
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game',
      theme: ThemeData(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // هذه القيم لتحديد مكان الافعي في مربعات الشاشه
  List<int> snakePosition = [42, 62, 82, 102];

  // عدد المربعات
  int numberOfSquares = 760;

  // حتي يتير مكان الطعام في 700 مربع بطريقه عشوائيه
  static var randomNumber = Random();
  int food = randomNumber.nextInt(700);

  // سرعة حركة الافعي
  var speed = 300;

  // لمعرفة اللاعب يلعب اللعبه ام لا
  bool playing = false;

  // لتحديد اتجاه الافعي عند بداية اللعبه
  var direction = 'down';

  // هذه القيم الثلاثه لتغيير الوان الازرار بالاسف في الشريط
  bool x1 = false;
  bool x2 = false;
  bool x3 = false;

  // لأنهاء اللعبه
  bool endGame = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != 'up' && details.delta.dy > 0) {
                  direction = 'down';
                } else if (direction != 'down' && details.delta.dy < 0) {
                  direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != 'left' && details.delta.dx > 0) {
                  direction = 'right';
                } else if (direction != 'right' && details.delta.dx < 0) {
                  direction = 'left';
                }
              },
              child: Stack(
                children: [
               //   Center(
                     // child: Image.asset('images/x.jpg',
                       //   fit: BoxFit.contain)),
                  GridView.builder(
                    itemCount: numberOfSquares,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 20,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (snakePosition.contains(index)) {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }
                      if (index == food) {
                        return Container(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: const Center(
                                child: Icon(
                                  Icons.fastfood,
                                  size: 15,
                                  color: Colors.yellow,
                                )),
                          ),
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          !playing
              ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: x1 ? Colors.green : Colors.transparent,
                ),
                margin: const EdgeInsets.all(10),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        x1 = true;
                        x2 = false;
                        x3 = false;
                        speed = 300;
                      });
                    },
                    child: const Text(
                      'X1',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: x2 ? Colors.green : Colors.transparent,
                ),
                margin: const EdgeInsets.all(10),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        x2 = true;
                        x1 = false;
                        x3 = false;
                        speed = 200;
                      });
                    },
                    child: const Text(
                      'X2',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: x3 ? Colors.green : Colors.transparent,
                ),
                margin: const EdgeInsets.all(10),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        x3 = true;
                        x1 = false;
                        x2 = false;
                        speed = 100;
                      });
                    },
                    child: const Text(
                      'X3',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ),
              Container(
                height: 20,
                width: 1,
                color: Colors.white70,
              ),
              OutlinedButton(
                  onPressed: () {
                    startGame();
                  },
                  child: Row(
                    children: const [
                      Text(
                        'Start',
                        style: TextStyle(color: Colors.yellow),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.play_arrow, color: Colors.yellow),
                    ],
                  ))
            ],
          )
              : Container(
            height: 50,
            color: Colors.white12,
            child: Center(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    endGame = true;
                  });
                },
                child: Text(
                  'End the Game and show result',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // هنا توجد ال function

  startGame() {
    setState(() {
      playing = true;
    });
    endGame = false;
    snakePosition = [42, 62, 82, 102];
    //   نقوم بتشغيل تايمر ونعطيه المتغير speed
    var duration = Duration(milliseconds: speed);
    Timer.periodic(duration, (Timer timer) {
      // لتحديث مكان هذه الافعي علي هذه المربعات
      updateSnake();
      if (gameOver() || endGame) {
        timer.cancel();
        showGameOverDialog();
        playing = false;
        x1 = false;
        x2 = false;
        x3 = false;
      }
    });
  }

  gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count += 1;
        }
        if (count == 2) {
          setState(() {
            playing = false;
          });
          return true;
        }
      }
    }
    return false;
  }

  showGameOverDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Over'),
            content: Text('your score is     ' + snakePosition.length.toString(),style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
            actions: [
              TextButton(
                  onPressed: () {
                    startGame();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Play Again'))
            ],
          );
        });
  }

  generateNewFood() {
    food = randomNumber.nextInt(700);
  }

  // هام جدا لتحريك اي عناصر علي الشاشه الان وفي المستقبل
  updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePosition.last > 740) {
            snakePosition.add(snakePosition.last + 20 - 760);
          } else {
            snakePosition.add(snakePosition.last + 20);
          }
          break;

        case 'up':
          if (snakePosition.last < 20) {
            snakePosition.add(snakePosition.last - 20 + 760);
          } else {
            snakePosition.add(snakePosition.last - 20);
          }
          break;

        case 'left':
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last - 1 + 20);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;

        case 'right':
          if ((snakePosition.last + 1) % 20 == 0) {
            snakePosition.add(snakePosition.last + 1 - 20);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;

        default:
      }
      if (snakePosition.last == food) {
        generateNewFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }
}
