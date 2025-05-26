import 'package:crownapp/bloc/chart/country_chart_event.dart';
import 'package:crownapp/bloc/chart/country_chart_state.dart';
import 'package:crownapp/repository/country_data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryChartBloc extends Bloc<CountryChartEvent, CountryChartState> {
  final DataRepository countryDataRepository;

  CountryChartBloc({required this.countryDataRepository})
      : super(CountryChartEmpty()) {
    on<CountryChartEvent>((event, emit) async {
      emit(CountryChartLoading());
      try {
        // Assuming event.countryName and event.status are non-null
        // based on the CountryChartEvent definition.
        final countryChart = await countryDataRepository.getChartDetails(
            event.countryName, event.status);

        if (countryChart != null) {
          emit(CountryChartAvailable(countryChart: countryChart));
        } else {
          emit(CountryChartError());
        }
      } catch (e) {
        print(e);
        emit(CountryChartError());
      }
    });
  }
}
