import 'package:crownapp/bloc/splash/splash_event.dart';
import 'package:crownapp/bloc/splash/splash_state.dart';
import 'package:crownapp/repository/country_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashBloc extends Bloc<CountryListEvent, CountryListState> {
  final DataRepository countryDataRepository;

  SplashBloc({required this.countryDataRepository})
      : super(CountryListEmpty()) {
    on<CountryListEvent>((event, emit) async {
      emit(CountryListLoading());
      try {
        final countryList = await countryDataRepository.getAffectedCountries();
        if (countryList != null) {
          emit(CountryListAvailable(countryList: countryList));
        } else {
          emit(CountryListError());
        }
      } catch (e) {
        print(e);
        emit(CountryListError());
      }
    });
  }
}
