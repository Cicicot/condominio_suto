import 'package:condominio_app/jsonmodels/models.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';

class ReservaCreate extends StatefulWidget {
  const ReservaCreate({super.key});

  @override
  State<ReservaCreate> createState() => _ReservaCreateState();
}

class _ReservaCreateState extends State<ReservaCreate> {

  final myStyle = const TextStyle(fontSize: 25);

  final idReserva         = TextEditingController(); //Aumentado recién
  final idResidente       = TextEditingController();
  final nombreResidente   = TextEditingController();
  final aPaternoResidente = TextEditingController();
  final aMaternoResidente = TextEditingController();
  final idAreaComun       = TextEditingController();
  final nombreAreaComun   = TextEditingController();
  final alquilerAreaComun   = TextEditingController();
  String? isAceptado;
  final fechaHoraInicio   = TextEditingController();
  final fechaHoraFinal    = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text( 'HACER RESERVAS', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white) ),
        actions: [
          IconButton(
            onPressed: () {
              //Con el check se agrega la reserva
              //No se permiten valores vacíos en la bd
              if (formKey.currentState?.validate() ?? false) { //formKey.currentState!.validate() era
                try {
                  db.createReserva(ReservaModel(
                  idResidente: int.parse(idResidente.text), 
                  idAreaComun: int.parse(idAreaComun.text),
                  fechaHoraInicio: fechaHoraInicio.text, 
                  fechaHoraFinal: fechaHoraFinal.text
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reserva agregada Exitosamente'),
                    duration: Duration(milliseconds: 1500),
                  ) 
                );
                Navigator.of(context).pop(true);
                } catch (e) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text(e.toString()))
                  // );
                  Navigator.of(context).pop(false);
                }
              }
            }, 
            icon: const Icon( Icons.check, color: Colors.white )
          )
        ],
      ),
      body: Form(
        key: formKey, //Asociamos el formKey al Form
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //TextFormField() idResidente
                TextFormField(
                  style: myStyle,
                  keyboardType: TextInputType.number,
                  controller: idResidente,
                  validator: (value) {
                    if (value == null || value.isEmpty) { //value!.isEmpty
                      return "idResidente es requerido";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text( 'Id del Residente' )
                  ),
                ),
                //TextFormField() de idAreaComun
                TextFormField(
                  style: myStyle,
                  keyboardType: TextInputType.number,
                  controller: idAreaComun,
                  validator: (value) {
                    if ( value == null || value.isEmpty ) { //value!.isEmpty
                      return "idAreaComun es requerido";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text( 'Id de Área Común' )
                  ),
                ),
                //TextFormField() para FechaHoraInicio
                TextFormField(
                  style: myStyle,
                  keyboardType: TextInputType.datetime,
                  controller: fechaHoraInicio,
                  validator: (value) {
                    if ( value == null || value.isEmpty ) { //value!.isEmpty
                      return "FechaHoraInicio es requerido";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text( 'Ingrese la fecha y hora de inicio. Ej: DD/MM/AAAA - hh:mm' )
                  ),
                ),
                //TextFormField() para FechaHoraFinal
                TextFormField(
                  style: myStyle,
                  keyboardType: TextInputType.datetime,
                  controller: fechaHoraFinal,
                  validator: (value) {
                    if ( value == null || value.isEmpty ) { //value!.isEmpty
                      return "FechaHoraFinal es requerido";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text( 'Ingrese la fecha y hora del final. Ej: DD/MM/AAAA - hh:mm' )
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