import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticket_manager/Model/autocomplete.dart';

final placeResultsProvider = ChangeNotifierProvider<PlaceResults>(
  (ref) {
    return PlaceResults();
  },
);

final searchToggleProvider = ChangeNotifierProvider<SearchToggle>(
  (ref) {
    return SearchToggle();
  },
);

class PlaceResults extends ChangeNotifier {
  String myloc = "Your Location";
  List<dynamic> allReturns = [];
  void setResults(allplace) {
    allReturns = allplace;

    // print(allReturns);s
    notifyListeners();
  }
}

class SearchToggle extends ChangeNotifier {
  bool searchToggle = false;
  bool currentState = false;
  void toggleSearch() {
    searchToggle = !searchToggle;
    notifyListeners();
  }

  void currentSit() {
    currentState = searchToggle == true ? true : false;
    notifyListeners();
  }
}
