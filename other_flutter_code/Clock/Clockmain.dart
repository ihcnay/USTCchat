import 'dart:async';

import 'package:demo1/ClockCenter.dart';
import 'package:demo1/ClockHand.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '时钟',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime now = DateTime.now();
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose(){
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final clockSize = Size(screenWidth * 0.9, screenWidth * 0.9);

    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: Center(
            child: Stack(alignment: Alignment.center, children: <Widget>[
          ClockPanel(clockSize),
          ClockHandSecond(clockSize, now.second),
          ClockHand(clockSize, ClockHandType.minute, now.hour, now.minute,
              now.second),
          ClockHand(
              clockSize, ClockHandType.hour, now.hour, now.minute, now.second),
          const ClockCenter(),
        ])));
  }
}

class ClockPanel extends StatelessWidget {
  late final Size size;
  ClockPanel(this.size);

  Widget getOuterPanel() {
    return Container(
      height: size.width,
      width: size.height,
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              offset: Offset(-5, -5),
              blurRadius: 15,
            )
          ]),
    );
  }

  Widget getInnerPanel() {
    return Stack(
      children: <Widget>[
        Container(
          height: size.width * 0.9,
          width: size.width * 0.9,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.white.withOpacity(0), Colors.grey.shade400],
                center: const AlignmentDirectional(0.1, 0.1),
                focal: const AlignmentDirectional(0, 0),
                radius: 0.65,
                focalRadius: 0.001,
                stops: const [0.3, 1],
              )),
        ),
        Container(
          height: size.width * 0.9,
          width: size.width * 0.9,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.white.withOpacity(0), Colors.white],
                center: const AlignmentDirectional(-0.1, -0.1),
                focal: const AlignmentDirectional(0, 0),
                radius: 0.67,
                focalRadius: 0.001,
                stops: const [0.75, 1],
              )),
        )
      ],
    );
  }

  Widget getScale() {
    return CustomPaint(
      size: size,
      painter: ClockScalePainter(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[getOuterPanel(), getInnerPanel(), getScale()],
    );
  }
}

class ClockScalePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint scalePaint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 3;
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.12),
        Offset(size.width * 0.5, size.height * 0.06), scalePaint);
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.94),
        Offset(size.width * 0.5, size.height * 0.88), scalePaint);
    canvas.drawLine(Offset(size.width * 0.06, size.height * 0.5),
        Offset(size.width * 0.12, size.height * 0.5), scalePaint);
    canvas.drawLine(Offset(size.width * 0.88, size.height * 0.5),
        Offset(size.width * 0.94, size.height * 0.5), scalePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
// class AnimationBasic extends StatefulWidget {
//   const AnimationBasic({super.key});
//
//   @override
//   State<StatefulWidget> createState() {
//     return _AnimationBasicState();
//   }
// }
//
// class _AnimationBasicState extends State<AnimationBasic>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   double left = 0;
//   @override
//   void initState() {
//     void initState() {
//       super.initState();
//       _animationController = AnimationController(
//           vsync: this, duration: const Duration(seconds: 3));
//       var animation =
//           Tween(begin: 0.0, end: 100.0).animate(_animationController);
//       animation.addListener(() {
//         setState(() {
//           left = animation.value;
//         });
//       });
//       _animationController.forward();
//       @override
//       void dispose() {
//         super.dispose();
//         _animationController.dispose();
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned(
//           left: left,
//           child: Container(
//             width: 40,
//             height: 40,
//             color: Colors.red,
//           ),
//         )
//       ],
//     );
//   }
// }
