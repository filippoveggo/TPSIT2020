import 'dart:convert';

import 'package:app_maree/feature/prediction/data/models/prediction_remote_model.dart';


class PredictionDomainModel {
  DateTime previsionDate;
  DateTime extremeDate;
  String extremeType;
  String value;

  PredictionDomainModel({
    this.previsionDate,
    this.extremeDate,
    this.extremeType,
    this.value,
  });

  PredictionDomainModel.fromRemoteModel(PredictionRemoteModel remote) {
    this.previsionDate = DateTime.parse(remote.dATAPREVISIONE);
    this.extremeDate = DateTime.parse(remote.dATAESTREMALE);
    this.extremeType = remote.tIPOESTREMALE;
    this.value = remote.vALORE;
  }

  PredictionDomainModel copyWith({
    DateTime previsionDate,
    DateTime extremeDate,
    String extremeType,
    String value,
  }) {
    return PredictionDomainModel(
      previsionDate: previsionDate ?? this.previsionDate,
      extremeDate: extremeDate ?? this.extremeDate,
      extremeType: extremeType ?? this.extremeType,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'previsionDate': previsionDate?.millisecondsSinceEpoch,
      'extremeDate': extremeDate?.millisecondsSinceEpoch,
      'extremeType': extremeType,
      'value': value,
    };
  }

  factory PredictionDomainModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return PredictionDomainModel(
      previsionDate: DateTime.fromMillisecondsSinceEpoch(map['previsionDate']),
      extremeDate: DateTime.fromMillisecondsSinceEpoch(map['extremeDate']),
      extremeType: map['extremeType'],
      value: map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PredictionDomainModel.fromJson(String source) => PredictionDomainModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PredictionDomainModel(previsionDate: $previsionDate, extremeDate: $extremeDate, extremeType: $extremeType, value: $value)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is PredictionDomainModel &&
      o.previsionDate == previsionDate &&
      o.extremeDate == extremeDate &&
      o.extremeType == extremeType &&
      o.value == value;
  }

  @override
  int get hashCode {
    return previsionDate.hashCode ^
      extremeDate.hashCode ^
      extremeType.hashCode ^
      value.hashCode;
  }
}
