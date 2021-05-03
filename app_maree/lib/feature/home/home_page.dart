import 'package:app_maree/feature/home/widget/current_tide.dart';
import 'package:app_maree/feature/home/widget/next_days_cards/next_days_cards.dart';
import 'package:app_maree/feature/home/widget/next_hours_tide.dart';
import 'package:app_maree/feature/home/widget/tide_chart.dart';
import 'package:app_maree/feature/map/next_days_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return;
          },
          child: ListView(
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
              CurrentTide(),
              Divider(
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: Text(
                  "Prossime previsioni",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TideChart(),
              Divider(
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: Text(
                  "Prossime ore",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              NextHoursTide(),
              Divider(
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Prossimi giorni",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Color.fromRGBO(10, 132, 255, 1.0),
                    )
                  ],
                ),
              ),
              NextDaysCards(),
            ],
          ),
        ),
      ),
    );
  }
}
