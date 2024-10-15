import 'package:condominio_app/jsonmodels/models.dart';
import 'package:condominio_app/screens/screens.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReservaScreen extends StatefulWidget {
  const ReservaScreen({super.key});

  @override
  State<ReservaScreen> createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {

  late DatabaseHelper handler;
  late Future<List<ReservaModel>> reservas;

  // Declara una variable a nivel de clase para almacenar las reservas.
  late List<ReservaModel> rvas = []; //Eliminar en caso de error

  final db = DatabaseHelper();

  final idResidente       = TextEditingController();
  final nombreResidente   = TextEditingController();
  final aPaternoResidente = TextEditingController();
  final aMaternoResidente = TextEditingController();
  final idAreaComun       = TextEditingController();
  final nombreAreaComun   = TextEditingController();
  final alquilerAreaComun   = TextEditingController();
  String? isAceptado;
  final fechaHoraInicio   = TextEditingController();
  final fechaHoraFinal    = TextEditingController();

  final keyword = TextEditingController();

  final fontSize25 = const TextStyle(fontSize: 25);
  final fontSize20 = const TextStyle(fontSize: 20);

  @override
  void initState() {
    handler = DatabaseHelper();
    reservas = handler.getReservas();
    handler.initDB().whenComplete(() {
      
    });
    super.initState();
  }

   //Recién agregado, puede quitarse
  @override
  void dispose() {  
    idResidente.dispose();
    nombreResidente.dispose();
    aPaternoResidente.dispose();
    aMaternoResidente.dispose();
    idAreaComun.dispose();
    nombreAreaComun.dispose();
    alquilerAreaComun.dispose();
    fechaHoraInicio.dispose();
    fechaHoraFinal.dispose();
    super.dispose();
  }

  Future <List<ReservaModel>> getAllReservas() async {
    return handler.getReservas();
  }

  Future<void> _refresh() async {
    setState(() {
      reservas = getAllReservas();
    });
  }

 
  Future<void> generatePdf(List<ReservaModel> reservaPdf) async {
    final pdf = pw.Document();

    // Agregar una página con un título y una tabla
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Reporte de Reservas', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['Residente', 'Apellido Paterno','Área Común', 'Inicia reserva', 'Fin reserva'],
                data: reservaPdf.map((at) => [at.nombreResidente, at.aPaternoResidente, at.nombreAreaComun, at.fechaHoraInicio, at.fechaHoraFinal]).toList(),
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );

    // Guardar el PDF en el dispositivo o mostrarlo con el paquete `printing`
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 210, 214, 245),
      appBar: AppBar(
        title: const Text( 'RESERVAS', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white) ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ReservaModel>>(
        future: reservas, 
        builder: (context, AsyncSnapshot<List<ReservaModel>> snapshot) {
          if ( snapshot.connectionState == ConnectionState.waiting ) {
            return const CircularProgressIndicator();
          } else if ( snapshot.hasData && snapshot.data!.isEmpty ) {
            return const Center( child: Text( 'No hay reservas', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)) );
          } else if ( snapshot.hasError ) {
            return Text( snapshot.error.toString() );
          } else {
            rvas = snapshot.data ?? <ReservaModel>[]; //Modificación de la variable
            
            return ListView.separated(
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text( rvas[i].idReserva.toString(), style: fontSize25 ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( rvas[i].idResidente.toString() ),
                      Text( rvas[i].nombreResidente! ),
                      Text( rvas[i].aPaternoResidente! ),
                      Text( rvas[i].aMaternoResidente! ),
                      Text( rvas[i].idAreaComun.toString() ),
                      Text( rvas[i].nombreAreaComun! ),
                      Text( rvas[i].alquilerAreaComun.toString() ),
                      Text( rvas[i].fechaHoraInicio ),
                      Text( rvas[i].fechaHoraFinal ),
                      Text( rvas[i].isAceptado! )
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon( Icons.delete, color: Colors.red, size: 30 ),
                    onPressed: () {
                      //We call delete method from DatabaseHelper()
                      db.deleteReserva(rvas[i].idReserva!).whenComplete(() {
                        //After to delete registers, _refresh() db
                        _refresh();
                      });
                    }
                  ),
                  onTap: () {
                    //When we click on a register
                    setState(() {
                      idResidente.text = rvas[i].idResidente.toString();
                      idAreaComun.text = rvas[i].idAreaComun.toString();
                      fechaHoraInicio.text = rvas[i].fechaHoraInicio;
                      fechaHoraFinal.text = rvas[i].fechaHoraFinal;
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
                                      //Now we call update method
                                      db.updateReserva(
                                        fechaHoraInicio.text, 
                                        fechaHoraFinal.text, 
                                        rvas[i].idReserva).whenComplete(() {
                                          //after update(), _refresh() bd
                                          _refresh();
                                        });
                                    }, 
                                    child: const Text( 'Update', style: TextStyle(color: Colors.white) ),
                                  ),
                                ),
                                const SizedBox(height: 20),
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
                                    child: const Text('Cancel', style: TextStyle(color: Colors.white))
                                  ),
                                )
                              ],
                            )
                          ],
                          title: const Text( 'Update Reserva' ),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //Agregamos los campos, TextFormField() idAreaComun
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: idAreaComun,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Id de área común es requerido";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    label: Text( 'Id de área Común' )
                                  ),
                                ),
                                //Agregamos los campos, TextFormField() idResidente
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: idResidente,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Id de Residente es requerido";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    label: Text( 'Id de Residente' )
                                  ),
                                ),
                                //Agregamos los campos, TextFormField() FechaInicio
                                TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  controller: fechaHoraInicio,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Fecha de inicio es requerido";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    label: Text( 'Fecha de Inicio de reserva' )
                                  ),
                                ),
                                //Agregamos los campos, TextFormField() FechaFin
                                TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  controller: fechaHoraFinal,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Fecha de finalización es requerido";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    label: Text( 'Fecha final de reserva' )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  },
                );
              }, 
              separatorBuilder: ( _, __ ) => const Divider(thickness: 3, color: Color.fromARGB(255, 58, 55, 55)), 
              itemCount: rvas.length
            );
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            icon: const Icon( Icons.list_alt_outlined, color: Colors.white ),
            onPressed: () {
              generatePdf(rvas); 
            }, 
            label: const Text('Reporte', style: TextStyle( color: Colors.white ))
          ),
          const Expanded(child: SizedBox()),
          FloatingActionButton(
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(
              //   builder: (context) => const ReservaCreate())).then((value) {
              //     if ( value == true ) {
              //       _refresh();
              //     }
              //   });
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const ReservaCreate())
              ).then((value) {
                if (value == true) { // Asegúrate de que value sea true
                  _refresh();
                }
              }).catchError((error) {
                // Maneja cualquier error inesperado que ocurra
                print('Error: $error');
              });
            },
            child: const Icon( Icons.add, color: Colors.white ),
          ),
        ],
      ),
    );
  }
}