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
  Padding build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// todo: change to DateTime.now + one day
              Text(
                GlobalUtils.getDayNameFromDate(
                  GlobalUtils.getPredictionWithSameDate(
                    predictions,
                    DateTime.now(),
                  )[0]
                      .extremeDate,
                ),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                GlobalUtils.getTideDescriptionFromTideValue(
                  GlobalUtils.getPredictionWithSameDate(
                    predictions,
                    DateTime.now(),
                  )[0]
                      .value,
                ),
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
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
