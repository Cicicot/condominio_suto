import 'package:condominio_app/jsonmodels/models.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';

class VisitaCreate extends StatefulWidget {
  const VisitaCreate({super.key});

  @override
  State<VisitaCreate> createState() => _VisitaCreateState();
}

class _VisitaCreateState extends State<VisitaCreate> {

  final myStyle = const TextStyle(fontSize: 25);

  final idVisita = TextEditingController();
  final nombre = TextEditingController();
  final aPaterno = TextEditingController();
  final aMaterno = TextEditingController();
  String? genero;

  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( 'CREAR VISITA', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white) ),
        actions: [
          IconButton(
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              //With check, we add a new visita
              //Not allowed empty values
              if ( formKey.currentState!.validate() ) {
                db.createVisita(VisitaModel(
                  idVisita: idVisita.text, 
                  nombre: nombre.text, 
                  aPaterno: aPaterno.text, 
                  aMaterno: aMaterno.text, 
                  genero: genero!, 
                  estado: "1", 
                  fechaAlta: DateTime.now().toString(), 
                  fechaEdit: DateTime.now().toString())).whenComplete(() {
                    Navigator.of(context).pop(true);
                  },);
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
                // TextFormField() idVisita
                TextFormField(
                  controller: idVisita,
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
          ),
        )
      ),
      //nombre, aPaterno, aMaterno, genero
    );
  }
}