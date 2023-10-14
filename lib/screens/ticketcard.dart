// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ticket_manager/widget/StickWithBallFlatVertical.dart';
import 'package:ticket_manager/widget/stickwithhalfball.dart';

class TicketCard extends StatefulWidget {
  final bool specialticker;
  final String Depart_Time;
  final String arival_time;
  final String Distance;
  final String total_time;
  final String Price;
  final String Depart_place;
  final String Arive_place;
  const TicketCard(
      {super.key,
      required this.specialticker,
      required this.Depart_Time,
      required this.arival_time,
      required this.Distance,
      required this.total_time,
      required this.Price,
      required this.Depart_place,
      required this.Arive_place});

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 20,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.23,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.089,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.19,
                        // decoration: BoxDecoration(color: Colors.red),
                        child: Center(
                          child: Text(
                            widget.Depart_Time,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.19,
                        // decoration: BoxDecoration(color: Colors.red),
                        child: Center(
                          child: Text(
                            widget.arival_time,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(
                    10,
                  ),
                  const StickWithBallFlatVertical(
                    width: 2,
                    height: 0.05,
                  ),
                  const Gap(
                    10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.15,
                        // decoration: BoxDecoration(color: Colors.red),
                        child: Center(
                          child: Text(
                            widget.Depart_place,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.15,
                        // decoration: BoxDecoration(color: Colors.red),
                        child: Center(
                          child: Text(
                            widget.Arive_place,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  widget.specialticker
                      ? const Icon(
                          Icons.offline_bolt,
                          color: Color(0xfff9978f),
                          size: 30,
                        )
                      : const SizedBox(),
                  const Spacer(),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.089,
                    width: MediaQuery.of(context).size.width * 0.18,
                    decoration: BoxDecoration(
                      color: const Color(0xfff9978f),
                      border: Border.all(style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "\$${widget.Price}",
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Gap(15),
            const StickWithHalfBall(),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.map_outlined,
                        color: Color(0xfff9978f),
                      ),
                      const Gap(4),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.19,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${widget.Distance}km",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_filled,
                        color: Color(0xfff9978f),
                      ),
                      const Gap(10),
                      Text("Travel Time ${widget.total_time} min"),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
