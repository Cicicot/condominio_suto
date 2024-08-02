import 'package:condominio_app/jsonmodels/models.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';

class VehiculoCreate extends StatefulWidget {
  const VehiculoCreate({super.key});

  @override
  State<VehiculoCreate> createState() => _VehiculoCreateState();
}

class _VehiculoCreateState extends State<VehiculoCreate> {

  final myStyle = const TextStyle(fontSize: 25);

  final idVehiculo = TextEditingController();
  String? tipo;
  final marca = TextEditingController();
  final color = TextEditingController();
  final estado = TextEditingController();
  final fechaAlta = TextEditingController();
  final fechaEdit = TextEditingController();

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
              //With check, we add new vehicle
              //No se permiten empty values in bd
              if ( formKey.currentState!.validate() ) {
                db.createVehiculo(VehiculoModel(
                  idVehiculo: idVehiculo.text, 
                  tipo: tipo!, 
                  marca: marca.text, 
                  color: color.text, 
                  estado: "1", 
                  fechaAlta: DateTime.now().toString(), 
                  fechaEdit: DateTime.now().toString())).whenComplete(() {
                    Navigator.of(context).pop(true);
                  });
              }
            }, 
            icon: const Icon( Icons.check )
          ),
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
                // TextFormField() idVehiculo (PLACA)
                TextFormField(
                  controller: idVehiculo,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Placa, campo obligatorio";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text('Placa')
                  ),
                ),
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
          ),
        )
      )
    );
  }
}