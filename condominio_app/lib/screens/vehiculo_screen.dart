import 'package:condominio_app/jsonmodels/models.dart';
import 'package:condominio_app/screens/vehiculo_create.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';

class VehiculoScreen extends StatefulWidget {
  const VehiculoScreen({super.key});

  @override
  State<VehiculoScreen> createState() => _VehiculoScreenState();
}

class _VehiculoScreenState extends State<VehiculoScreen> {

  late DatabaseHelper handler;
  late Future<List<VehiculoModel>> vehiculos;

  final db = DatabaseHelper();

  final idVehiculo = TextEditingController();
  String? tipo;
  final marca = TextEditingController();
  final color = TextEditingController();

  final keyword = TextEditingController();

  final fontSize25 = const TextStyle(fontSize: 25);
  final fontSize20 = const TextStyle(fontSize: 20);

  @override
  void initState() {
    handler = DatabaseHelper();
    vehiculos = handler.getVehiculosActivos();
    handler.initDB().whenComplete(() {
      //Antes de la siguiente línea de código, crear el método getAllVehiculos()
      vehiculos = getAllVehiculos();
    });
    super.initState();
  }

  Future<List<VehiculoModel>> getAllVehiculos() {
    return handler.getVehiculosActivos();
  }

  Future<void> _refresh() async {
    setState(() {
      vehiculos = getAllVehiculos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 210, 214, 245),
      appBar: AppBar(
        title: const Text( 'VEHÍCULOS', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white) ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: vehiculos, 
        builder: (context, AsyncSnapshot<List<VehiculoModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center( child: CircularProgressIndicator() );
          } else if ( snapshot.hasError ) {
            return Text( snapshot.error.toString() );
          } else {
            final vehicles = snapshot.data ?? <VehiculoModel>[];
            return ListView.separated(
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text( vehicles[i].idVehiculo, style: fontSize25 ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( vehicles[i].tipo, style: fontSize20 ),
                      Text( vehicles[i].marca, style: fontSize20 ),
                      Text( vehicles[i].color, style: fontSize20 )
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      //We call delete method
                      db.deleteLogicoVehiculo(vehicles[i].idVehiculo).whenComplete(() {
                        //After to delete register, _refresh()
                        _refresh();
                      });
                    }, 
                    icon: const Icon( Icons.delete, color: Colors.red, size: 30 ),
                  ),
                  onTap: () {
                    //When click on a register
                    setState(() {
                      idVehiculo.text = vehicles[i].idVehiculo;
                      tipo = vehicles[i].tipo;
                      marca.text = vehicles[i].marca;
                      color.text = vehicles[i].color;
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
                                      db.updateVehiculo(
                                        tipo!, 
                                        marca.text, 
                                        color.text, 
                                        vehicles[i].idVehiculo).whenComplete(() {
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
                          title: const Text( 'Update Usuario' ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // DropDownButtonItem() tipo
                                DropdownButtonFormField<String>(
                                  value: tipo,
                                  items: const [
                                    DropdownMenuItem(
                                      value: "AUTOMÓVIL",
                                      child: Text( 'Automóvil' )
                                    ),
                                    DropdownMenuItem(
                                      value: "VAGONETA",
                                      child: Text( 'Vagoneta' )
                                    ),
                                    DropdownMenuItem(
                                      value: "CAMIONETA",
                                      child: Text( 'Camioneta' )
                                    ),
                                    DropdownMenuItem(
                                      value: "MOTOCICLETA",
                                      child: Text( 'Motocicleta' )
                                    ),
                                    DropdownMenuItem(
                                      value: "MOTOCARRO",
                                      child: Text( 'Motocarro' )
                                    ),
                                    DropdownMenuItem(
                                      value: "OTRO",
                                      child: Text( 'Otro' )
                                    ),
                                  ], 
                                  onChanged: (value) {
                                    setState(() {
                                      tipo = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return "Tipo es requerido";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    label: Text('Tipo')
                                  ),
                                ),
                                // TextFormField() marca
                                TextFormField(
                                  controller: marca,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Marca, campo obligatorio";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    label: Text('Marca')
                                  ),
                                ),
                                // TextFormField() color
                                TextFormField(
                                  controller: color,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Color, campo obligatorio";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    label: Text('Color')
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
              itemCount: vehicles.length
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const VehiculoCreate())).then((value) {
              if (value) {
                _refresh();
              }
            });
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Agregar Vehículo', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
