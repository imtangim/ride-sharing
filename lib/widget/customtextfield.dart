import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function() currentLocation;

  const CustomTextField(
      {super.key,
      required this.labelText,
      required this.controller,
      required this.onChanged,
      required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.7,
      child: Row(
        children: [
          SizedBox(
            height: 6,
            width: MediaQuery.of(context).size.width * 0.06,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Flex(
                  mainAxisSize: MainAxisSize.min,
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    (3).floor(),
                    (index) => const SizedBox(
                      width: 6,
                      height: 3,
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
          Expanded(
            child: TextField(
              onChanged: onChanged,
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: currentLocation, icon: Icon(Icons.gps_fixed)),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                hintText: labelText,
                hintStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide.none,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
