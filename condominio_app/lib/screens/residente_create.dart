import 'package:condominio_app/jsonmodels/models.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';

class ResidenteCreate extends StatefulWidget {
  const ResidenteCreate({super.key});

  @override
  State<ResidenteCreate> createState() => _ResidenteCreateState();
}

class _ResidenteCreateState extends State<ResidenteCreate> {

  final myStyle = const TextStyle(fontSize: 25);

  final idResidente = TextEditingController();
  final password = TextEditingController();
  final nombre = TextEditingController();
  final aPaterno = TextEditingController();
  final aMaterno = TextEditingController();
  final fechaNacimiento = TextEditingController();
  final telefono = TextEditingController();
  final email = TextEditingController();
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
              //With check, we add a new residente
              //No se permiten empty values
              if ( formKey.currentState!.validate() ) {
                db.createResidente(ResidenteModel(
                  idResidente: int.parse(idResidente.text), 
                  password: password.text, 
                  nombre: nombre.text, 
                  aPaterno: aPaterno.text, 
                  aMaterno: aMaterno.text, 
                  fechaNacimiento: fechaNacimiento.text, 
                  telefono: telefono.text, 
                  email: email.text, 
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
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // TextFormField() idResidente
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: idResidente,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Número de CI, campo obligatorio";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text('Número de CI')
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
                      value: "39 TIPOS DE GAYS",
                      child: Text( '39 tipos de gays' )
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
        )
      )
    );
  }
}