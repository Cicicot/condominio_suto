

class PropiedadModel {
    final int? idPropiedad;
    final String estado;
    final String nroPiso;
    final String nroDpto;
    final String fechaAlta;
    final String fechaEdit;

    PropiedadModel({
        this.idPropiedad,
        required this.estado,
        required this.nroPiso,
        required this.nroDpto,
        required this.fechaAlta,
        required this.fechaEdit,
    });

    factory PropiedadModel.fromMap(Map<String, dynamic> json) => PropiedadModel(
        idPropiedad: json["idPropiedad"],
        estado: json["estado"],
        nroPiso: json["nroPiso"],
        nroDpto: json["nroDpto"],
        fechaAlta: json["fecha_alta"],
        fechaEdit: json["fecha_edit"],
    );

    Map<String, dynamic> toMap() => {
        "idPropiedad": idPropiedad,
        "estado": estado,
        "nroPiso": nroPiso,
        "nroDpto": nroDpto,
        "fecha_alta": fechaAlta,
        "fecha_edit": fechaEdit,
    };
}
