import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:app_maree/feature/prediction/presentation/watcher/predictions_watcher_bloc.dart';
import 'package:app_maree/utils/global_utils.dart';
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
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return const Color.fromRGBO(122, 122, 122, 0.5);
    }
    return Colors.red;
  }

  bool showAvg = false;

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

  Stack buildChart({
    @required List<PredictionDomainModel> predictions,
  }) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 2.5,
          child: LineChart(
            showAvg ? avgData(predictions) : mainData(predictions),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: showAvg
                ? Text(
                    'min',
                    style: TextStyle(
                      fontSize: 12,
                      color: showAvg
                          ? Colors.white.withOpacity(0.5)
                          : Colors.white,
                    ),
                  )
                : Text(
                    'max',
                    style: TextStyle(
                      fontSize: 12,
                      color: showAvg
                          ? Colors.white.withOpacity(0.5)
                          : Colors.white,
                    ),
                  ),
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith(getColor)),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(List<PredictionDomainModel> predictions) {
    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: GlobalUtils.getSpotsMaxValue(predictions),
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
      titlesData: FlTitlesData(
        show: false,
      ),
      borderData: FlBorderData(show: false),
    );
  }

  LineChartData avgData(List<PredictionDomainModel> predictions) {
    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: GlobalUtils.getSpotsMinValue(predictions),
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
      titlesData: FlTitlesData(
        show: false,
      ),
      borderData: FlBorderData(show: false),
    );
  }
}
