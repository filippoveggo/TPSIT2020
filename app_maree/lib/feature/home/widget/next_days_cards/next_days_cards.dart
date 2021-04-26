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
    //BlocProvider.of<PredictionsWatcherBloc>(context).add(PredictionsReceived());
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
  return SizedBox(
    height: 170,
    child: ListView(
      scrollDirection: Axis.vertical,
      children: [
        _buildCard(predictions: predictions),
      ],
    ),
  );
}

Widget _buildCard({
  @required List<PredictionDomainModel> predictions,
}) {
  // Remember to start the list from +1 (next day)
  return Padding(
    padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            NextDayTitle(predictions: predictions),
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...List.generate(
                    3,
                    (index) {
                      return Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.keyboard_arrow_down),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Column(
                              children: [
                                Text(
                                  GlobalUtils.getPredictionWithSameDate(
                                        predictions,
                                        DateTime.now(),
                                      )[index]
                                          .value +
                                      ' cm',
                                ),
                                Text(
                                  GlobalUtils.getHourFromDate(
                                    GlobalUtils.getPredictionWithSameDate(
                                      predictions,
                                      DateTime.now(),
                                    )[index]
                                        .extremeDate,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  //Text('per ora');
}
