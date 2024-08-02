import 'package:condominio_app/jsonmodels/models.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';


class PropiedadCreate extends StatefulWidget {
  const PropiedadCreate({super.key});

  @override
  State<PropiedadCreate> createState() => _PropiedadCreateState();
}

class _PropiedadCreateState extends State<PropiedadCreate> {

  final fontSize25bold = const TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

  final piso = TextEditingController();
  final dpto = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text( 'CREAR PROPIEDADES', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white) ),
        actions: [
          IconButton(
            onPressed: () {
              //with check icon, we add the propiedad
              //We shouldn't allow null values in db
              if (formKey.currentState!.validate()) {
                db.createPropiedad(PropiedadModel(
                  estado: "1", 
                  nroPiso: piso.text, 
                  nroDpto: dpto.text, 
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
          padding: const EdgeInsets.all(10.0) ,
          child: Column(
            children: [
              TextFormField(
                controller: piso,
                validator: (value) {
                  if ( value!.isEmpty ) {
                    return "Nro piso is required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text( 'Nro Piso' )
                ),
              ),
              TextFormField(
                controller: dpto,
                validator: (value) {
                  if ( value!.isEmpty ) {
                    return "Nro dpto is required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text( 'Nro Departamento' )
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}