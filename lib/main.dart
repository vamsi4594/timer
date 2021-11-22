import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  Duration duration = Duration();
  Timer timer;
  bool isCountdown = false;
  static const countdownDuration = Duration(seconds: 10);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void reset() {
    if (isCountdown) {
      setState(() {
        duration = countdownDuration;
      });
    } else {
      duration = Duration();
    }
  }

  startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  addTime() {
    final addSeconds = isCountdown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isCountdown ? 'Countdown Timer' : 'Stop Watch'),),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildFunctionChangeBtn(),
            const SizedBox(
              height: 20,
            ),
            buildTime(),
            const SizedBox(
              height: 60,
            ),
            buildButtons()
          ],
        ),
      ),
    );
  }

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer.isActive;
    final isCompleted = duration.inSeconds == 0;
    return isRunning || !isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                    onPressed: () {
                      if (isRunning) {
                        stopTimer(resets: false);
                      } else {
                        startTimer(resets: false);
                      }
                    },
                    child: Text(isRunning ? 'STOP' : 'RESUME',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold))),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                    onPressed: stopTimer,
                    child: Text('CANCEL',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold))),
              ),
            ],
          )
        : Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: TextButton(
              onPressed: () {
                startTimer();
              },
              child: Text('START TIMER',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold))),
        );
  }

  stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() {
      timer.cancel();
    });
  }

  Widget buildFunctionChangeBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: isCountdown ? Colors.grey : Colors.green, borderRadius: BorderRadius.circular(20)),
            child: TextButton(
                onPressed: () {
                  setState(() {
                    isCountdown = false;
                    timer !=null ? timer.cancel() : null;
                    duration = Duration();
                  });
                },
                child: Text(
                  'Stop Watch',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isCountdown ? Colors.grey.shade100 : Colors.black),
                ))),
        const SizedBox(width: 10,),
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: isCountdown ? Colors.green : Colors.grey, borderRadius: BorderRadius.circular(20)),
            child: TextButton(
                onPressed: () {
                  setState(() {
                    isCountdown = true;
                    timer !=null ? timer.cancel() : null;
                    duration = Duration();
                  });
                },
                child: Text(
                  'Countdown Timer',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isCountdown ? Colors.black : Colors.grey.shade100),
                ))),
      ],
    );
  }

  Widget buildTime() {
    // convert a number to two digits. eg: 9 --> 09
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildTimeCard(time: hours, header: 'HOURS'),
        // Padding(
        //   padding: const EdgeInsets.all(1.0),
        //   child: Text(':', style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white),),
        // ),
        const SizedBox(
          width: 8,
        ),
        buildTimeCard(time: minutes, header: 'MINUTES'),
        const SizedBox(
          width: 8,
        ),
        // Padding(
        //   padding: const EdgeInsets.all(1.0),
        //   child: Text(':', style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white),),
        // ),
        buildTimeCard(time: seconds, header: 'SECONDS'),
      ],
    );
  }

  buildTimeCard({String time, String header}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Text(
            time,
            style: TextStyle(
                fontSize: 70, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          header,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
