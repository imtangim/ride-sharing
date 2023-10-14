import 'package:flutter/material.dart';

class StickWithBall extends StatelessWidget {
  const StickWithBall({super.key});

  @override
  Widget build(BuildContext context) {
    Widget blackDot() {
      return Container(
        width: 15, // Set the width and height to control the size of the dot
        height: 15,
        decoration: const BoxDecoration(
          shape: BoxShape.circle, // Create a circular shape
          color: Colors.black, // Set the background color to black
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        blackDot(),
        SizedBox(
          height: 50,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Flex(
                mainAxisSize: MainAxisSize.min,
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  (5).floor(),
                  (index) => const SizedBox(
                    width: 3,
                    height: 6,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        blackDot(),
      ],
    );
  }
}
