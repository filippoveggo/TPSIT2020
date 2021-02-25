import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:app_maree/feature/prediction/presentation/watcher/predictions_watcher_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TideChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TideChartState();
}

class _TideChartState extends State<TideChart> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PredictionsWatcherBloc>(context).add(PredictionsReceived());
  }

  List<Color> uniqueColor = [
    const Color.fromRGBO(122, 122, 122, 1),
  ];
  List<Color> gradientColors = [
    const Color.fromRGBO(122, 122, 122, 1).withOpacity(0.5),
    const Color.fromRGBO(0, 0, 0, 0)
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 10.0),
      child: BlocBuilder<PredictionsWatcherBloc, PredictionsWatcherState>(
        builder: (context, state) {
          if (state is PredictionsWatcherLoaded) {
            return buildChart(predictions: state.predictions);
          } else if (state is PredictionsWatcherFailure) {
            return Text("Dati non caricati");
          }
          return Text("Dati in caricamento (errore)");
        },
      ),
    );
  }

  AspectRatio buildChart({
    @required List<PredictionDomainModel> predictions,
  }) {
    List<FlSpot> spots = [];
    for (double i = 0.0; i < predictions.length; i++) {
      spots.add(FlSpot(i, double.parse(predictions[i.toInt()].value)));
    }
    return AspectRatio(
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
    );
  }
}
