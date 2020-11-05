import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChronoPage extends StatefulWidget {
  @override
  _ChronoPageState createState() => _ChronoPageState();
}

class _ChronoPageState extends State<ChronoPage> {
  bool _isPressed = false;
  //bool flag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';
  int counter = 0;

  Future chronoStart() async {
    await Future.delayed(Duration(milliseconds: 50), () {
      counter++;
      while (_isPressed) {
        if (counter < 60) {
          secondsStr = counter.toString();
        }
        if (counter >= 60) {
          minutesStr = (counter % 60).toString();
        }
        if (counter >= 3600) {
          hoursStr = (counter % 3600).toString();
        }
      }
    });
    print(secondsStr);
    print(minutesStr);
    print(hoursStr);
  }

  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Clock",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$hoursStr:$minutesStr:$secondsStr",
                  style: TextStyle(
                    fontSize: 90.0,
                  ),
                ),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      onPressed: () {
                        if (_isPressed) {
                          print("non passo");
                        } else {
                          timerStream = stopWatchStream();
                          timerSubscription = timerStream.listen((int newTick) {
                            setState(() {
                              hoursStr = ((newTick / (60 * 60)) % 60)
                                  .floor()
                                  .toString()
                                  .padLeft(2, '0');
                              minutesStr = ((newTick / 60) % 60)
                                  .floor()
                                  .toString()
                                  .padLeft(2, '0');
                              secondsStr = (newTick % 60)
                                  .floor()
                                  .toString()
                                  .padLeft(2, '0');
                            });
                          });
                          _isPressed = !_isPressed;
                        }
                      },
                      color: Colors.green,
                      child: Text(
                        'START',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 40.0),
                    RaisedButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      onPressed: () {
                        timerSubscription.cancel();
                        timerStream = null;
                        setState(() {
                          hoursStr = '00';
                          minutesStr = '00';
                          secondsStr = '00';
                        });
                        _isPressed = !_isPressed;
                      },
                      color: Colors.red,
                      child: Text(
                        'RESET',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ); //
  }
}
