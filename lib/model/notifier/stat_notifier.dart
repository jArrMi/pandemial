import 'package:crownapp/utils/pair.dart';
import 'package:flutter/material.dart';

class StatNotifier with ChangeNotifier {
  late Pair<DateTime, int> _selectedDate; // Initialized with late

  Pair<DateTime, int> get selectedDate => _selectedDate; // Explicitly typed getter

  set selectedDate(Pair<DateTime, int> newSelectedDate) {
    _selectedDate = newSelectedDate;
    notifyListeners();
  }
}
