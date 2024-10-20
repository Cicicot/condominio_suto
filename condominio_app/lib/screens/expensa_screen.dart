import 'package:condominio_app/jsonmodels/models.dart';
import 'package:condominio_app/screens/screens.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

class ExpensaScreen extends StatefulWidget {
  const ExpensaScreen({super.key});

  @override
  State<ExpensaScreen> createState() => _ExpensaScreenState();
}

class _ExpensaScreenState extends State<ExpensaScreen> {

  late DatabaseHelper handler;
  late Future<List<ExpensaModel>> expensas;

  final db = DatabaseHelper();

  final idResidente = TextEditingController();
  final descripcion = TextEditingController();
  final monto = TextEditingController();
  String? isPagado;
  final fechaPago = TextEditingController();

  final keyword = TextEditingController();

  final fontSize25 = const TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold);
  final fontSize20 = const TextStyle(fontSize: 20);

  @override
  void initState() {
    handler = DatabaseHelper();
    expensas = handler.getExpensas();
    handler.initDB().whenComplete(() {
      //Before de next code line, create getAllExpensas() method
      expensas = getAllExpensas();
    });
    super.initState();
  }

  // @override
  // void dispose() {
  //   idResidente.dispose();
  //   descripcion.dispose();
  //   monto.dispose();
  //   isPagado.dispose();
  //   fechaPago.dispose();
  // }

  Future<List<ExpensaModel>> getAllExpensas() async {
    return handler.getExpensas();
  }

  //_refresh() method
  Future<void> _refresh() async {
    setState(() {
      expensas = getAllExpensas();
    });
  }

  Future<void> generatePdf(List<ExpensaModel> expensaPdf) async {
    final pdf = pw.Document();

    // Agregar una página con un título y una tabla
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Reporte de Expensas', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['idResidente', 'Descripcion','Monto', 'Pagado', 'Fecha de pago'],
                data: expensaPdf.map((at) => [at.idResidente, at.descripcion, at.monto, at.isPagado, at.fechaPago]).toList(),
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( 'EXPENSAS' ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: expensas, 
        builder: ( context, AsyncSnapshot<List<ExpensaModel>> snapshot ) {
          if ( snapshot.connectionState == ConnectionState.waiting ) {
            return const Center( child: CircularProgressIndicator() );
          } else if ( snapshot.hasError ) {
            return Text( snapshot.error.toString() );
          } else {
            final exps = snapshot.data ?? <ExpensaModel>[];
            return ListView.separated(
              itemBuilder: ( context, i ) {
                return ListTile(
                  title: Text( exps[i].idExpensa.toString(), style: fontSize25 ),
                  subtitle: Column(
                    children: [
                      Text( exps[i].idResidente.toString(), style: fontSize25 ),
                      Text( exps[i].descripcion, style: fontSize20 ),
                      Text( exps[i].monto.toString(), style: fontSize20 ),
                      Text( exps[i].isPagado, style: fontSize20 ),
                      Text( exps[i].fechaPago, style: fontSize20 ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon( Icons.delete, color: Colors.red, size: 30 ),
                    onPressed: () {
                      db.deleteExpensa(exps[i].idExpensa!).whenComplete(() {
                        //Después de eliminar, refrescamos la bd
                        _refresh();
                      });
                    }, 
                  ),
                  onTap: () {
                    setState(() {
                      idResidente.text = exps[i].idResidente.toString();
                      descripcion.text = exps[i].descripcion;
                      monto.text = exps[i].monto.toString();
                      isPagado = exps[i].isPagado;
                    });
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blueAccent
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      //We update the necessary registration fields
                                      db.updateExpensa(
                                        isPagado!, 
                                        exps[i].idExpensa).whenComplete(() {
                                          _refresh();
                                          Navigator.pop(context);
                                        });
                                    }, 
                                    child: const Text( 'Registrar pago', style: TextStyle(color: Colors.white) )
                                  ),
                                ),
                                const SizedBox( width: 10 ),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }, 
                                    child: const Text( 'Cancelar', style: TextStyle(color: Colors.white) )
                                  ),
                                )
                              ],
                            )
                          ],
                          title: const Text( 'Registrar pago de Expensa' ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //We add two TextFormFields
                              // DropDownButtonItem() isPagado
                              DropdownButtonFormField<String>(
                                value: isPagado,
                                items: const [
                                  DropdownMenuItem(
                                    value: "Pago realizado",
                                    child: Text( 'Pago realizado' )
                                  ),
                                  DropdownMenuItem(
                                    value: "Pago no realizado",
                                    child: Text( 'Pago no realizado' )
                                  )
                                ], 
                                onChanged: (value) {
                                  setState(() {
                                    isPagado = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return "Pago realizado, campo obligatorio";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  label: Text('¿Pago realizado?')
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              }, 
              separatorBuilder: ( _, __ ) => const Divider( thickness: 3, color: Color.fromARGB(255, 80, 74, 58) ), 
              itemCount: exps.length
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //We need to call refresh method after a new expensa is created
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const ExpensaCreate())).then((value) {
              if ( value ) {
                //_refresh() al Scaffold
                _refresh();
              }
            });
        }, 
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Agregar Expensa', style: TextStyle(color: Colors.white))
      ),

    );
  }
}