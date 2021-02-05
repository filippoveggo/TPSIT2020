class PredictionRemoteModel {
  String dATAPREVISIONE;
  String dATAESTREMALE;
  String tIPOESTREMALE;
  String vALORE;
  String tITOLO;
  String vIGNETTA;
  String dEFAULTVIGNETTA;

  PredictionRemoteModel(
      {this.dATAPREVISIONE,
      this.dATAESTREMALE,
      this.tIPOESTREMALE,
      this.vALORE,
      this.tITOLO,
      this.vIGNETTA,
      this.dEFAULTVIGNETTA});

  PredictionRemoteModel.fromJson(Map<String, dynamic> json) {
    dATAPREVISIONE = json['DATA_PREVISIONE'];
    dATAESTREMALE = json['DATA_ESTREMALE'];
    tIPOESTREMALE = json['TIPO_ESTREMALE'];
    vALORE = json['VALORE'];
    tITOLO = json['TITOLO'];
    vIGNETTA = json['VIGNETTA'];
    dEFAULTVIGNETTA = json['DEFAULT_VIGNETTA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DATA_PREVISIONE'] = this.dATAPREVISIONE;
    data['DATA_ESTREMALE'] = this.dATAESTREMALE;
    data['TIPO_ESTREMALE'] = this.tIPOESTREMALE;
    data['VALORE'] = this.vALORE;
    data['TITOLO'] = this.tITOLO;
    data['VIGNETTA'] = this.vIGNETTA;
    data['DEFAULT_VIGNETTA'] = this.dEFAULTVIGNETTA;
    return data;
  }
}
