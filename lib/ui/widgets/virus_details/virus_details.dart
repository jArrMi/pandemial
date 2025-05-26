import 'package:country_pickers/country_pickers.dart'; // Used CountryPickerUtils
import 'package:crownapp/bloc/chart/country_chart_bloc.dart';
import 'package:crownapp/model/models.dart';
import 'package:crownapp/repository/country_data_repository.dart';
import 'package:crownapp/ui/screens/country_charts/country_chart_page.dart';
import 'package:crownapp/utils/crown_app_icons.dart';
import 'package:crownapp/utils/platform_utils.dart';
import 'package:crownapp/utils/text_style.dart';
// import 'package:flutter/cupertino.dart'; // Unnecessary import
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class VirusDetails extends StatelessWidget {
  final List<CountryData> countryData;
  final String countryCode;

  const VirusDetails({Key? key, required this.countryData, required this.countryCode}) : super(key: key); // Added const and Key

  @override
  Widget build(BuildContext context) {
    // Handle cases where countryData might be empty or null
    if (countryData.isEmpty) {
      return const Center(child: Text("No data available")); // Or a loading indicator
    }
    final latestReport = countryData.last;
    final latestUpdate = latestReport.date; // Already nullable in CountryData
    final latestActive = latestReport.active ?? 0;
    final latestConfirmed = latestReport.confirmed ?? 0;
    final latestDeaths = latestReport.deaths ?? 0;
    final latestRecovered = latestReport.recovered ?? 0;
    final countryName = latestReport.country ?? "N/A";

    // Country Details
    final virusDetails = Container(
      margin: const EdgeInsets.fromLTRB( // Made const
        30.0,
        16.0,
        16.0,
        7.5,
      ),
      constraints: const BoxConstraints.expand(), // Made const
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 1), // Made const
          Padding(
            padding: const EdgeInsets.only(left: 26.0), // Made const
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: heroCountryName, // Assuming heroCountryName is a const defined elsewhere
                    child: Text(
                      countryName,
                      style: Style.strongTitleTextStyle,
                    ),
                  ),
                  Text(
                    'Active cases: ${Style.numberFormatter.format(latestActive)}',
                    style: Style.subtitleTextStyle,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10), // Made const
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _statDetail(
                value:
                    '${Style.numberFormatter.format(latestConfirmed)} \nConfirmed',
                image: CrownApp.ic_font_mask,
              ),
              _statDetail(
                value: '${Style.numberFormatter.format(latestDeaths)} \nDeaths',
                image: CrownApp.ic_font_death,
              ),
              _statDetail(
                value:
                    '${Style.numberFormatter.format(latestRecovered)} \nRecovered',
                image: CrownApp.ic_font_recovered,
              ),
            ],
          ),
          const SizedBox(height: 8), // Made const
          Padding(
            padding: const EdgeInsets.only(left: 1.0), // Made const
            child: Text(
              // Handle null latestUpdate
              'Last update: ${latestUpdate != null ? DateFormat("dd-MM-yyyy").format(latestUpdate) : "N/A"}',
              style: Style.commonTextStyle,
            ),
          ),
          GestureDetector(
            child: Padding( // Removed const
              padding: EdgeInsets.only(left: 1.0),
              child: Text(
                'View more details',
                style: Style.hyperlink,
              ),
            ),
            onTap: () => { // Keep the original arrow function for onTap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => CountryChartBloc(
                      countryDataRepository: DataRepository(),
                    ),
                    child: CountryChartPage(
                      countryData: countryData,
                      countryCode: countryCode,
                    ),
                  ),
                ),
              )
            },
          )
        ],
      ),
    );

    return Container(
      height: 300.0,
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: Stack(
        children: <Widget>[
          _getCardDecoration(virusDetails),
          _getCountryIcon(countryCode),
        ],
      ),
    );
  }

  Widget _statDetail({required String value, required IconData image}) => Column( // Made parameters required
        children: <Widget>[
          Icon(
            image,
            size: 36.0,
            color: Colors.white,
          ),
          const SizedBox(height: 3.0), // Made const
          Text(
            value,
            textAlign: TextAlign.center,
            style: Style.commonTextStyle,
          ),
        ],
      );

  Widget _getCardDecoration(Widget child) => Container(
        constraints: const BoxConstraints.expand(), // Made const
        child: child,
        margin: const EdgeInsets.only( // Made const
          left: 47.5,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF333366),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(
            8.0,
          ),
          boxShadow: const <BoxShadow>[ // Made const
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            )
          ],
        ),
      );

  Widget _getCountryIcon(String countryIsoCode) => Container(
        padding: const EdgeInsets.only(top: 10.0), // Made const
        height: 95.0,
        width: 95.0,
        child: Center(
          child: Hero(
            tag: heroCountryFlag, // Assuming heroCountryFlag is a const defined elsewhere
            child: CircleAvatar(
              radius: 42.0,
              backgroundImage: AssetImage(
                CountryPickerUtils.getFlagImageAssetPath(countryIsoCode),
                package: CountryPickerUtils.countryPickerUtilsPackageName, // Corrected package name
              ),
            ),
          ),
        ),
      );
}
