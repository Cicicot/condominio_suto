

class ExpensaModel {
    int? idExpensa;
    String descripcion;
    int monto;
    String isPagado;
    String fechaPago;
    int idResidente;

    ExpensaModel({
        this.idExpensa,
        required this.descripcion,
        required this.monto,
        required this.isPagado,
        required this.fechaPago,
        required this.idResidente
    });

    factory ExpensaModel.fromMap(Map<String, dynamic> json) => ExpensaModel(
        idExpensa: json["idExpensa"],
        descripcion: json["descripcion"],
        monto: json["monto"],
        isPagado: json["isPagado"],
        fechaPago: json["fechaPago"], 
        idResidente: json["idResidente"]
    );

    Map<String, dynamic> toMap() => {
        "idExpensa": idExpensa,
        "descripcion": descripcion,
        "monto": monto,
        "isPagado": isPagado,
        "fechaPago": fechaPago,
        "idResidente": idResidente
    };
}
