import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:app_maree/utils/global_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleDayPage extends StatelessWidget {
  final List<PredictionDomainModel> predictions;
  const SingleDayPage({
    Key key,
    @required this.predictions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> uniqueColor = [
      const Color.fromRGBO(122, 122, 122, 1),
    ];
    List<Color> gradientColors = [
      const Color.fromRGBO(122, 122, 122, 1).withOpacity(0.5),
      const Color.fromRGBO(0, 0, 0, 0)
    ];
    List<FlSpot> spots = [];
    for (double i = 0.0; i < predictions.length; i++) {
      spots.add(FlSpot(i, double.parse(predictions[i.toInt()].value)));
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Color.fromRGBO(10, 132, 255, 1.0),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          GlobalUtils.getDayNameFromDate(
            predictions.elementAt(0).extremeDate,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "La marea sarà ",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        GlobalUtils.getTideDescriptionFromTideValue(
                          predictions.elementAt(0).value,
                        ),
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.6),
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: GlobalUtils.getColorFromTideValue(
                          predictions.elementAt(0).value),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Text(
                "Previsione",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: AspectRatio(
                aspectRatio: 2.5,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        colors: uniqueColor,
                        isCurved: true,
                        dotData: FlDotData(
                          show: false,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          colors: gradientColors,
                          gradientColorStops: [0.5, 1.0],
                          gradientFrom: const Offset(0, 0),
                          gradientTo: const Offset(0, 1),
                        ),
                      ),
                    ],
                    gridData: FlGridData(
                      show: false,
                    ),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Text(
                "Orari",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
                return;
              },
              child: SizedBox(
                height: 104,
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 32.0, 8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              GlobalUtils.getHourFromDate(
                                  predictions.elementAt(index).extremeDate),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          predictions.elementAt(index).extremeType == "min"
                              ? Icon(
                                  Icons.keyboard_arrow_down,
                                  color: GlobalUtils.getColorFromTideValue(
                                      predictions.elementAt(index).value),
                                )
                              : Icon(
                                  Icons.keyboard_arrow_up,
                                  color: GlobalUtils.getColorFromTideValue(
                                      predictions.elementAt(index).value),
                                ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              predictions.elementAt(index).value + ' cm',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
