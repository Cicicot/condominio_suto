
import 'package:condominio_app/jsonmodels/models.dart';
import 'package:condominio_app/screens/screens.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';

class UsuarioScreen extends StatefulWidget {
  const UsuarioScreen({super.key});

  @override
  State<UsuarioScreen> createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {

  late DatabaseHelper handler;
  late Future<List<UsuarioModel>> usuarios;

  final db = DatabaseHelper();

  final idUsuario = TextEditingController();
  final password = TextEditingController();
  final nombre = TextEditingController();
  final aPaterno = TextEditingController();
  final aMaterno = TextEditingController();
  String? tipo;
  final telefono = TextEditingController();
  String? genero;

  final keyword = TextEditingController();

  final fontSize25 = const TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold);
  final fontSize20 = const TextStyle(fontSize: 20);

  @override
  void initState() {
    handler = DatabaseHelper();
    usuarios = handler.getUsuariosActivos();
    handler.initDB().whenComplete(() {
      //Antes de la siguiente línea, crea el método getAllUsuarios()
      usuarios = getAllUsuarios();
    });
    super.initState();
  }

  Future<List<UsuarioModel>> getAllUsuarios() async {
    return handler.getUsuariosActivos();
  }

  //_refresh() method
  Future<void> _refresh() async {
    setState(() {
      usuarios = getAllUsuarios();
    });
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( 'USUARIOS', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white) ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue
              ),
              child: Column(
                children: [
                  Text('Administrador', style: fontSize25 ),
                  Text('Condominio Sutó', style: fontSize20 )
                ],
              )
            ),
            Column(
              children: [
                ListTile(
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon( Icons.account_balance ),
                      Text('Realizar Reserva'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const ReservaScreen(),
                    ));
                  },
                ),
                ListTile(
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon( Icons.logout ),
                      Text('Cerrar sesión'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
                  },
                ),
              ],
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: usuarios, 
        builder: (context, AsyncSnapshot<List<UsuarioModel>> snapshot) {
          if ( snapshot.connectionState == ConnectionState.waiting ) {
            return const Center( child: CircularProgressIndicator() );
          } else if ( snapshot.hasError ) {
            return Text( snapshot.error.toString() );
          } else {
            final users = snapshot.data ?? <UsuarioModel>[];
            return ListView.separated(
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text( users[i].idUsuario, style: fontSize25 ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( users[i].password, style: fontSize20 ),
                      Text( users[i].nombre, style: fontSize20 ),
                      Text( users[i].aPaterno, style: fontSize20 ),
                      Text( users[i].aMaterno, style: fontSize20 ),
                      Text( users[i].tipo, style: fontSize20 ),
                      Text( users[i].telefono, style: fontSize20 ),
                      Text( users[i].genero, style: fontSize20 ),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      //We call delete method from DatabaseHelper()
                      db.deleteLogicoUsuario(users[i].idUsuario).whenComplete(() {
                        //After to delete register, _refresh()
                        _refresh();  
                      });
                    }, 
                    icon: const Icon( Icons.delete, color: Colors.red, size: 30 ),
                  ),
                  onTap: () {
                    //When click on a register
                    setState(() {
                      idUsuario.text = users[i].idUsuario;
                      password.text = users[i].password;
                      nombre.text = users[i].nombre;
                      aPaterno.text = users[i].aPaterno;
                      aMaterno.text = users[i].aMaterno;
                      tipo = users[i].tipo;
                      telefono.text = users[i].telefono;
                      genero = users[i].genero;
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
                                      db.updateUsuario(
                                        password.text, 
                                        nombre.text, 
                                        aPaterno.text, 
                                        aMaterno.text, 
                                        tipo!, 
                                        telefono.text, 
                                        genero!, 
                                        users[i].idUsuario).whenComplete(() {
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
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // TextFormField() password
                                TextFormField(
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
                                // DropDownButtonItem() tipo
                                DropdownButtonFormField<String>(
                                  value: tipo,
                                  items: const [
                                    DropdownMenuItem(
                                      value: "ADMINISTRADOR",
                                      child: Text( 'Administrador' )
                                    ),
                                    DropdownMenuItem(
                                      value: "GUARDIA DE SEGURIDAD",
                                      child: Text( 'Guardia de Seguridad' )
                                    ),
                                  ], 
                                  onChanged: (value) {
                                    setState(() {
                                      tipo = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return "Tipo, campo obligatorio";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    label: Text('Tipo')
                                  ),
                                ),
                                // TextFormField() teléfono
                                TextFormField(
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
                          ),
                        );
                      },
                    );
                  },
                );
              }, 
              separatorBuilder: ( _, __ ) => const Divider( thickness: 3, color: Color.fromARGB(255, 80, 74, 58) ), 
              itemCount: users.length
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const UsuarioCreate())).then((value) {
              if (value) {
                _refresh();
              }
            });
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Agregar Usuario', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}