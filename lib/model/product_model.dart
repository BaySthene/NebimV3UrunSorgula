class productModel {
  int? id;
  int? order;
  String? title;
  String? type;
  String? colWidth;
  List<Data>? data;

  productModel(
      {this.id, this.order, this.title, this.type, this.colWidth, this.data});

  productModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    order = json['Order'];
    title = json['Title'];
    type = json['Type'];
    colWidth = json['ColWidth'];
    if (json['Data'] != null) {
      data = <Data>[];
      json['Data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Order'] = this.order;
    data['Title'] = this.title;
    data['Type'] = this.type;
    data['ColWidth'] = this.colWidth;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? renk;
  String? beden;
  String? aAdere;
  String? alemdar;
  String? gebze;
  String? zmit;
  String? nCity;
  String? sarnHan;

  Data(
      {this.renk,
        this.beden,
        this.aAdere,
        this.alemdar,
        this.gebze,
        this.zmit,
        this.nCity,
        this.sarnHan});

  Data.fromJson(Map<String, dynamic> json) {
    renk = json['Renk'];
    beden = json['Beden'];
    aAdere = json['Ağadere'];
    alemdar = json['Alemdar'];
    gebze = json['Gebze'];
    zmit = json['İzmit'];
    nCity = json['NCity'];
    sarnHan = json['Sarnıçhan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Renk'] = this.renk;
    data['Beden'] = this.beden;
    data['Ağadere'] = this.aAdere;
    data['Alemdar'] = this.alemdar;
    data['Gebze'] = this.gebze;
    data['İzmit'] = this.zmit;
    data['NCity'] = this.nCity;
    data['Sarnıçhan'] = this.sarnHan;
    return data;
  }
}
