import 'package:crownapp/model/response/country_data.dart';
import 'package:equatable/equatable.dart';

abstract class CountryDataState extends Equatable {
  const CountryDataState();

  @override
  List<Object> get props => [];
}

class CountryDataEmpty extends CountryDataState {}

class CountryDataLoading extends CountryDataState {}

class CountryDataAvailable extends CountryDataState {
  final List<CountryData> countryData;

  const CountryDataAvailable({required this.countryData});

  @override
  List<Object> get props => [countryData];
}

class CountryDataError extends CountryDataState {}
