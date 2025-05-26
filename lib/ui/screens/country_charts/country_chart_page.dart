import 'package:country_pickers/utils/utils.dart';
import 'package:crownapp/model/response/country_data.dart';
import 'package:crownapp/ui/widgets/charts/numeric_linear_chart.dart';
import 'package:crownapp/ui/widgets/charts/numeric_stacked_bar_chart.dart';
import 'package:crownapp/utils/country_utils.dart';
import 'package:crownapp/utils/platform_utils.dart';
import 'package:crownapp/utils/text_style.dart';
import 'package:flutter/material.dart';

class CountryChartPage extends StatelessWidget {
  final List<CountryData> countryData;
  final String countryCode;

  const CountryChartPage({Key? key, required this.countryData, required this.countryCode}) : super(key: key); // Added const, Key and required

  @override
  Widget build(BuildContext context) {
    final countryName = countryData.isNotEmpty ? countryData[0].country ?? "N/A" : "N/A"; // Added null check and default

    final listOfConfirmed = countryData
        .map((e) => NumericChartData(e.date!, e.confirmed ?? 0)) // Added null checks and defaults
        .toList();
    final listOfDeaths = countryData
        .map((e) => NumericChartData(e.date!, e.deaths ?? 0)) // Added null checks and defaults
        .toList();
    final listOfRecovered = countryData
        .map((e) => NumericChartData(e.date!, e.recovered ?? 0)) // Added null checks and defaults
        .toList();

    return Scaffold(
        appBar: AppBar(
          leading: Container(), // Consider adding a back button if appropriate
          title: Material( // This Material widget might be redundant
            type: MaterialType.transparency,
            child: Center(
              child: Row(children: <Widget>[
                Hero(
                  tag: heroCountryFlag,
                  child: CircleAvatar(
                    radius: 14.0,
                    backgroundImage: AssetImage(
                      CountryPickerUtils.getFlagImageAssetPath(countryCode),
                      package: country_icons_package, // This might be an issue if not defined elsewhere
                    ),
                  ),
                ),
                const SizedBox(width: 5), // Made const
                Text( // Removed Title and Hero for simplicity, can be added back if animations are crucial
                  countryName,
                  style: Style.strongTitleTextStyle,
                ),
              ]),
            ),
          ),
        ),
        body: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: const Color.fromRGBO(0, 116, 227, 1),
          child: CustomScrollView(
            // controller: ScrollController(), // Not strictly necessary unless you need to interact with it
            physics: const ClampingScrollPhysics(), // Made const
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    NumericLinearChart(
                      countryData: listOfConfirmed,
                      countryName: countryName,
                      chartHeader: Status.CONFIRMED.toString().split('.').last, // Get only enum value name
                    ),
                    NumericLinearChart(
                      countryData: listOfDeaths,
                      countryName: countryName,
                      chartHeader: Status.DEATHS.toString().split('.').last, // Get only enum value name
                    ),
                    NumericLinearChart(
                      countryData: listOfRecovered,
                      countryName: countryName,
                      chartHeader: Status.RECOVERED.toString().split('.').last, // Get only enum value name
                    ),
                    StackedBarChart(
                      countryData: countryData,
                      countryName: countryName,
                      chartHeader: "Cumulative",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        backgroundColor: const Color(0xff8585a3), // Made const
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.arrow_back), // Made const
            backgroundColor: const Color(0xff474775), // Made const
            elevation: 5.0,
            heroTag: 'fab', // Ensure this tag is unique if multiple FABs exist across routes
            onPressed: () {
              Navigator.pop(context);
            }));
  }
}
