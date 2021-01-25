import 'dart:convert';

import 'package:app_maree/feature/levels/data/models/level_remote_model.dart';

class LevelDomainModel{
  int order;
  String idStation;
  String station;
  String nomeAbbr;
  double lat;
  double lon;
  DateTime data;
  String value;

  LevelDomainModel.fromRemoteModel(LevelRemoteModel remote) {
    this.order = int.parse(remote.ordine);
    this.idStation = remote.iDStazione;
    this.station = remote.stazione;
    this.nomeAbbr = remote.nomeAbbr;
    this.lat = double.parse(remote.latDDN);
    this.lon = double.parse(remote.lonDDE);
    this.data = DateTime.parse(remote.data);
    this.value = remote.valore;
  }

  LevelDomainModel({
    this.order,
    this.idStation,
    this.station,
    this.nomeAbbr,
    this.lat,
    this.lon,
    this.data,
    this.value,
  });

  LevelDomainModel copyWith({
    int order,
    String idStation,
    String station,
    String nomeAbbr,
    double lat,
    double lon,
    DateTime data,
    String value,
  }) {
    return LevelDomainModel(
      order: order ?? this.order,
      idStation: idStation ?? this.idStation,
      station: station ?? this.station,
      nomeAbbr: nomeAbbr ?? this.nomeAbbr,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      data: data ?? this.data,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order': order,
      'idStation': idStation,
      'station': station,
      'nomeAbbr': nomeAbbr,
      'lat': lat,
      'lon': lon,
      'data': data?.millisecondsSinceEpoch,
      'value': value,
    };
  }

  factory LevelDomainModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LevelDomainModel(
      order: map['order'],
      idStation: map['idStation'],
      station: map['station'],
      nomeAbbr: map['nomeAbbr'],
      lat: map['lat'],
      lon: map['lon'],
      data: DateTime.fromMillisecondsSinceEpoch(map['data']),
      value: map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LevelDomainModel.fromJson(String source) =>
      LevelDomainModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LevelDomainModel(order: $order, idStation: $idStation, station: $station, nomeAbbr: $nomeAbbr, lat: $lat, lon: $lon, data: $data, value: $value)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is LevelDomainModel &&
        o.order == order &&
        o.idStation == idStation &&
        o.station == station &&
        o.nomeAbbr == nomeAbbr &&
        o.lat == lat &&
        o.lon == lon &&
        o.data == data &&
        o.value == value;
  }

  @override
  int get hashCode {
    return order.hashCode ^
        idStation.hashCode ^
        station.hashCode ^
        nomeAbbr.hashCode ^
        lat.hashCode ^
        lon.hashCode ^
        data.hashCode ^
        value.hashCode;
  }
}
