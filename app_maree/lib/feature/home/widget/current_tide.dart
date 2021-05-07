import 'package:app_maree/feature/levels/domain/model/level_domain_model.dart';
import 'package:app_maree/feature/levels/presentation/watcher/levels_watcher_bloc.dart';
import 'package:app_maree/utils/global_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentTide extends StatefulWidget {
  CurrentTide({Key key}) : super(key: key);

  @override
  _CurrentTideState createState() => _CurrentTideState();
}

class _CurrentTideState extends State<CurrentTide> {
  @override
  void initState() {
    BlocProvider.of<LevelsWatcherBloc>(context).add(LevelsReceived());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
      child: BlocBuilder<LevelsWatcherBloc, LevelsWatcherState>(
        builder: (context, state) {
          if (state is LevelsWatcherLoaded) {
            return buildCurrentTide(levels: state.levels);
          } else if (state is LevelsWatcherFailure) {
            return Text("Dati non caricati");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  // todo: active API
  Widget buildCurrentTide({
    @required List<LevelDomainModel> levels,
  }) {
    final currentTideStation = levels
        .where((element) => element.nomeAbbr == "PS_Giud")
        .map((e) => e.station)
        .toList();
    final currentTide = levels
        .where((element) => element.nomeAbbr == "PS_Giud")
        .map((e) => e.value)
        .toList();

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
                '${GlobalUtils.meterToCentimeter(currentTide) + " cm"}',
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
                  color: GlobalUtils.getColorFromTideValue(GlobalUtils.meterToCentimeter(currentTide)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
