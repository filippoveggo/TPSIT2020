import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:app_maree/feature/prediction/presentation/watcher/predictions_watcher_bloc.dart';
import 'package:app_maree/utils/global_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NextHoursTide extends StatefulWidget {
  NextHoursTide({Key key}) : super(key: key);

  @override
  _NextHoursTideState createState() => _NextHoursTideState();
}

class _NextHoursTideState extends State<NextHoursTide> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PredictionsWatcherBloc>(context).add(PredictionsReceived());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<PredictionsWatcherBloc, PredictionsWatcherState>(
        builder: (context, state) {
          if (state is PredictionsWatcherLoaded) {
            return _buildNextHoursTideList(predictions: state.predictions);
          } else if (state is PredictionsWatcherFailure) {
            return Text("Dati non caricati");
          }
          return Text("Dati in caricamento (errore)");
        },
      ),
    );
  }

  NotificationListener<OverscrollIndicatorNotification>
      _buildNextHoursTideList({
    @required List<PredictionDomainModel> predictions,
  }) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return;
      },
      child: SizedBox(
        height: 90,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...List.generate(
              // The number is indicative, with this you can see only one day predictions
              predictions.length - 9,
              (index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(GlobalUtils.getHourFromDate(
                            predictions.elementAt(index).extremeDate)),
                      ),
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: GlobalUtils.getColorFromTideValue(
                              predictions.elementAt(index).value),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(predictions.elementAt(index).value + ' cm'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
