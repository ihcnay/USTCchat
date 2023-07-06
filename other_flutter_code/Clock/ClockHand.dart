import 'dart:math';

import 'package:flutter/material.dart';

enum ClockHandType { hour, minute }

const clockHandParams = {
  ClockHandType.hour: {
    "lengthFactor": 0.32,
    "width": 5.0,
  },
  ClockHandType.minute: {
    "lengthFactor": 0.2,
    "width": 3.0,
  }
};

class ClockHand extends StatelessWidget {
  late final Size clockSize;
  late final ClockHandType handType;
  late final int minute;
  late final int hour;
  late final int second;

  ClockHand(this.clockSize, this.handType, this.hour, this.minute, this.second,
      {super.key});

  @override
  Widget build(BuildContext context) {
    double endAngle;

    if (handType == ClockHandType.minute) {
      endAngle = 2 * pi / 60 * minute + 2 * pi / 360 * 6 * (second / 60);
    } else if (handType == ClockHandType.hour) {
      endAngle = 2 * pi / 12 * hour + 2 * pi / 360 * 30 * (minute / 60);
    } else {
      endAngle = 0;
    }

    return Transform.rotate(
        angle: endAngle,
        child: CustomPaint(
          size: clockSize,
          painter: ClockHandPainter(handType),
        ));
  }
}

class ClockHandPainter extends CustomPainter {
  late final ClockHandType handType;
  ClockHandPainter(this.handType);

  @override
  void paint(Canvas canvas, Size size) {
    final handConfig = clockHandParams[handType];
    final lengthFactor = handConfig?['lengthFactor'];
    final width = handConfig?['width'];
    var handPaint = Paint()
      ..color = Colors.black54
      ..strokeWidth = width!
      ..strokeCap = StrokeCap.round;

    var handStart = Offset(size.width * 0.5, size.height * 0.5);
    var handEnd = Offset(size.width * 0.5, size.height * lengthFactor!);

    canvas.drawLine(handStart, handEnd, handPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ClockHandSecond extends StatelessWidget {
  late final Size clockSize;
  late final int second;

  ClockHandSecond(this.clockSize, this.second, {super.key});

  @override
  Widget build(BuildContext context) {
    // return CustomPaint(
    //   size: clockSize,
    //   painter: SecondHandPainter(),
    // );
    debugPrint(second.toString());
    var beginAngle = 2 * pi / 60 * (second - 1);
    var endAngle = beginAngle + 2 * pi / 60;
    if(second == 0){
      return TweenAnimationBuilder<double>(
          key: const ValueKey('prevent overlap'),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInQuint,
          tween: Tween<double>(begin: beginAngle, end: endAngle),
          builder: (context, anim, child) {
            return Transform.rotate(
              angle: anim,
              child: CustomPaint(
                size: clockSize,
                painter: SecondHandPainter(),
              ),
            );
          });
    }
    return TweenAnimationBuilder<double>(
        key: const ValueKey('normal'),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInQuint,
        tween: Tween<double>(begin: beginAngle, end: endAngle),
        builder: (context, anim, child) {
          return Transform.rotate(
            angle: anim,
            child: CustomPaint(
              size: clockSize,
              painter: SecondHandPainter(),
            ),
          );
        });
  }
}

class SecondHandPainter extends CustomPainter {
  static const HAND_WIDTH = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    var handPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = HAND_WIDTH
      ..strokeCap = StrokeCap.round;

    var handStart = Offset(size.width * 0.5, size.height * 0.65);
    var handEnd = Offset(size.width * 0.5, size.height * 0.1);

    canvas.drawLine(handStart, handEnd, handPaint);

    var circlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    var center = Offset(size.width * 0.5, size.height * 0.65);
    canvas.drawCircle(center, 6.0, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
