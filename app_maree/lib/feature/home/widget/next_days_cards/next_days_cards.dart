import 'package:app_maree/feature/home/widget/next_days_cards/next_day_title.dart';
import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:app_maree/feature/prediction/presentation/watcher/predictions_watcher_bloc.dart';
import 'package:app_maree/utils/global_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NextDaysCards extends StatefulWidget {
  NextDaysCards({Key key}) : super(key: key);

  @override
  _NextDaysCardsState createState() => _NextDaysCardsState();
}

class _NextDaysCardsState extends State<NextDaysCards> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PredictionsWatcherBloc>(context).add(PredictionsReceived());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: BlocBuilder<PredictionsWatcherBloc, PredictionsWatcherState>(
          builder: (context, state) {
            if (state is PredictionsWatcherLoaded) {
              return _buildNextDaysCards(predictions: state.predictions);
            } else if (state is PredictionsWatcherFailure) {
              return Text("Dati non caricati");
            }
            return Text("Dati in caricamento (errore)");
          },
        ),
      ),
    );
  }
}

Widget _buildNextDaysCards({
  @required List<PredictionDomainModel> predictions,
}) {
  // Remember to start the list from +1 (next day)
  return Card(
    elevation: 2,
    child: Column(
      children: [
        NextDayTitle(predictions: predictions),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...List.generate(
                  3,
                  (index) {
                    return Row(
                      children: [
                        Icon(Icons.keyboard_arrow_down),
                        Column(
                          children: [
                            Text(GlobalUtils.getHourFromDate(
                                GlobalUtils.getPredictionWithSameDate(
                                        index, predictions)[index]
                                    .extremeDate)),
                          ],
                        ),
                      ],
                    );
                    //Text(index.toString());
                    //print(predictions.where((element) => element.extremeDate.day == DateTime.now().day + index).toList().toString());
                    //predictions.where((element) => element.extremeDate.day == DateTime.now().day + index).toList();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
  //Text('per ora');
}
