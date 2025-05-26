import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart'; // Added direct import for Country
import 'package:crownapp/model/response/covid_country.dart';
import 'package:flutter/material.dart';

class CountryNotifier with ChangeNotifier {
  late CovidCountry _selectedCountry; // Initialized with late

  CovidCountry get selectedCountry => _selectedCountry; // Explicitly typed getter

  Country get defaultCountry => CountryPickerUtils.getCountryByIsoCode('CO'); // Typed getter

  set selectedCountry(CovidCountry newCountry) {
    _selectedCountry = newCountry;
    notifyListeners();
  }
}
