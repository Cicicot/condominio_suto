
class IngresoModel {
    int? idIngreso;
    String? generoVisita;
    String? nombreVisita;
    String? aPaternoVisita;
    String idVisita;
    String? nroPiso;
    String nroDpto;
    String? tipo;
    String? marca;
    String? color;
    String idVehiculo;
    String? fechaIngresoHora;
    String? fechaSalidaHora;

    IngresoModel({
        this.idIngreso,
        this.generoVisita,
        this.nombreVisita,
        this.aPaternoVisita,
        required this.idVisita,
        this.nroPiso,
        required this.nroDpto,
        this.tipo,
        this.marca,
        this.color,
        required this.idVehiculo,
        this.fechaIngresoHora,
        this.fechaSalidaHora,
    });

    factory IngresoModel.fromMap(Map<String, dynamic> json) => IngresoModel(
        idIngreso: json["idIngreso"],
        generoVisita: json["generoVisita"],
        nombreVisita: json["nombreVisita"],
        aPaternoVisita: json["aPaternoVisita"],
        idVisita: json["idVisita"],
        nroPiso: json["nroPiso"],
        nroDpto: json["nroDpto"],
        tipo: json["tipo"],
        marca: json["marca"],
        color: json["color"],
        idVehiculo: json["idVehiculo"],
        fechaIngresoHora: json["fechaIngreso_Hora"],
        fechaSalidaHora: json["fechaSalida_Hora"],
    );

    Map<String, dynamic> toMap() => {
        "idIngreso": idIngreso,
        "generoVisita": generoVisita,
        "nombreVisita": nombreVisita,
        "aPaternoVisita": aPaternoVisita,
        "idVisita": idVisita,
        "nroPiso": nroPiso,
        "nroDpto": nroDpto,
        "tipo": tipo,
        "marca": marca,
        "color": color,
        "idVehiculo": idVehiculo,
        "fechaIngreso_Hora": fechaIngresoHora,
        "fechaSalida_Hora": fechaSalidaHora,
    };
}
