import 'package:app_maree/feature/levels/domain/model/level_domain_model.dart';
import 'package:app_maree/feature/levels/presentation/watcher/levels_watcher_bloc.dart';
import 'package:app_maree/feature/prediction/presentation/watcher/predictions_watcher_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<LevelsWatcherBloc>(context).add(LevelsReceived());
    BlocProvider.of<PredictionsWatcherBloc>(context).add(PredictionsReceived());
    //Timer.periodic(Duration(seconds: 5), (Timer t) => BlocProvider.of<LevelsWatcherBloc>(context).add(LevelsReceived()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Text(
                "Marea Attuale",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              child: BlocBuilder<LevelsWatcherBloc, LevelsWatcherState>(
                builder: (context, state) {
                  print(state);
                  if (state is LevelsWatcherLoaded) {
                    print("state");
                    return buildCurrentTide(levels: state.levels);
                  } else if (state is LevelsWatcherFailure) {
                    return Text("Dati non caricati");
                  }
                  return Text("Dati in caricamento (errore)");
                },
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Text(
                "La marea di oggi",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            //Padding(
            //  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
            //  child: BlocBuilder<PredictionsWatcherBloc,PredictionsWatcherEvent>(
            //    builder: (context, state) {
            //      print(state);
            //      if (state is PredictionsWatcherLoaded) {
            //        print("state");
            //        return Text("ciao");
            //      } else if (state is LevelsWatcherFailure) {
            //        return Text("Dati non caricati");
            //      }
            //      return Text("Dati in caricamento (errore)");
            //    },
            //  ),
            //),
          ],
        ),
      ),
    );
  }

  Widget buildCurrentTide({
    @required List<LevelDomainModel> levels,
  }) {
    print("object");
    final currentTideStation = levels
        .where((element) => element.nomeAbbr == "PS_Giud")
        .map((e) => e.station);
    final currentTide = levels
        .where((element) => element.nomeAbbr == "PS_Giud")
        .map((e) => e.value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${currentTideStation.first}',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0.0),
          child: Row(
            children: [
              Text(
                '${currentTide.first}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
