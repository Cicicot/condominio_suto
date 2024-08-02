
import 'package:condominio_app/jsonmodels/models.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';

class AreaComunCreate extends StatefulWidget {
  const AreaComunCreate({super.key});

  @override
  State<AreaComunCreate> createState() => _AreaComunCreateState();
}

class _AreaComunCreateState extends State<AreaComunCreate> {

  final fontSize25bold = const TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

  final nombre = TextEditingController();
  final costoAlquiler = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.indigo,
        title: const Text( 'CREAR ÁREA COMÚN', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white) ),
        actions: [
          IconButton(
            onPressed: () {
              //With the check icon, we add the area común
              //We shouldn't allow null values in db
              if ( formKey.currentState!.validate() ) {
                db.createAreaComun(AreaComunModel(
                  nombre: nombre.text, 
                  costoAlquiler: double.parse(costoAlquiler.text), 
                  estado: "1", 
                  fechaAlta: DateTime.now().toString(), 
                  fechaEdit: DateTime.now().toString())).whenComplete(() {
                    //When this value is true, apply _refresh()
                    Navigator.of(context).pop(true);                    
                  });
              }
            }, 
            icon: const Icon( Icons.check, color: Colors.white, size: 35 )
          )
        ],
      ),
      body: Form(
        //Remember put the key
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: nombre,
                validator: (value) {
                  if ( value!.isEmpty ) {
                    return "Nombre es requerido";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text( 'Nombre de Área común' )
                ),
              ),
              TextFormField(
                controller: costoAlquiler,
                validator: (value) {
                  if ( value!.isEmpty ) {
                    return "Costo de alquiler es requerido";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text( 'Costo de alquiler' )
                ),
              )
            ],
          ),
        )
      )
    );
  }
}