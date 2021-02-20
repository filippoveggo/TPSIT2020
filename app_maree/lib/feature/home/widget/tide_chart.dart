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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
      child: BlocBuilder<PredictionsWatcherBloc, PredictionsWatcherState>(
        builder: (context, state) {
          print(state);
          if (state is PredictionsWatcherLoaded) {
            print("state");
            return Container(
              height: 200,
              width: 600,
              decoration: BoxDecoration(
                color: Colors.black26,
              ),
              child: Text("Dati caricati"),
            );
            //return buildChart(predictions: state.predictions);
          } else if (state is PredictionsWatcherFailure) {
            return Text("Dati non caricati");
          }
          return Text("Dati in caricamento (errore)");
        },
      ),
    );
  }

  Widget buildChart({
    @required List<PredictionDomainModel> predictions,
  }) {
    List<FlSpot> spots = [];
    for (double i = 0.0; i < predictions.length; i++) {
      spots.add(FlSpot(i, double.parse(predictions[i.toInt()].value)));
    }
    print(spots.toString());
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 14,
        minY: -50,
        maxY: 55,
        lineBarsData: [LineChartBarData(spots: spots)],
      ),
    );
  }
}
