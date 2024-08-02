

class VehiculoModel {
    final String idVehiculo;
    final String tipo;
    final String marca;
    final String color;
    final String estado;
    final String fechaAlta;
    final String fechaEdit;

    VehiculoModel({
        required this.idVehiculo,
        required this.tipo,
        required this.marca,
        required this.color,
        required this.estado,
        required this.fechaAlta,
        required this.fechaEdit,
    });

    factory VehiculoModel.fromMap(Map<String, dynamic> json) => VehiculoModel(
        idVehiculo: json["idVehiculo"],
        tipo: json["tipo"],
        marca: json["marca"],
        color: json["color"],
        estado: json["estado"],
        fechaAlta: json["fecha_alta"],
        fechaEdit: json["fecha_edit"],
    );

    Map<String, dynamic> toMap() => {
        "idVehiculo": idVehiculo,
        "tipo": tipo,
        "marca": marca,
        "color": color,
        "estado": estado,
        "fecha_alta": fechaAlta,
        "fecha_edit": fechaEdit,
    };
}
