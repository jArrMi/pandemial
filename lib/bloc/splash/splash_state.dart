import 'package:crownapp/model/response/covid_country.dart';
import 'package:equatable/equatable.dart';

abstract class CountryListState extends Equatable {
  const CountryListState();

  @override
  List<Object?> get props => [];
}

class CountryListEmpty extends CountryListState {}

class CountryListLoading extends CountryListState {}

class CountryListAvailable extends CountryListState {
  final List<CovidCountry> countryList;

  const CountryListAvailable({required this.countryList});

  @override
  List<Object> get props => [countryList];
}

class CountryListError extends CountryListState {}
