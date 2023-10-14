import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class IconButtons extends StatefulWidget {
  final bool selection;
  final IconData icon;
  final Function() todo;
  final num size;
  final num radius;
  final String label;
  const IconButtons(
      {super.key,
      required this.icon,
      required this.todo,
      required this.size,
      required this.radius,
      required this.selection,
      required this.label});

  @override
  State<IconButtons> createState() => _IconButtonsState();
}

class _IconButtonsState extends State<IconButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.076,
          width: MediaQuery.of(context).size.width * 0.15,
          child: IconButton(
            style: IconButton.styleFrom(
              foregroundColor: widget.selection ? Colors.white : Colors.black,
              backgroundColor: widget.selection
                  ? const Color.fromRGBO(240, 141, 134, 1)
                  : const Color.fromRGBO(222, 227, 241, 1),
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(
                  widget.radius.toDouble(),
                ),
              ),
            ),
            onPressed: widget.todo,
            icon: Icon(
              widget.icon,
              size: widget.size.toDouble(),
            ),
          ),
        ),
        const Gap(5),
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
