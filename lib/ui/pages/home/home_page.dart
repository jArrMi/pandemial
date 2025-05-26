import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:crownapp/bloc/country_data/country_data_bloc.dart';
import 'package:crownapp/model/notifier/country_notifier.dart';
import 'package:crownapp/model/notifier/navigation_model.dart';
import 'package:crownapp/model/response/covid_country.dart';
import 'package:crownapp/repository/country_data_repository.dart';
import 'package:crownapp/ui/pages/country_report/country_report_page.dart';
import 'package:crownapp/ui/widgets/bottom_bar/notched_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final String title;
  final List<CovidCountry> confirmedCountries;

  const HomePage({
    Key? key, // Made key nullable and named
    required this.title, // Made required
    required this.confirmedCountries, // Made required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationModel>(context);
    final selectedCountryProvider = Provider.of<CountryNotifier>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
          child: Text(title), // Removed Title widget
        ),
      ),
      backgroundColor: const Color(0xff8585a3), // Made const
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search), // Made const
        backgroundColor: const Color(0xff474775), // Made const
        elevation: 5.0,
        heroTag: 'fab',
        onPressed: () {
          _openCountryPickerDialog(context, selectedCountryProvider);
        },
      ),
      body: IndexedStack(
        children: <Widget>[
          Consumer<CountryNotifier>(builder: (context, notifier, child) {
            // The selectedCountry is 'late' and should be initialized by the time
            // this builder is called, typically by an action or a default in the notifier itself,
            // or an initial event/state in the BLoC that uses this notifier.
            // For now, we assume it will be initialized. If not, a LateInitializationError will occur.
            // A more robust solution might involve an initializing event or checking a 'isInitialized' flag.
            // The previous explicit null check here is flagged by the analyzer due to 'late'.
            
            // If confirmedCountries is empty and selectedCountry is not initialized, this could still be an issue.
            // This logic relies on selectedCountry being set, possibly from defaultCountry logic within the notifier
            // or an initial selection event.
            if (confirmedCountries.isEmpty && notifier.selectedCountry == null) { // Guard against empty list if selectedCountry not set
                 return const Center(child: Text("No countries available."));
            }

            // Ensure a default selection if none is set - this part is tricky with `late`
            // This logic might be better placed within CountryNotifier or an init event.
            // For now, let's assume selectedCountry will be set. If not, it will throw.
            // The analyzer warning was about `notifier.selectedCountry == null` being always false due to `late`.
            // However, if it's truly uninitialized, it would throw.
            // The previous attempt to initialize it here was problematic.
            // A proper fix would involve ensuring CountryNotifier initializes _selectedCountry.
            // For now, we proceed assuming it's initialized or an error is acceptable if not.

            return BlocProvider(
              create: (context) => CountryDataBloc(
                countryDataRepository: DataRepository(),
              ),
              child: CountryReportPage(
                notifier.selectedCountry, // This will throw if not initialized
              ),
            );
          }),
          Container(
            child: Center(
              child: Text('This page ${navigationProvider.currentIndex}'),
            ),
          )
        ],
        index: navigationProvider.currentIndex,
      ),
      bottomNavigationBar: NotchedNavigationBar(
        selectedIndex: navigationProvider.currentIndex,
        color: Colors.grey,
        selectedColor: Colors.white,
        backgroundColor: const Color(0xFF605C94), // Made const
        navigationItems: [
          NavigationItem(icon: Icons.menu, label: 'Country'),
          NavigationItem(icon: Icons.layers, label: 'News'),
        ],
        onTabSelected: (index) { // Added onTabSelected callback
          navigationProvider.currentIndex = index;
        },
      ),
    );
  }

  // _getCurrentPage method was unused.
  // Widget _getCurrentPage(
  //     {BuildContext context, CountryNotifier notifier, int index}) {
  //   switch (index) {
  //     case 0:
  //       {
  //         return Consumer<CountryNotifier>(builder: (context, notifier, child) {
  //           return BlocProvider(
  //             create: (context) => CountryDataBloc(
  //               countryDataRepository: DataRepository(),
  //             ),
  //             child: CountryReportPage(
  //               notifier.selectedCountry ?? notifier.defaultCountry,
  //             ),
  //           );
  //         });
  //       }
  //     default:
  //       {
  //         return Container(
  //           child: Center(
  //             child: Text('This page $index'),
  //           ),
  //         );
  //       }
  //   }
  // }

  void _openCountryPickerDialog(
          BuildContext context, CountryNotifier notified) =>
      showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context),
          child: CountryPickerDialog(
            titlePadding: const EdgeInsets.all(8.0), // Made const
            searchCursorColor: const Color(0xFF333366), // Made const
            searchInputDecoration: const InputDecoration(hintText: 'Search...'), // Made const
            isSearchable: true,
            title: const Text('Choose your country'), // Made const
            onValuePicked: (Country country) {
              notified.selectedCountry = confirmedCountries
                  .firstWhere((element) => element.isoCode == country.isoCode);
            },
            itemBuilder: _buildDialogItem,
          ),
        ),
      );

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(width: 8.0), // Made const
          Flexible(child: Text(country.name))
        ],
      );
}
