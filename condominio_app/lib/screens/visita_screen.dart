import 'package:condominio_app/jsonmodels/models.dart';
import 'package:condominio_app/screens/screens.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';

class VisitaScreen extends StatefulWidget {
  const VisitaScreen({super.key});

  @override
  State<VisitaScreen> createState() => _VisitaScreenState();
}

class _VisitaScreenState extends State<VisitaScreen> {

  late DatabaseHelper handler;
  late Future<List<VisitaModel>> visitas;

  final db = DatabaseHelper();

  final idVisita = TextEditingController();
  final nombre = TextEditingController();
  final aPaterno = TextEditingController();
  final aMaterno = TextEditingController();
  String? genero;

  final keyword = TextEditingController();
  
  final fontSize25 = const TextStyle(fontSize: 25);
  final fontSize20 = const TextStyle(fontSize: 20);

  @override
  void initState() {
    handler = DatabaseHelper();
    visitas = handler.getVisitasActivas();
    handler.initDB().whenComplete(() {
      //Before next code line, create getAllVisitas() method
      visitas = getAllVisitas();
    });
    super.initState();
  }

  Future<List<VisitaModel>> getAllVisitas() async {
    return handler.getVisitasActivas();
  }

  //_refresh() method
  Future<void> _refresh() async {
    setState(() {
      visitas = getAllVisitas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( 'VISITAS', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white) ),
        centerTitle: true,
      ),
      //First, we are going to show visitas
      body: FutureBuilder(
        future: visitas, 
        builder: (context, AsyncSnapshot<List<VisitaModel>> snapshot) {
          if ( snapshot.connectionState == ConnectionState.waiting ) {
            return const Center( child: CircularProgressIndicator() );
          } else if ( snapshot.hasError ) {
            return Text( snapshot.error.toString() );
          } else {
            final visits = snapshot.data ?? <VisitaModel>[];
            return ListView.separated(
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text( visits[i].idVisita, style: fontSize25 ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( visits[i].nombre, style: fontSize20 ),
                      Text( visits[i].aPaterno, style: fontSize20 ),
                      Text( visits[i].aMaterno, style: fontSize20 ),
                      Text( visits[i].genero, style: fontSize20 ),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      //we call delete method from DatabaseHelper()
                      db.deleteLogicoVisita(visits[i].idVisita).whenComplete(() {
                        //After to delete a register, _refresh() bd
                        _refresh();
                      });
                    }, 
                    icon: const Icon( Icons.delete, color: Colors.red, size: 30 ),
                  ),
                  onTap: () {
                    //When click on a register
                    setState(() {
                      idVisita.text = visits[i].idVisita;
                      nombre.text = visits[i].nombre;
                      aPaterno.text = visits[i].aPaterno;
                      aMaterno.text = visits[i].aMaterno;
                      genero = visits[i].genero;
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
                                      db.updateVisita(
                                        nombre.text, 
                                        aPaterno.text, 
                                        aMaterno.text, 
                                        genero,
                                        visits[i].idVisita).whenComplete(() {
                                          _refresh();
                                          Navigator.pop(context);  
                                        });
                                    }, 
                                    child: const Text('Update', style: TextStyle(color: Colors.white))
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
                          title: const Text( 'Update Visita' ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // TextFormField() nombre
                              TextFormField(
                                controller: nombre,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Nombre, campo obligatorio";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  label: Text('Nombre')
                                ),
                              ),
                              // TextFormField() aPaterno
                              TextFormField(
                                controller: aPaterno,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Apellido paterno, campo obligatorio";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  label: Text('Apellido paterno')
                                ),
                              ),
                              // TextFormField() aMaterno
                              TextFormField(
                                controller: aMaterno,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Apellido materno, campo obligatorio";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  label: Text('Apellido materno')
                                ),
                              ),
                              // DropDownButtonItem() género
                              DropdownButtonFormField<String>(
                                value: genero,
                                items: const [
                                  DropdownMenuItem(
                                    value: "MASCULINO",
                                    child: Text( 'Masculino' )
                                  ),
                                  DropdownMenuItem(
                                    value: "FEMENINO",
                                    child: Text( 'Femenino' )
                                  ),
                                ], 
                                onChanged: (value) {
                                  setState(() {
                                    genero = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return "Género, campo obligatorio";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  label: Text('Género')
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
              itemCount: visits.length
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const VisitaCreate())).then((value) {
              if (value) {
                _refresh();
              }
            });
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Agregar Visita', style: TextStyle(color: Colors.white)),
      ),
    );
  }

}