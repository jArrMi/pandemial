import 'package:crownapp/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Assuming isCardView is a global or defined elsewhere.
// For this refactoring, I'll assume it's a boolean that's available.
// If not, it would need to be passed as a parameter or handled differently.
const bool isCardView = false; // Placeholder: replace with actual logic if available

class NumericLinearChart extends StatelessWidget {
  final List<NumericChartData> countryData;
  final String countryName;
  final String? chartTitle; // Made nullable
  final String chartHeader;

  const NumericLinearChart({ // Added const
    Key? key, // Added Key
    required this.countryData,
    required this.countryName,
    this.chartTitle,
    required this.chartHeader,
  }) : super(key: key); // Added Key

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(250, 250, 250, 1),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Card(
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Column(
              children: <Widget>[
                InkWell(
                  splashColor: Colors.grey.withOpacity(0.4),
                  onTap: () {
                    /*Feedback.forLongPress(context);
                    expandSample(context, list[position], model);*/
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            chartHeader,
                            textAlign: TextAlign.left,
                            softWrap: true,
                            textScaleFactor: 1,
                            overflow: TextOverflow.fade,
                            style: const TextStyle( // Made const
                                fontFamily: 'HeeboMedium',
                                fontSize: 16.0,
                                color: Color.fromRGBO(51, 51, 51, 1),
                                letterSpacing: 0.2),
                          ),
                          Container(
                              child: Row(
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(left: 15),
                              ),
                              /*Container(
                                    height: 24,
                                    width: 24,
                                    color: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          5, 0, 5, 5),
                                      child: Image.asset(
                                          'images/fullscreen.png',
                                          fit: BoxFit.contain,
                                          height: 20,
                                          width: 20,
                                          color: model.backgroundColor),
                                    ),
                                  ),*/
                            ],
                          )),
                        ]),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: SizedBox(
                      width: double.infinity,
                      height: 230,
                      child: _buildChart(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SfCartesianChart _buildChart() => SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: isCardView ? '' : chartTitle ?? ''), // Handle null chartTitle
        legend: Legend(
            isVisible: isCardView ? false : true, // Assuming isCardView is available
            overflowMode: LegendItemOverflowMode.wrap),
        primaryXAxis: DateTimeAxis(
            intervalType: DateTimeIntervalType.months,
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            dateFormat: DateFormat.yMd(),
            interval: 1,
            majorGridLines: const MajorGridLines(width: 0)), // Made const
        primaryYAxis: NumericAxis(
            labelFormat: '{value}',
            numberFormat: Style.numberFormatter,
            axisLine: const AxisLine(width: 0), // Made const
            majorTickLines: const MajorTickLines(color: Colors.transparent)), // Made const
        series: _getChartLineSeries(countryData),
        tooltipBehavior: TooltipBehavior(enable: true, canShowMarker: false),
      );

  List<LineSeries<NumericChartData, DateTime>> _getChartLineSeries(
          List<NumericChartData> data) => // data parameter is used here
      <LineSeries<NumericChartData, DateTime>>[
        LineSeries<NumericChartData, DateTime>(
          animationDuration: 2500,
          enableTooltip: true,
          dataSource: data, // Use the data parameter
          xValueMapper: (NumericChartData sales, _) => sales.x,
          yValueMapper: (NumericChartData sales, _) => sales.y,
          width: 2,
          name: countryName,
          markerSettings: const MarkerSettings(isVisible: false), // Made const
        ),
      ];
}

class NumericChartData {
  NumericChartData(this.x, this.y);

  final DateTime x;
  final num y;
}
