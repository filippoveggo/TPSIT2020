import 'package:app_maree/feature/home/widget/next_days_cards/next_day_title.dart';
import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:app_maree/feature/prediction/presentation/map_watcher/predictions_map_watcher_bloc.dart';
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
    BlocProvider.of<PredictionsMapWatcherBloc>(context)
        .add(GetPredictionsMap());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child:
            BlocBuilder<PredictionsMapWatcherBloc, PredictionsMapWatcherState>(
          builder: (context, state) {
            if (state is PredictionsMapWatcherLoaded) {
              return _buildNextDaysCards(predictions: state.map);
            } else if (state is PredictionsMapWatcherFailure) {
              return Text("Dati non caricati");
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildNextDaysCards({
  @required Map<DateTime, List<PredictionDomainModel>> predictions,
}) {
  return SizedBox(
    height: 450,
    child: ListView.builder(
      itemCount: predictions.keys.length,
      itemBuilder: (BuildContext context, int index) {
        final predictionsForThisDay =
            predictions[predictions.keys.elementAt(index)];
        //return Text(predictions.keys.elementAt(index).toString());

        return _buildCard(predictions: predictionsForThisDay);
      },
    ),
  );
  //return SizedBox(
  //  height: 450,
  //  child: ListView.builder(
  //    //physics: NeverScrollableScrollPhysics(),
  //    itemCount: 3,
  //    itemBuilder: (context, index) {
  //      return _buildCard(predictions: predictions);
  //    },
  //  ),
  //  //_buildCard(predictions: predictions),
  //);
}

Widget _buildCard({
  @required List<PredictionDomainModel> predictions,
}) {
  // Remember to start the list from +1 (next day)
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 2,
    child: Column(
      children: [
        Text(GlobalUtils.getDayNameFromDate(predictions[0].extremeDate)),
      ],
    ),
  );
  return Padding(
    padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 0.0),
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
              height: 34,
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
                                  GlobalUtils.getPredictionsByDate(
                                          predictions, DateTime.now())[index][0]
                                      .extremeDate
                                      .toString(),
                                ),
                                Text(
                                  GlobalUtils.getPredictionsByDate(predictions,
                                          DateTime.now())[index][index]
                                      .value,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    //scrollDirection: Axis.horizontal,
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
