import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ticket_manager/widget/customtextfield.dart';
import 'package:ticket_manager/widget/stickwithball_dotted.dart';

import 'ticketpage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  static LatLng initialPosition = const LatLng(23.8760, 90.3138);
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();
  bool isSwap = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(initialPosition.latitude, initialPosition.longitude),
              zoom: 10.5,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextFormField(
                      // textAlignVertical: TextAlignVertical.center,
                      // textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        hintText: "Search Location",
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
                        prefixIcon: Container(
                          margin: const EdgeInsets.only(left: 20, right: 10),
                          child: const Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const Gap(10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(style: BorderStyle.none),
                      color: Colors.white,
                    ),
                    height: MediaQuery.of(context).size.height * 0.065,
                    width: MediaQuery.of(context).size.height * 0.07,
                    child: IconButton(
                      onPressed: () {},
                      icon: Transform.rotate(
                        angle: 40 * 3.1415 / 190,
                        child: const Icon(
                          Icons.navigation_outlined,
                          size: 30,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 1.8,
            right: MediaQuery.of(context).size.width -
                ((MediaQuery.of(context).size.width * 95) / 100),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 1,
              ),
              onPressed: () {},
              child: const Text(
                "Open Map",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
                border: Border.all(style: BorderStyle.none),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Where would you like",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "to go ",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "today?",
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.84,
                      decoration: BoxDecoration(
                        border: Border.all(style: BorderStyle.none),
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(222, 227, 241, 255),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const StickWithBall(),
                          Stack(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomTextField(
                                  currentLocation: () {},
                                  onChanged: (value) {},
                                  labelText: "From",
                                  controller: from,
                                ),
                                const Gap(10),
                                CustomTextField(
                                  currentLocation: () {},
                                  onChanged: (value) {},
                                  labelText: "To",
                                  controller: to,
                                ),
                              ],
                            ),
                            Positioned(
                              right: MediaQuery.of(context).size.width * 0.09,
                              bottom: MediaQuery.of(context).size.height * 0.07,
                              child: IconButton(
                                style: const ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                    CircleBorder(),
                                  ),
                                  backgroundColor: MaterialStatePropertyAll(
                                    Color.fromRGBO(240, 141, 134, 1),
                                  ),
                                ),
                                onPressed: () {
                                  print("From: ${from.text}  To: ${to.text}");
                                  setState(() {
                                    String temp = "";
                                    temp = from.text;
                                    from.clear();
                                    from.text = to.text;
                                    to.clear();
                                    to.text = temp;
                                    isSwap = !isSwap;
                                  });

                                  print("From: ${from.text}  To: ${to.text}");
                                  if (isSwap) {
                                    _controller.forward(from: 0);
                                  } else {
                                    _controller.reverse(from: 1);
                                  }
                                },
                                icon: RotationTransition(
                                  turns: _animation,
                                  child: Transform.rotate(
                                    angle: 80 * 3.1416 / 190,
                                    child: const Icon(
                                      Icons.compare_arrows,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ],
                      ),
                    ),
                    const Gap(7),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: Color.fromRGBO(240, 141, 134, 1),
                              ),
                              Gap(2),
                              Text(
                                "Today",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                ),
                              )
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "1 Passenger",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Gap(5),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.8,
                          MediaQuery.of(context).size.height * 0.06,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return TicketCounter(
                                arrival_place: to.text,
                                depart_place: from.text,
                              );
                            },
                          ),
                        );
                      },
                      child: const Text(
                        "Search",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
