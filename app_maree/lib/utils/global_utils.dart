import 'dart:ffi';

import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:flutter/cupertino.dart';

class GlobalUtils {
  static String meterToCentimeter(List<String> toConvert) {
    //Initial List example: "[-0.45 m]"
    double myDouble = double.parse(toConvert.first.split(" ").first) * 100;
    //At this point myDouble is "-45.0"
    String converted = myDouble.toString();
    //At this point myDouble is "-45.0"
    return converted;
  }

  static Color getColorFromTideValue(String value) {
    double doubleValue = double.parse(value);
    Color color;
    if (doubleValue <= -90.0) {
      color = Color.fromRGBO(37, 167, 227, 1.0);
    } else if (doubleValue > -90.0 && doubleValue <= -50.0) {
      color = Color.fromRGBO(198, 198, 198, 1.0);
    } else if (doubleValue > -50.0 && doubleValue <= 80.0) {
      color = Color.fromRGBO(54, 188, 83, 1.0);
    } else if (doubleValue > 80.0 && doubleValue <= 110.0) {
      color = Color.fromRGBO(252, 220, 0, 1.0);
    } else if (doubleValue > 110.0 && doubleValue <= 140.0) {
      color = Color.fromRGBO(246, 162, 36, 1.0);
    } else if (doubleValue > 140.0) {
      color = Color.fromRGBO(237, 57, 60, 1.0);
    }
    return color;
  }

  static String getHourFromDate(DateTime date) {
    String hour = date.hour.toString() + ':' + date.minute.toString();
    return hour.toString();
  }

  static String getDayNameFromDate(DateTime date) {
    String day = GlobalUtils.getDayNameFromInt(date.weekday);
    return day;
  }

  static String getDayNameFromInt(int dateDay) {
    switch (dateDay) {
      case 0:
        break;
      case 1:
        return "Lunedì";
        break;
      case 2:
        return "Martedì";
        break;
      case 3:
        return "Mercoledì";
        break;
      case 4:
        return "Giovedì";
        break;
      case 5:
        return "Venerdì";
        break;
      case 6:
        return "Sabato";
        break;
      case 7:
        return "Domenica";
        break;
    }
    return "";
  }

  static List<PredictionDomainModel> getPredictionWithSameDate(int index, List<PredictionDomainModel> predictions){
    print(predictions.where((element) => element.extremeDate.day == DateTime.now().day + 1).toList());
    return predictions.where((element) => element.extremeDate.day == DateTime.now().day + 1).toList();
  }

  static int getNumberOfPredictionByDate(DateTime date){
    
    return 2;
  }
}
