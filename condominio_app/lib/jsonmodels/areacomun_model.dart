

class AreaComunModel {
    final int? idAreaComun;
    final String nombre;
    final double costoAlquiler;
    final String estado;
    final String fechaAlta;
    final String fechaEdit;

    AreaComunModel({
        this.idAreaComun,
        required this.nombre,
        required this.costoAlquiler,
        required this.estado,
        required this.fechaAlta,
        required this.fechaEdit,
    });

    factory AreaComunModel.fromMap(Map<String, dynamic> json) => AreaComunModel(
        idAreaComun: json["idAreaComun"],
        nombre: json["nombre"],
        costoAlquiler: json["costoAlquiler"]?.toDouble(),
        estado: json["estado"],
        fechaAlta: json["fecha_alta"],
        fechaEdit: json["fecha_edit"],
    );

    Map<String, dynamic> toMap() => {
        "idAreaComun": idAreaComun,
        "nombre": nombre,
        "costoAlquiler": costoAlquiler,
        "estado": estado,
        "fecha_alta": fechaAlta,
        "fecha_edit": fechaEdit,
    };
}
