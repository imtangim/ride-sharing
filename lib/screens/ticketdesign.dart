import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:ticket_manager/widget/stickwithhalfball.dart';

import '../widget/stickwithball_flat.dart';

class TicketDesign extends StatefulWidget {
  final String arival_time;
  final String Arive_place;
  final String Depart_place;
  final String Depart_Time;

  const TicketDesign({
    super.key,
    required this.arival_time,
    required this.Arive_place,
    required this.Depart_place,
    required this.Depart_Time,
  });

  @override
  State<TicketDesign> createState() => _TicketDesignState();
}

class _TicketDesignState extends State<TicketDesign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      // backgroundColor: Colors.transparent,
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 48,
        // elevation: 30,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    style: BorderStyle.none,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Image.asset(
                  "assets/man.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.866),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                Center(
                  child: Material(
                    borderOnForeground: false,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 20,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.72,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          style: BorderStyle.none,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          //ticket number
                          Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.077,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(240, 141, 134, 1),
                              border: Border.all(
                                style: BorderStyle.none,
                              ),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "448-92-XXXX",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          //ticket number

                          //time
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 10,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.Depart_Time,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      widget.arival_time,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                const StickWithBallFlat(
                                  width: 0.4,
                                  height: 2,
                                ),
                                const Gap(10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.Depart_place,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      widget.Arive_place,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),

                                //date
                                const Gap(30),
                                Row(
                                  children: [
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Date:"),
                                        Text(
                                          "12 Oct 2023",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.046,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            240, 141, 134, 1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Seat ${Random().nextInt(39) + 1}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                //passenger
                                const Gap(30),
                                Row(
                                  children: [
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Passenger:"),
                                        Text(
                                          "MD Tangim Haque",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                        elevation:
                                            const MaterialStatePropertyAll(10),
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                          Color.fromRGBO(222, 227, 241, 1),
                                        ),
                                      ),
                                      onPressed: () {},
                                      icon: const Icon(Icons.add),
                                    )
                                  ],
                                ),

                                //id section
                                const Gap(20),
                                Row(
                                  children: [
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("ID:"),
                                        Text(
                                          "428-16-XXXX",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                        elevation:
                                            const MaterialStatePropertyAll(10),
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                          Color.fromRGBO(222, 227, 241, 1),
                                        ),
                                      ),
                                      onPressed: () {},
                                      icon: const Icon(Icons.edit_outlined),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const StickWithHalfBall(),
                          const Gap(10),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: SfBarcodeGenerator(
                              value: '2323546786567601',
                              textSpacing: 2,
                              textStyle: const TextStyle(
                                letterSpacing: 5,
                                decorationStyle: TextDecorationStyle.dotted,
                              ),
                              showValue: true,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.file_download_outlined,
                                    size: 30,
                                  ),
                                ),
                                const Spacer(),
                                const Tooltip(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border:
                                          Border(bottom: BorderSide(width: 1)),
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  message: "Developed by Tangim Haque",
                                  textStyle: TextStyle(color: Colors.black),
                                  triggerMode: TooltipTriggerMode
                                      .tap, // ensures the label appears when tapped
                                  preferBelow: false,
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(7),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 100,
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.8,
                        MediaQuery.of(context).size.height * 0.07,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
