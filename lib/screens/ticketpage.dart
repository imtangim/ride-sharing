// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers, unnecessary_null_comparison

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ticket_manager/utils/data.dart';
import 'package:ticket_manager/widget/iconbutton.dart';

import 'ticketcard.dart';
import 'ticketdesign.dart';

class TicketCounter extends StatefulWidget {
  final String depart_place;
  final String arrival_place;
  const TicketCounter(
      {super.key, required this.depart_place, required this.arrival_place});

  @override
  State<TicketCounter> createState() => _TicketCounterState();
}

class _TicketCounterState extends State<TicketCounter> {
  List<bool> selectedIcon = [false, false, true, false];
  String capitalizeFirstLetter(String input) {
    if (input == null || input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  bool _specialPrice = false;
  bool _onlyTickets = true;
  @override
  Widget build(BuildContext context) {
    List<IconData> icons = [
      Icons.ads_click_sharp,
      Icons.train,
      Icons.directions_bus_filled_outlined,
      Icons.local_taxi_outlined,
    ];
    List<String> labels = ["All", "Train", "Bus", "Taxi"];

    return Scaffold(
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
      body: Column(
        children: [
          Center(
            child: SizedBox(
              // decoration: BoxDecoration(color: Colors.red),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.23,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 20),
                          child: IconButtons(
                            icon: icons[index],
                            radius: 18,
                            size: 30,
                            todo: () {
                              setState(() {
                                for (int i = 0; i < selectedIcon.length; i++) {
                                  if (i == index) {
                                    selectedIcon[i] = !selectedIcon[i];
                                  } else {
                                    selectedIcon[i] = false;
                                  }
                                }
                              });

                              if (kDebugMode) {
                                print(
                                    "SelectedIcon: $index : ${selectedIcon[index]}");
                              }
                            },
                            selection: selectedIcon[index],
                            label: labels[index],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: _onlyTickets
                                ? Colors.white
                                : const Color.fromRGBO(222, 227, 241, 1),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: const Color.fromRGBO(222, 227, 241, 1),
                                width: 1,
                                style: _onlyTickets
                                    ? BorderStyle.solid
                                    : BorderStyle.none,
                              ),
                            ),
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.42,
                              MediaQuery.of(context).size.height * 0.034,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              if (_specialPrice) {
                                _specialPrice = false;
                                _onlyTickets = true;
                              } else {
                                _specialPrice = true;
                                _onlyTickets = false;
                              }
                              if (kDebugMode) {
                                print("Only : $_onlyTickets");
                              }
                              if (kDebugMode) {
                                print("special : $_specialPrice");
                              }
                            });
                          },
                          child: const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 16.0),
                                child: Icon(
                                  Icons.offline_bolt,
                                  color: Color.fromRGBO(240, 141, 134, 1),
                                ),
                              ),
                              Text(
                                "Special Price",
                                style: TextStyle(
                                  fontSize: 15.3,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: _specialPrice
                                ? Colors.white
                                : const Color.fromRGBO(222, 227, 241, 1),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: const Color.fromRGBO(222, 227, 241, 1),
                                width: 1,
                                style: _specialPrice
                                    ? BorderStyle.solid
                                    : BorderStyle.none,
                              ),
                            ),
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.42,
                              MediaQuery.of(context).size.height * 0.034,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              if (_onlyTickets) {
                                _onlyTickets = false;
                                _specialPrice = true;
                              } else {
                                _specialPrice = false;
                                _onlyTickets = true;
                              }
                              if (kDebugMode) {
                                print("Only : $_onlyTickets");
                              }
                              if (kDebugMode) {
                                print("special : $_specialPrice");
                              }
                            });
                          },
                          child: const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 5.0),
                                child: Icon(
                                  Icons.local_play_sharp,
                                  color: Color.fromRGBO(240, 141, 134, 1),
                                ),
                              ),
                              Text(
                                "Only with Tickets",
                                style: TextStyle(
                                  fontSize: 15.3,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const Gap(30),
          Expanded(
            child: ListView.builder(
              itemCount: busService.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (_specialPrice == true && _onlyTickets == false) {
                  return busService[index]["Special_price"] == true
                      ? GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return TicketDesign(
                                  Arive_place: capitalizeFirstLetter(
                                      widget.arrival_place),
                                  arival_time: busService[index]["arival_time"]
                                      .toString(),
                                  Depart_Time: busService[index]["Depart_Time"]
                                      .toString(),
                                  Depart_place: capitalizeFirstLetter(
                                      widget.depart_place),
                                );
                              },
                            ));
                            if (kDebugMode) {
                              print(
                                  "Ticket Price: ${busService[index]["ticket_price"]}");
                            }
                          },
                          child: Container(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 40.0),
                                child: TicketCard(
                                  specialticker: busService[index]
                                      ["Special_price"],
                                  Arive_place: capitalizeFirstLetter(
                                      widget.arrival_place),
                                  Depart_place: capitalizeFirstLetter(
                                      widget.depart_place),
                                  Depart_Time: busService[index]["Depart_Time"]
                                      .toString(),
                                  arival_time: busService[index]["arival_time"]
                                      .toString(),
                                  Distance:
                                      busService[index]["Distance"].toString(),
                                  total_time: busService[index]["total_time"]
                                      .toString(),
                                  Price: busService[index]["ticket_price"]
                                      .toString(),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container();
                } else {
                  return busService[index]["Special_price"] == false
                      ? GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return TicketDesign(
                                  Arive_place: capitalizeFirstLetter(
                                      widget.arrival_place),
                                  arival_time: busService[index]["arival_time"]
                                      .toString(),
                                  Depart_Time: busService[index]["Depart_Time"]
                                      .toString(),
                                  Depart_place: capitalizeFirstLetter(
                                      widget.depart_place),
                                );
                              },
                            ));
                            if (kDebugMode) {
                              print(
                                  "Ticket Price: ${busService[index]["ticket_price"]}");
                            }
                          },
                          child: Container(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 40.0),
                                child: TicketCard(
                                  specialticker: busService[index]
                                      ["Special_price"],
                                  Arive_place: capitalizeFirstLetter(
                                      widget.arrival_place),
                                  Depart_place: capitalizeFirstLetter(
                                      widget.depart_place),
                                  Depart_Time: busService[index]["Depart_Time"]
                                      .toString(),
                                  arival_time: busService[index]["arival_time"]
                                      .toString(),
                                  Distance:
                                      busService[index]["Distance"].toString(),
                                  total_time: busService[index]["total_time"]
                                      .toString(),
                                  Price: busService[index]["ticket_price"]
                                      .toString(),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
