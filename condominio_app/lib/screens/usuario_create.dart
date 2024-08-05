import 'package:condominio_app/jsonmodels/models.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';

class UsuarioCreate extends StatefulWidget {
  const UsuarioCreate({super.key});

  @override
  State<UsuarioCreate> createState() => _UsuarioCreateState();
}

class _UsuarioCreateState extends State<UsuarioCreate> {

  final myStyle = const TextStyle(fontSize: 25);

  final idUsuario = TextEditingController();
  final password = TextEditingController();
  final nombre = TextEditingController();
  final aPaterno = TextEditingController();
  final aMaterno = TextEditingController();
  String? tipo;
  final telefono = TextEditingController();
  String? genero;

  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( 'CREAR USUARIO', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white) ),
        actions: [
          IconButton(
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              //With check, we add a new user
              //No se permiten empty values
              if ( formKey.currentState!.validate() ) {
                db.createUsuario(UsuarioModel(
                  idUsuario: idUsuario.text, 
                  password: password.text, 
                  nombre: nombre.text, 
                  aPaterno: aPaterno.text, 
                  aMaterno: aMaterno.text, 
                  tipo: tipo!, 
                  telefono: telefono.text, 
                  genero: genero!, 
                  estado: "1", 
                  fechaAlta: DateTime.now().toString(), 
                  fechaEdit: DateTime.now().toString())).whenComplete(() {
                    Navigator.of(context).pop(true);
                  });
              }
            }, 
            icon: const Icon( Icons.check )
          )
        ],
      ),
      body: Form(
        //Remember to put formKey
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // TextFormField() idUsuario
                TextFormField(
                  controller: idUsuario,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Cédula de identidad, campo obligatorio";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text('Cédula de identidad')
                  ),
                ),
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
                ),// DropDownButtonItem() tipo
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
        ),
      ),
    );
  }
}