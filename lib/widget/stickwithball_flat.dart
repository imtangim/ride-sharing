import 'package:flutter/material.dart';

class StickWithBallFlat extends StatefulWidget {
  final num width;
  final num height;
  const StickWithBallFlat(
      {super.key, required this.width, required this.height});

  @override
  State<StickWithBallFlat> createState() => _StickWithBallFlatState();
}

class _StickWithBallFlatState extends State<StickWithBallFlat> {
  @override
  Widget build(BuildContext context) {
    Widget blackDot(Color color) {
      return Container(
        width: 17, // Set the width and height to control the size of the dot
        height: 17,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Create a circular shape
          color: Colors.white,
          border: Border.all(color: color, width: 2.4),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        blackDot(const Color.fromRGBO(236, 140, 134, 1)),
        Container(
          height: widget.height.toDouble(),
          width: MediaQuery.of(context).size.width * widget.width,
          decoration: BoxDecoration(
            border: Border.all(style: BorderStyle.none),
            gradient: const LinearGradient(
              colors: [Color(0xfff9978f), Color(0xff002327)],
              stops: [0, 1],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        blackDot(Colors.black),
      ],
    );
  }
}
