

class VisitaModel {
    final String idVisita;
    final String nombre;
    final String aPaterno;
    final String aMaterno;
    final String genero;
    final String estado;
    final String fechaAlta;
    final String fechaEdit;

    VisitaModel({
        required this.idVisita,
        required this.nombre,
        required this.aPaterno,
        required this.aMaterno,
        required this.genero,
        required this.estado,
        required this.fechaAlta,
        required this.fechaEdit,
    });

    factory VisitaModel.fromMap(Map<String, dynamic> json) => VisitaModel(
        idVisita: json["idVisita"],
        nombre: json["nombre"],
        aPaterno: json["aPaterno"],
        aMaterno: json["aMaterno"],
        genero: json["genero"],
        estado: json["estado"],
        fechaAlta: json["fecha_alta"],
        fechaEdit: json["fecha_edit"],
    );

    Map<String, dynamic> toMap() => {
        "idVisita": idVisita,
        "nombre": nombre,
        "aPaterno": aPaterno,
        "aMaterno": aMaterno,
        "genero": genero,
        "estado": estado,
        "fecha_alta": fechaAlta,
        "fecha_edit": fechaEdit,
    };
}
