import 'package:flutter/material.dart';

class StickWithHalfBall extends StatelessWidget {
  const StickWithHalfBall({super.key});

  @override
  Widget build(BuildContext context) {
    Widget blackDot() {
      return Container(
        width: 15, // Set the width and height to control the size of the dot
        height: 20,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            topRight: Radius.circular(20),
          ), // Create a circular shape
          color:
              Color.fromARGB(33, 0, 0, 0), // Set the background color to black
        ),
      );
    }

    Widget blackDotLeft() {
      return Container(
        width: 15, // Set the width and height to control the size of the dot
        height: 20,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            topLeft: Radius.circular(30),
          ), // Create a circular shape
          color:
              Color.fromARGB(33, 0, 0, 0), // Set the background color to black
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        blackDot(),
        Expanded(
          child: SizedBox(
            height: 10,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Flex(
                  mainAxisSize: MainAxisSize.min,
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    (30).floor(),
                    (index) => const SizedBox(
                      width: 6,
                      height: 1.4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(40, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        blackDotLeft(),
      ],
    );
  }
}
