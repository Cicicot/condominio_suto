
class UsuarioModel {
    final String idUsuario;
    final String password;
    final String nombre;
    final String aPaterno;
    final String aMaterno;
    final String tipo;
    final String telefono;
    final String genero;
    final String estado;
    final String fechaAlta;
    final String fechaEdit;

    UsuarioModel({
        required this.idUsuario,
        required this.password,
        required this.nombre,
        required this.aPaterno,
        required this.aMaterno,
        required this.tipo,
        required this.telefono,
        required this.genero,
        required this.estado,
        required this.fechaAlta,
        required this.fechaEdit,
    });

    factory UsuarioModel.fromMap(Map<String, dynamic> json) => UsuarioModel(
        idUsuario: json["idUsuario"],
        password: json["password"],
        nombre: json["nombre"],
        aPaterno: json["aPaterno"],
        aMaterno: json["aMaterno"],
        tipo: json["tipo"],
        telefono: json["telefono"],
        genero: json["genero"],
        estado: json["estado"],
        fechaAlta: json["fecha_alta"],
        fechaEdit: json["fecha_edit"],
    );

    Map<String, dynamic> toMap() => {
        "idUsuario": idUsuario,
        "password": password,
        "nombre": nombre,
        "aPaterno": aPaterno,
        "aMaterno": aMaterno,
        "tipo": tipo,
        "telefono": telefono,
        "genero": genero,
        "estado": estado,
        "fecha_alta": fechaAlta,
        "fecha_edit": fechaEdit,
    };
}
