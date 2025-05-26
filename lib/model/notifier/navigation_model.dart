import 'package:flutter/material.dart';

/// Provider for updating the navigation page.
class NavigationModel with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex; // Explicitly typed getter

  set currentIndex(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }
}
