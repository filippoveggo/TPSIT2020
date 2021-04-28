import 'package:app_maree/feature/home/home_page.dart';
import 'package:app_maree/feature/levels/data/repository/levels_repository_impl.dart';
import 'package:app_maree/feature/prediction/data/datasource/predictions_remote_datasource.dart';
import 'package:app_maree/feature/prediction/data/repository/predictions_repository_impl.dart';
import 'package:app_maree/feature/prediction/presentation/watcher/predictions_watcher_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature/levels/data/datasource/levels_remote_datasource.dart';
import 'feature/levels/domain/repository/level_repository.dart';
import 'feature/levels/presentation/watcher/levels_watcher_bloc.dart';

void main() {
  final LevelRepository levelRepository = LevelsRepositoryImpl(
      levelsRemoteDatasource: LevelsRemoteDatasource(dio: Dio()));
  final PredictionsRepositoryImpl predictionRepository =
      PredictionsRepositoryImpl(
          predictionsRemoteDatasource: PredictionsRemoteDatasource(dio: Dio()));

  // trasparent status bar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              LevelsWatcherBloc(levelRepository: levelRepository),
        ),
        BlocProvider(
          create: (BuildContext context) => PredictionsWatcherBloc(
              predictionRepository: predictionRepository),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0x0),
        brightness: Brightness.dark,
        //textTheme: GoogleFonts.poppinsTextTheme(),
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<LevelsWatcherBloc, LevelsWatcherState>(
              builder: (context, state) {
                if (state is LevelsWatcherLoaded) {
                  // return Text(state.rooms.length.toString());
                  if (state.levels.length == 0) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 4.0,
                      ),
                    );
                  }
                  //return ListView.builder(
                  //  itemCount: state.levels.length,
                  //  itemBuilder: (context, i) =>
                  //      new Text(state.levels.map((e) => e.nomeAbbr).elementAt(i)),
                  //);
                  //return ListView(
                  //  children: [
                  //    Text(state.levels.map((e) => e.nomeAbbr)),
                  //  ],
                  //);
                } else if (state is LevelsWatcherFailure) {
                  return Center(
                    child: Icon(Icons.error),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
            //FutureBuilder(
            //  future: LevelsRepositoryImpl(levelsRemoteDatasource: LevelsRemoteDatasource(dio: Dio())).getLevels(),
            //  initialData: Resource.loading<List<LevelDomainModel>>(),
            //  builder: (BuildContext context, AsyncSnapshot<Resource<List<LevelDomainModel>>> snapshot) {
            //    if(snapshot.data.status == Status.success) {
            //      return Text(snapshot.data.data[0].station);
            //    }
            //    return CircularProgressIndicator();
            //  },
            //),
          ],
        ),
      ),
    );
  }
}
