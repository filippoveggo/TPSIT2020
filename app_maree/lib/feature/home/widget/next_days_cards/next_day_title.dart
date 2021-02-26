import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:app_maree/utils/global_utils.dart';
import 'package:flutter/cupertino.dart';

class NextDayTitle extends StatelessWidget {
  final List<PredictionDomainModel> predictions;
  const NextDayTitle({
    Key key,
    @required this.predictions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              /// todo: change to DateTime.now + one day
              Text(GlobalUtils.getDayNameFromDate(
                  predictions.elementAt(1).extremeDate)),
              Text(predictions.elementAt(1).value),
            ],
          ),
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: GlobalUtils.getColorFromTideValue(
                  predictions.elementAt(0).value),
            ),
          ),
        ],
      ),
    );
  }
}
