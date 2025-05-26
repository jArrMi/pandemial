class CountryData {
  String? country;
  String? countryCode;
  double? latitude;
  double? longitude;
  int? confirmed;
  int? deaths;
  int? recovered;
  int? active;
  DateTime? date;

  CountryData(
      {this.country,
      this.countryCode,
      this.latitude,
      this.longitude,
      this.confirmed,
      this.deaths,
      this.recovered,
      this.active,
      this.date});

  factory CountryData.fromJson(dynamic json) {
    return CountryData(
        country: json["Country"] as String?,
        countryCode: json["CountryCode"] as String?,
        latitude: double.tryParse(json['Lat']?.toString() ?? ''),
        longitude: double.tryParse(json['Lon']?.toString() ?? ''),
        confirmed: int.tryParse(json["Confirmed"]?.toString() ?? ''),
        deaths: int.tryParse(json["Deaths"]?.toString() ?? ''),
        recovered: int.tryParse(json["Recovered"]?.toString() ?? ''),
        active: int.tryParse(json["Active"]?.toString() ?? ''),
        date: DateTime.tryParse(json['Date']?.toString() ?? ''));
  }
}