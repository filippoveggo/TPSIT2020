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
}
