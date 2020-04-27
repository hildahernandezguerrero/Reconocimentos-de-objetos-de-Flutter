class Info {
  List<Plants> plants;

  Info({this.plants});

  Info.fromJson(Map<String, dynamic> json) {
    if (json['plants'] != null) {
      plants = new List<Plants>();
      json['plants'].forEach((v) {
        plants.add(new Plants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.plants != null) {
      data['plants'] = this.plants.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plants {
  String clase;
  List<String> beneficios;
  List<String> ingredientes;
  String preparacion;

  Plants({this.clase, this.beneficios, this.ingredientes, this.preparacion});

  Plants.fromJson(Map<String, dynamic> json) {
    clase = json['clase'];
    beneficios = json['Beneficios'].cast<String>();
    ingredientes = json['Ingredientes'].cast<String>();
    preparacion = json['Preparacion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clase'] = this.clase;
    data['Beneficios'] = this.beneficios;
    data['Ingredientes'] = this.ingredientes;
    data['Preparacion'] = this.preparacion;
    return data;
  }
}