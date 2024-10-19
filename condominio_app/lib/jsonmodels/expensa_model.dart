

class ExpensaModel {
    int? idExpensa;
    String descripcion;
    int monto;
    String isPagado;
    String fechaPago;

    ExpensaModel({
        this.idExpensa,
        required this.descripcion,
        required this.monto,
        required this.isPagado,
        required this.fechaPago,
    });

    factory ExpensaModel.fromMap(Map<String, dynamic> json) => ExpensaModel(
        idExpensa: json["idExpensa"],
        descripcion: json["descripcion"],
        monto: json["monto"],
        isPagado: json["isPagado"],
        fechaPago: json["fechaPago"],
    );

    Map<String, dynamic> toMap() => {
        "idExpensa": idExpensa,
        "descripcion": descripcion,
        "monto": monto,
        "isPagado": isPagado,
        "fechaPago": fechaPago,
    };
}
