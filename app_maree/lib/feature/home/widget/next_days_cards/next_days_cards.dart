import 'package:app_maree/feature/home/widget/next_days_cards/widget/next_day_description.dart';
import 'package:app_maree/feature/home/widget/next_days_cards/widget/next_day_title.dart';
import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:app_maree/feature/prediction/presentation/map_watcher/predictions_map_watcher_bloc.dart';
import 'package:app_maree/feature/single_day/single_day_page.dart';
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

  Widget _buildNextDaysCards({
    @required Map<DateTime, List<PredictionDomainModel>> predictions,
  }) {
    return SizedBox(
      height: 450,
      child: ListView.builder(
        itemCount: predictions.keys.length - 2,
        itemBuilder: (BuildContext context, int index) {
          final predictionsForThisDay =
              predictions[predictions.keys.elementAt(index + 1)];

          return _buildCard(predictions: predictionsForThisDay);
        },
      ),
    );
  }

  Widget _buildCard({
    @required List<PredictionDomainModel> predictions,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 0.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SingleDayPage(
                predictions: predictions,
              ),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                NextDayTitle(
                  predictions: predictions,
                ),
                NextDayDesciption(
                  predictions: predictions,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
