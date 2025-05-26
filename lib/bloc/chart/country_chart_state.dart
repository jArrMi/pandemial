import 'package:crownapp/model/response/country_data.dart';
import 'package:equatable/equatable.dart';

abstract class CountryChartState extends Equatable {
  const CountryChartState();

  @override
  List<Object> get props => [];
}

class CountryChartEmpty extends CountryChartState {}

class CountryChartLoading extends CountryChartState {}

class CountryChartAvailable extends CountryChartState {
  final List<CountryData> countryChart;

  const CountryChartAvailable({required this.countryChart});

  @override
  List<Object> get props => [countryChart];
}

class CountryChartError extends CountryChartState {}
