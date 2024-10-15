import 'package:condominio_app/jsonmodels/models.dart';
import 'package:condominio_app/screens/screens.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';

class ResidenteScreen extends StatefulWidget {
  const ResidenteScreen({super.key});

  @override
  State<ResidenteScreen> createState() => _ResidenteScreenState();
}

class _ResidenteScreenState extends State<ResidenteScreen> {

  late DatabaseHelper handler;
  late Future<List<ResidenteModel>> residentes;

  final db = DatabaseHelper();

  final idResidente = TextEditingController();
  final password = TextEditingController();
  final nombre = TextEditingController();
  final aPaterno = TextEditingController();
  final aMaterno = TextEditingController();
  final fechaNacimiento = TextEditingController();
  final telefono = TextEditingController();
  final email = TextEditingController();
  String? genero;
  
 final keyword = TextEditingController();

  final fontSize25 = const TextStyle(fontSize: 25);
  final fontSize20 = const TextStyle(fontSize: 20);

  @override
  void initState() {
    handler = DatabaseHelper();
    residentes = handler.getResidentesActivos();
    handler.initDB().whenComplete(() {
      //Antes de la siguiente línea, crear el método getAllResidentes() 
      residentes = getAllResidentes();
    });
    super.initState();
  }

  Future<List<ResidenteModel>> getAllResidentes() async {
    return handler.getResidentesActivos();
  } 

  //_refresh() method
  Future<void> _refresh() async {
    setState(() {
      residentes = getAllResidentes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( 'RESIDENTES', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white) ),
        centerTitle: true,
      ),
      //First, we are going to show residentes
      body: FutureBuilder(
        future: residentes, 
        builder: (context, AsyncSnapshot<List<ResidenteModel>> snapshot) {
          if ( snapshot.connectionState == ConnectionState.waiting ) {
            return const Center(child: CircularProgressIndicator());
          } else if ( snapshot.hasError ) {
            return Text( snapshot.error.toString() );
          } else {
            final residents = snapshot.data ?? <ResidenteModel>[];
            return ListView.separated(
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text( residents[i].idResidente.toString(), style: fontSize25 ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( residents[i].password, style: fontSize20 ),
                      Text( residents[i].nombre, style: fontSize20 ),
                      Text( residents[i].aPaterno, style: fontSize20 ),
                      Text( residents[i].aMaterno, style: fontSize20 ),
                      Text( residents[i].fechaNacimiento, style: fontSize20 ),
                      Text( residents[i].telefono, style: fontSize20 ),
                      Text( residents[i].email, style: fontSize20 ),
                      Text( residents[i].genero, style: fontSize20 ),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      //We call delete method from DatabaseHelper()
                      db.deleteLogicoResidente(residents[i].idResidente.toString()).whenComplete(() {
                        //After to delete registers, _refresh() bd
                        _refresh();
                      });
                    }, 
                    icon: const Icon( Icons.delete, color: Colors.red, size: 30 ),
                  ),
                  onTap: () {
                    //When click on a register
                    setState(() {
                      idResidente.text = residents[i].idResidente.toString();
                      password.text = residents[i].password;
                      nombre.text = residents[i].nombre;
                      aPaterno.text = residents[i].aPaterno;
                      aMaterno.text = residents[i].aMaterno;
                      fechaNacimiento.text = residents[i].fechaNacimiento;
                      telefono.text = residents[i].telefono;
                      email.text = residents[i].email;
                      genero = residents[i].genero;
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
                                      db.updateResidente(
                                        password.text, 
                                        nombre.text, 
                                        aPaterno.text, 
                                        aMaterno.text, 
                                        fechaNacimiento.text, 
                                        telefono.text, 
                                        email.text, 
                                        genero!, 
                                        residents[i].idResidente).whenComplete(() {
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
                          title: const Text( 'Update Residente' ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // TextFormField() password
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                controller: password,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "contraseña, campo obligatorio";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  label: Text('Contraseña')
                                ),
                              ),
                              // TextFormField() nombre
                              TextFormField(
                                keyboardType: TextInputType.name,
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
                                keyboardType: TextInputType.name,
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
                                keyboardType: TextInputType.name,
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
                              // TextFormField() fechaNacimiento
                              TextFormField(
                                keyboardType: TextInputType.datetime,
                                controller: fechaNacimiento,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Fecha de nacimiento, campo obligatorio";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  label: Text('Fecha de nacimiento: DD/MM/AAAA')
                                ),
                              ),
                              // TextFormField() teléfono
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: telefono,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Teléfono, campo obligatorio";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  label: Text('Teléfono')
                                ),
                              ),
                              // TextFormField() email
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: email,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Email, campo obligatorio";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  label: Text('Email')
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
                                  DropdownMenuItem(
                                    value: "93 TIPOS DE GAYS",
                                    child: Text( '93 tipos de gays' )
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
              itemCount: residents.length
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const ResidenteCreate())).then((value) {
              if (value) {
                _refresh();
              }
            });
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Agregar Residente', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}