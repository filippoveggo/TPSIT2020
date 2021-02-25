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

  Widget _buildNextHoursTideList({
    @required List<PredictionDomainModel> predictions,
  }) {
    // todo: Make this a list view with at least 5 items
    return Column(
      children: [
        /// todo: Change date format
        Text(predictions.elementAt(0).extremeDate.toString()),
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: GlobalUtils.getColorFromTideValue(predictions.elementAt(0).value),
          ),
        ),
        Text(predictions.elementAt(0).value),
      ],
    );
  }
}
