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
        height: 104,
        child: ListView.builder(
          itemCount: predictions.length - 6,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 8.0),
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
    );
  }
}
