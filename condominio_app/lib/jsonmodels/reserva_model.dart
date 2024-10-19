

class ReservaModel {
    int? idReserva; 
    int idResidente; 
    String? nombreResidente;
    String? aPaternoResidente;
    String? aMaternoResidente;
    int idAreaComun; 
    String? nombreAreaComun;
    int? alquilerAreaComun; 
    String? isAceptado;
    String fechaHoraInicio; 
    String fechaHoraFinal; 

    ReservaModel({
        this.idReserva,
        required this.idResidente,
        this.nombreResidente,
        this.aPaternoResidente,
        this.aMaternoResidente,
        required this.idAreaComun,
        this.nombreAreaComun,
        this.alquilerAreaComun,
        this.isAceptado,
        required this.fechaHoraInicio,
        required this.fechaHoraFinal,
    });

    factory ReservaModel.fromMap(Map<String, dynamic> json) => ReservaModel(
        idReserva: json["idReserva"],
        idResidente: json["idResidente"],
        nombreResidente: json["nombreResidente"],
        aPaternoResidente: json["aPaternoResidente"],
        aMaternoResidente: json["aMaternoResidente"],
        idAreaComun: json["idAreaComun"],
        nombreAreaComun: json["nombreAreaComun"],
        alquilerAreaComun: json["precioAreaComun"],
        isAceptado: json["isAceptado"],
        fechaHoraInicio: json["fechaHora_inicio"],
        fechaHoraFinal: json["fechaHora_final"],
    );

    Map<String, dynamic> toMap() => {
        "idReserva": idReserva,
        "idResidente": idResidente,
        "nombreResidente": nombreResidente,
        "aPaternoResidente": aPaternoResidente,
        "aMaternoResidente": aMaternoResidente,
        "idAreaComun": idAreaComun,
        "nombreAreaComun": nombreAreaComun,
        "precioAreaComun": alquilerAreaComun,
        "isAceptado": isAceptado,
        "fechaHora_inicio": fechaHoraInicio,
        "fechaHora_final": fechaHoraFinal,
    };
}
