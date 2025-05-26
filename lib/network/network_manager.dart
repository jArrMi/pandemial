import 'dart:convert';

import 'package:crownapp/model/response/country_data.dart';
import 'package:crownapp/model/response/covid_country.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart'; // _prefs was unused
import 'package:sprintf/sprintf.dart';

class NetworkManager {
  final _client = http.Client(); // Removed 'new'

  final _baseUrl = "https://api.covid19api.com/";
  final _getAffectedCountries = "countries";
  final _getCountryData = "total/country/%s";
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance(); // _prefs was unused

  Future<List<CovidCountry>> getCountriesSlug() async {
    print('Looking affected countries');
    var response = await _client.get(Uri.parse('$_baseUrl$_getAffectedCountries')); // Used Uri.parse

    try {
      if (response.statusCode == 200) {
        print('Countries retrieved successfully');
        print('Parsing response');

        var rawData = json.decode(response.body);
        print('Response:\n $rawData');
        final listOfCountries = List<CovidCountry>.from(
            rawData.map((item) => CovidCountry.fromMap(item)));
        print('Parsing data finished');

        return listOfCountries;
      } else {
        throw Exception('Error fetching data :('); // Corrected 'new Exception'
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  // @formatter:off
  Future<List<CountryData>> getCountryData(String countrySlug) async {
    print('Getting data for country identified with slug: $countrySlug');
    var responseData =
        await _client.get(Uri.parse(sprintf('$_baseUrl$_getCountryData', [countrySlug]))); // Used Uri.parse

    try {
      // Confirmed
      if (responseData.statusCode == 200) {
        print('Response obtained');
        print('Parsing data');
        var rawData = json.decode(responseData.body);
        print('Response: $rawData');
        final listOfCountries = List<CountryData>.from( // Explicitly typed List
            rawData.map((item) => CountryData.fromJson(item)));
        listOfCountries.removeWhere((element) => element.confirmed == 0);
        print('Finished parsing the data');
        return listOfCountries;
      } else { // Handle non-200 status
        throw Exception('Failed to load country data for $countrySlug. Status code: ${responseData.statusCode}');
      }
    } catch (e) {
      print(e);
      return []; // Return empty list on error
    }
  }
// @formatter:on
}
