
import 'package:condominio_app/jsonmodels/models.dart';
import 'package:condominio_app/screens/screens.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';

class AreaComunScreen extends StatefulWidget {
  const AreaComunScreen({super.key});

  @override
  State<AreaComunScreen> createState() => _AreaComunScreenState();
}

class _AreaComunScreenState extends State<AreaComunScreen> {

  late DatabaseHelper handler;
  late Future<List<AreaComunModel>> areascomunes;

  final db = DatabaseHelper();

  final idAreaC = TextEditingController();
  final nombre = TextEditingController();
  final costoAlquiler = TextEditingController();

  final keyword = TextEditingController();

  @override
  void initState() {
    handler = DatabaseHelper();
    areascomunes = handler.getAreasComunesActivas();

    handler.initDB().whenComplete(() {
      //Antes de la siguiente línea, crear getAllAreasComunes()
      areascomunes = getAllAreasComunes();
    });
    super.initState();
  }

  Future<List<AreaComunModel>> getAllAreasComunes() {
    return handler.getAreasComunesActivas();
  }

  //Método _refresh()
  Future<void> _refresh() async {
    setState(() {
      areascomunes = getAllAreasComunes();
    });
  }

  @override
  Widget build(BuildContext context) {

    const fontSize25boldWhite = TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white);
    const fontSize20title = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    const fontSize20 = TextStyle(fontSize: 20);

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Text( 'ÁREAS COMUNES', style: fontSize25boldWhite ),
      ),
      body: FutureBuilder<List<AreaComunModel>>(
        future: areascomunes, 
        builder: (BuildContext context, AsyncSnapshot<List<AreaComunModel>> snapshot) {
          if ( snapshot.connectionState == ConnectionState.waiting ) {
            return const Center( child: Text('No hay áreas comunes registradas', style: fontSize25boldWhite ) );
          } else if ( snapshot.hasError ) {
            return Text( snapshot.error.toString() );
          } else {
            final acomunes = snapshot.data ?? <AreaComunModel>[];
            return ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text( acomunes[index].idAreaComun.toString() ),
                  subtitle: Column(
                    children: [
                      Text( acomunes[index].nombre, style: fontSize20title ),
                      Text( acomunes[index].costoAlquiler.toString(), style: fontSize20 ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon( Icons.delete, color: Colors.red, size: 30 ),
                    onPressed: () {
                      //Llamamos al method deleteLogicoAreaComun() de DatabaseHelper
                      db.deleteLogicoAreaComun(acomunes[index].idAreaComun!).whenComplete(() {
                        //Después de eliminar, refrescamos la bd
                        _refresh();
                      });
                    }, 
                  ),
                  onTap: () {
                    //Cuando se haga click sobre un registro
                    setState(() {
                      nombre.text = acomunes[index].nombre;
                      costoAlquiler.text = acomunes[index].costoAlquiler.toString();
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
                                      //Actualizamos los campos necesarios del registro
                                      db.updateAreaComun(
                                        nombre.text, 
                                        costoAlquiler.text, 
                                        acomunes[index].idAreaComun).whenComplete(() {
                                          //Después de actualizar, _refresh()
                                          _refresh();
                                          Navigator.pop(context);
                                        });
                                    }, 
                                    child: const Text( 'Update', style: TextStyle(color: Colors.white) )
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
                              //TextFormField() nombre
                              TextFormField(
                                controller: nombre,
                                validator: (value) {
                                  if ( value!.isEmpty ) {
                                    return "Nombre de Área Común es requerido";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  label: Text( 'Nombre de área común', style: TextStyle(fontSize: 25) )
                                ),
                              ),
                              //TextFormField CostodeAlquiler
                              TextFormField(
                                controller: costoAlquiler,
                                validator: (value) {
                                  if ( value!.isEmpty ) {
                                    return "Costo de alquiler es requerido";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  label: Text( 'Costo de Alquiler',style: TextStyle(fontSize: 25) )
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              }, 
              separatorBuilder: ( _, __ ) => const Divider(), 
              itemCount: acomunes.length
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        // backgroundColor: Colors.indigo,
        onPressed: () {
          //We need to call refresh method after a new area comun is created
          Navigator.push( context, MaterialPageRoute(
            builder: (context) => const AreaComunCreate())).then((value) {
              if (value) {
                //_refresh() al Scaffold
                _refresh();
              }
            });
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Agregar Área Común', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}