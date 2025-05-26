import 'package:crownapp/utils/country_utils.dart';
import 'package:equatable/equatable.dart';

class CountryChartEvent extends Equatable {
  final String countryName;
  final Status status;

  const CountryChartEvent({required this.countryName, required this.status});

  @override
  List<Object> get props => [countryName, status];
}
