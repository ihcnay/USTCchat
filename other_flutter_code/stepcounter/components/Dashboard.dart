import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final List<DashBoardItem> items;
  Dashboard(this.items);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.all(20),
      width: size.width * 0.9,
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items,
      ),
    );
  }
}

class DashBoardItem extends StatelessWidget {
  late final String unit;
  late final String value;

  DashBoardItem(this.unit, this.value);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: size.width * 0.2,
          height: 60,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(value),
          ),
        ),
        Text(
          unit,
          style: const TextStyle(fontSize: 16),
        )
      ],
    );
  }
}
