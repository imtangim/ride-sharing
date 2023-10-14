// ignore_for_file: file_names

import 'package:flutter/material.dart';

class StickWithBallFlatVertical extends StatefulWidget {
  final num width;
  final num height;
  const StickWithBallFlatVertical(
      {super.key, required this.width, required this.height});

  @override
  State<StickWithBallFlatVertical> createState() =>
      _StickWithBallFlatVerticalState();
}

class _StickWithBallFlatVerticalState extends State<StickWithBallFlatVertical> {
  @override
  Widget build(BuildContext context) {
    Widget blackDot(Color color) {
      return Container(
        width: 13, // Set the width and height to control the size of the dot
        height: 13,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Create a circular shape
          color: Colors.white,
          border: Border.all(color: color, width: 2),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        blackDot(const Color.fromRGBO(236, 140, 134, 1)),
        Container(
          height: MediaQuery.of(context).size.height * widget.height,
          width: widget.width.toDouble(),
          decoration: BoxDecoration(
            border: Border.all(style: BorderStyle.none),
            gradient: const LinearGradient(
              colors: [Color(0xfff9978f), Color(0xff002327)],
              stops: [0, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        blackDot(Colors.black),
      ],
    );
  }
}
