
class ResidenteModel {
    final String idResidente;
    final String password;
    final String nombre;
    final String aPaterno;
    final String aMaterno;
    final String fechaNacimiento;
    final String telefono;
    final String email;
    final String genero;
    final String estado;
    final String fechaAlta;
    final String fechaEdit;

    ResidenteModel({
        required this.idResidente,
        required this.password,
        required this.nombre,
        required this.aPaterno,
        required this.aMaterno,
        required this.fechaNacimiento,
        required this.telefono,
        required this.email,
        required this.genero,
        required this.estado,
        required this.fechaAlta,
        required this.fechaEdit,
    });

    factory ResidenteModel.fromMap(Map<String, dynamic> json) => ResidenteModel(
        idResidente: json["idResidente"],
        password: json["password"],
        nombre: json["nombre"],
        aPaterno: json["aPaterno"],
        aMaterno: json["aMaterno"],
        fechaNacimiento: json["fechaNacimiento"],
        telefono: json["telefono"],
        email: json["email"],
        genero: json["genero"],
        estado: json["estado"],
        fechaAlta: json["fecha_alta"],
        fechaEdit: json["fecha_edit"],
    );

    Map<String, dynamic> toMap() => {
        "idResidente": idResidente,
        "password": password,
        "nombre": nombre,
        "aPaterno": aPaterno,
        "aMaterno": aMaterno,
        "fechaNacimiento": fechaNacimiento,
        "telefono": telefono,
        "email": email,
        "genero": genero,
        "estado": estado,
        "fecha_alta": fechaAlta,
        "fecha_edit": fechaEdit,
    };
}
