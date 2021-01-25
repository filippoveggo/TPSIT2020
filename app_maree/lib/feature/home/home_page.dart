import 'package:app_maree/feature/levels/domain/model/level_domain_model.dart';
import 'package:app_maree/feature/levels/presentation/watcher/levels_watcher_bloc.dart';
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
    BlocProvider.of<LevelsWatcherBloc>(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Marea Attuale",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                BlocBuilder<LevelsWatcherBloc, LevelsWatcherState>(
                  builder: (context, state) {
                    print(state);
                    if (state is LevelsWatcherLoaded) {
                      print("state");
                      return buildCurrentTide(levels: state.levels);
                    } else if (state is LevelsWatcherFailure) {
                      return Text("Dati non caricati");
                    }
                    return Text("Dati in caricamento");
                  },
                ),
              ],
            )),
      ),
    );
  }

  Widget buildCurrentTide({
    @required List<LevelDomainModel> levels,
  }) {
    print("object");
    final currentTideStation =
        levels.where((element) => element.order == 1).map((e) => e.station);
    final currentTide =
        levels.where((element) => element.order == 1).map((e) => e.value);
    return Column(
      children: [
        Text(
          '$currentTideStation',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          '$currentTide',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
