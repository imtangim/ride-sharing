import 'package:flutter/material.dart';
import 'package:ticket_manager/screens/homepage.dart';
import 'package:ticket_manager/screens/ride.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  int _selectedIndex = 1;
  static final List<Widget> _widgetOptions = <Widget>[
    const Center(child: Text("Bus")),
    const RideSharing(),
    const Center(
      child: Text("Profile"),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, //to stop movement of the icon
        currentIndex:
            _selectedIndex, //telling the flutter on which index we should have been right now
        onTap: _onItemTapped, //what would happen on tap
        elevation: 10,
        showSelectedLabels: false, //hiding text
        showUnselectedLabels: false, //hiding text
        selectedItemColor:
            Colors.blueGrey, //what would be the color of selectedItem
        unselectedItemColor: const Color(0xFF526480),
        items: const [
          BottomNavigationBarItem(
            label: "Bus",
            icon: Icon(Icons.bus_alert),
          ),
          BottomNavigationBarItem(
            label: "Ride",
            icon: Icon(Icons.motorcycle),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.account_balance_wallet_sharp),
          )
        ],
      ),
    );
  }
}
