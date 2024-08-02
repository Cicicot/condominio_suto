import 'package:condominio_app/jsonmodels/models.dart';
import 'package:condominio_app/screens/screens.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';

class PropiedadScreen extends StatefulWidget {
  const PropiedadScreen({super.key});

  @override
  State<PropiedadScreen> createState() => _PropiedadScreenState();
}

class _PropiedadScreenState extends State<PropiedadScreen> {

  late DatabaseHelper handler;
  late Future<List<PropiedadModel>> propiedades;

  final db = DatabaseHelper();

  final piso = TextEditingController();
  final dpto = TextEditingController();

  final keyword = TextEditingController();

  @override
  void initState() {
    handler = DatabaseHelper();
    propiedades = handler.getPropiedadesActivas(); //En lugar de getPropiedades(), voy a usar getPropiedadesActivas()

    handler.initDB().whenComplete(() {
      //Antes de la siguiente línea de código, crear getAllPropiedades()
      propiedades = getAllPropiedades();
    });

    super.initState();
  }

  Future<List<PropiedadModel>> getAllPropiedades() async { //Le agregué el async
    return handler.getPropiedadesActivas();
  }

  //_refresh() method
  Future<void> _refresh() async {
    setState(() {
      propiedades = getAllPropiedades();
    });
  }

  @override
  Widget build(BuildContext context) {

    const fontSize25boldWhite = TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white);
    const fontSize20title = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    const fontSize20 = TextStyle(fontSize: 20);

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.indigo[400],
        centerTitle: true,
        title: const Text( 'PROPIEDADES', style: fontSize25boldWhite )
      ),
      //Primero, mostremos la propiedades
      body: FutureBuilder<List<PropiedadModel>>(
        future: propiedades, 
        builder: (BuildContext context, AsyncSnapshot<List<PropiedadModel>> snapshot) {
          if ( snapshot.connectionState == ConnectionState.waiting ) {
            return const CircularProgressIndicator();
          } else if ( snapshot.hasData && snapshot.data!.isEmpty ) {
            return const Center( child: Text( 'No hay registros', style: fontSize25boldWhite ) );
          } else if ( snapshot.hasError ) {
            return Text( snapshot.error.toString() );
          } else {
            final items = snapshot.data ?? <PropiedadModel>[];
            return ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text( items[index].nroPiso, style: fontSize20title ),
                  subtitle: Text( items[index].nroDpto, style: fontSize20 ),
                  trailing: IconButton(
                    icon: const Icon( Icons.delete, color: Colors.red, size: 30 ),
                    onPressed: () {
                      //Llamamos al method deletePropiedad() de DatabaseHelper
                      db.deleteLogicoPropiedad(items[index].idPropiedad!).whenComplete(() {
                       //Después de eliminar exitosamente, hacemos un _refresh() a la bd
                       _refresh(); 
                      });
                    }, 
                  ),
                  onTap: () {
                    //Cuando haga click sobre un registro
                    setState(() {
                      piso.text = items[index].nroPiso;
                      dpto.text = items[index].nroDpto;
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
                                      //Ahora llamamos al método updatePropiedad()
                                      db.updatePropiedad(
                                        piso.text, 
                                        dpto.text, 
                                        items[index].idPropiedad).whenComplete(() {
                                          //Después de actualizar, _refresh a la bd
                                          _refresh();
                                          Navigator.pop(context);
                                        });
                                    }, 
                                    child: const Text( 'Update', style: TextStyle( color: Colors.white ) )
                                  ),
                                ),
                                const SizedBox(width: 10),
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
                                    child: const Text( 'Cancel', style: TextStyle(color: Colors.white) )
                                  ),
                                )
                              ],
                            )
                          ],
                          title: const Text( 'Update Propiedad' ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //Agregamos dos TextFormFields
                              //TextFormField() piso
                              TextFormField(
                                controller: piso,
                                validator: (value) {
                                  if ( value!.isEmpty ) {
                                    return "Nro Piso es requerido";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  label: Text( 'Nro Piso', style: TextStyle(fontSize: 25) )
                                ),
                              ),
                              //TextFormField() dpto
                              TextFormField(
                                controller: dpto,
                                validator: (value) {
                                  if ( value!.isEmpty ) {
                                    return "Nro Departamento es requerido";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  label: Text( 'Nro Departamento', style: TextStyle(fontSize: 25) )
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
              separatorBuilder: (_,__) => const Divider(), 
              itemCount: items.length
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        onPressed: () {
          //We need to call refresh method after a new propiedad is created
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const PropiedadCreate())).then((value) {
              if (value) {
                //_refresh() al scaffold
                _refresh();
              }
            });
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Agregar Propiedad', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}