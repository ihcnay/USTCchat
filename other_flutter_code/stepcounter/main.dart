//写了一半发现虚拟机器上的计步器不能用，故作废:(
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stepcounter/components/Dashboard.dart';
import 'package:pedometer/pedometer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamSubscription _stepCountSubscription;
  late int stepCount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPedometer();
  }

  @override
  void dispose() {
    _stepCountSubscription.cancel();
  }

  void onStepCount(StepCount event) {
    setState(() {
      stepCount = event.steps;
    });
    debugPrint("stepCount = ${event.steps}");
  }

  void initPedometer() async {
    var stepCountStream = await Pedometer.stepCountStream;
    _stepCountSubscription = stepCountStream.listen(onStepCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Dashboard(
            [
              DashBoardItem('步数', 20000.toString()),
              DashBoardItem('公里', '待开发'),
              DashBoardItem('千卡', '待开发'),
            ],
          ),
        )
      ],
    ));
  }
}
