import 'dart:convert';

import 'package:crownapp/model/response/country_data.dart';
import 'package:crownapp/model/response/covid_country.dart';
import 'package:crownapp/network/network_manager.dart';
import 'package:crownapp/utils/country_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataRepository {
  final NetworkManager _networkManager = NetworkManager();

  Future<List<CovidCountry>?> getAffectedCountries() async { // Return type nullable
    final countries = await _networkManager.getCountriesSlug();
    if (countries.isEmpty) { // Check if empty to align with previous null return logic
      return null;
    }
    // Assuming mapIsoCodeToCountryName modifies the list in place or is not essential for nullability
    return countries;
  }

  Future<List<CountryData>?> getCountryData(String countrySlug) async => // Return type nullable
      _networkManager.getCountryData(countrySlug); // Assuming this can return empty list or throw

  Future<List<CountryData>?> getChartDetails(
      String countrySlug, Status status) async {
    List<CountryData>? details; // Made nullable
    final prefs = await SharedPreferences.getInstance();
    final savedJson =
        prefs.getString(Status.getStatusName(Status.CONFIRMED, countrySlug));

    if (savedJson != null && savedJson.isNotEmpty) { // Added null check for savedJson
      details = List<CountryData>.from(
          json.decode(savedJson).map((item) => CountryData.fromJson(item)));
      details.removeWhere((element) => element.confirmed == 0);
    }

    return details;
  }
}
