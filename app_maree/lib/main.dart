import 'package:app_maree/feature/home/home_page.dart';
import 'package:app_maree/feature/levels/data/repository/levels_repository_impl.dart';
import 'package:app_maree/feature/map/next_days_page.dart';
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
import 'feature/prediction/presentation/map_watcher/predictions_map_watcher_bloc.dart';

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
        BlocProvider(
          create: (BuildContext context) => PredictionsMapWatcherBloc(
            predictionRepository: predictionRepository,
          ),
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
        // scaffoldBackgroundColor: const Color(0x0),
        brightness: Brightness.dark,
        //textTheme: GoogleFonts.poppinsTextTheme(),
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyBottomNavigationBar(),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;
  void changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomePage(),
          MapPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: changePage,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_day),
            label: 'Prossimi giorni',
          ),
        ],
        backgroundColor: Color.fromRGBO(22, 22, 22, 1.0),
        selectedItemColor: Color.fromRGBO(10, 132, 255, 1.0),
        unselectedItemColor: Color.fromRGBO(117, 117, 117, 1.0),
      ),
    );
  }
}
