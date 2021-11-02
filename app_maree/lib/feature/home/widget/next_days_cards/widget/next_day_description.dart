import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:app_maree/utils/global_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NextDayDesciption extends StatelessWidget {
  final List<PredictionDomainModel> predictions;
  const NextDayDesciption({
    Key key,
    @required this.predictions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...List.generate(
            3,
            (index) {
              return Row(
                children: [
                  predictions.elementAt(index).extremeType == "min"
                      ? Icon(Icons.keyboard_arrow_down)
                      : Icon(Icons.keyboard_arrow_up),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(predictions.elementAt(index).value + ' cm'),
                        Text(GlobalUtils.getHourFromDate(
                          predictions.elementAt(index).extremeDate,
                        )),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
