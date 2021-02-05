import 'package:app_maree/feature/levels/presentation/watcher/levels_watcher_bloc.dart';
import 'package:app_maree/feature/prediction/presentation/watcher/predictions_watcher_bloc.dart';
import 'package:flutter/cupertino.dart';
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
      child: BlocBuilder<PredictionsWatcherBloc, PredictionsWatcherEvent>(
        builder: (context, state) {
          print(state);
          if (state is PredictionsWatcherLoaded) {
            print("state");
            return Text("ciao");
          } else if (state is PredictionsWatcherFailure) {
            return Text("Dati non caricati");
          }
          return Text("Dati in caricamento (errore)");
        },
      ),
    );
  }
}
