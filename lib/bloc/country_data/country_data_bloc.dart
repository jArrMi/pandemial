import 'package:crownapp/bloc/country_data/country_data_event.dart';
import 'package:crownapp/bloc/country_data/country_data_state.dart';
import 'package:crownapp/repository/country_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryDataBloc extends Bloc<CountryDataEvent, CountryDataState> {
  final DataRepository countryDataRepository;

  CountryDataBloc({required this.countryDataRepository})
      : super(CountryDataEmpty()) {
    on<CountryDataEvent>((event, emit) async {
      emit(CountryDataLoading());
      try {
        // Assuming event.countryName is non-null based on CountryDataEvent definition
        final countryData =
            await countryDataRepository.getCountryData(event.countryName);
        if (countryData != null) {
          emit(CountryDataAvailable(countryData: countryData));
        } else {
          emit(CountryDataError());
        }
      } catch (e) {
        print(e);
        emit(CountryDataError());
      }
    });
  }
}
