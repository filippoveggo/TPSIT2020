class LevelRemoteModel {
  String ordine;
  String iDStazione;
  String stazione;
  String nomeAbbr;
  String latDMSN;
  String lonDMSE;
  String latDDN;
  String lonDDE;
  String data;
  String valore;

  LevelRemoteModel(
      {this.ordine,
      this.iDStazione,
      this.stazione,
      this.nomeAbbr,
      this.latDMSN,
      this.lonDMSE,
      this.latDDN,
      this.lonDDE,
      this.data,
      this.valore});

  LevelRemoteModel.fromJson(Map<String, dynamic> json) {
    ordine = json['ordine'];
    iDStazione = json['ID_stazione'];
    stazione = json['stazione'];
    nomeAbbr = json['nome_abbr'];
    latDMSN = json['latDMSN'];
    lonDMSE = json['lonDMSE'];
    latDDN = json['latDDN'];
    lonDDE = json['lonDDE'];
    data = json['data'];
    valore = json['valore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ordine'] = this.ordine;
    data['ID_stazione'] = this.iDStazione;
    data['stazione'] = this.stazione;
    data['nome_abbr'] = this.nomeAbbr;
    data['latDMSN'] = this.latDMSN;
    data['lonDMSE'] = this.lonDMSE;
    data['latDDN'] = this.latDDN;
    data['lonDDE'] = this.lonDDE;
    data['data'] = this.data;
    data['valore'] = this.valore;
    return data;
  }

  @override
  String toString() {
    String toString = '{' +
        'ordine=' +
        this.ordine +
        ',' +
        'idStazione=' +
        this.iDStazione +
        ',' +
        'latDDN=' +
        this.latDDN +
        ',' +
        'nomeAbbr=' +
        this.nomeAbbr +
        ',' +
        'latDMSN=' +
        this.latDMSN +
        ',' +
        'lonDMSE=' +
        this.lonDMSE +
        ',' +
        'latDDN=' +
        this.latDDN +
        ',' +
        'lonDDE=' +
        this.lonDDE +
        ',' +
        'data=' +
        this.data +
        ',' +
        'valore=' +
        this.valore +
        '}';
    return toString;
  }
}
