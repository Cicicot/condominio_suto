
import 'package:condominio_app/jsonmodels/expensa_model.dart';
import 'package:condominio_app/sqlite/sqlite.dart';
import 'package:flutter/material.dart';

class ExpensaCreate extends StatefulWidget {
  const ExpensaCreate({super.key});

  @override
  State<ExpensaCreate> createState() => _ExpensaCreateState();
}

class _ExpensaCreateState extends State<ExpensaCreate> {

  final myStyle = const TextStyle(fontSize: 25);

  final idExpensa = TextEditingController();
  final descripcion = TextEditingController();
  final monto = TextEditingController();
  String? isPagado;
  final fechaPago = TextEditingController();

  // final formKey = GlobalKey<FormState>;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( 'CREAR EXPENSA', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white) ),
        actions: [
          IconButton(
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              //With the checkButton we add a new expensa
              //We don't let empty values
              if ( formKey.currentState!.validate() ){
                db.createExpensa(ExpensaModel(
                  descripcion: descripcion.text, 
                  monto: int.parse(monto.text), 
                  isPagado: isPagado!, 
                  fechaPago: "Sin fecha")).whenComplete(() {
                    Navigator.of(context).pop(true);
                  });
              }
            }, 
            icon: const Icon( Icons.check )
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            //TextFormField descripción
            TextFormField(
              keyboardType: TextInputType.text,
              controller: descripcion,
              validator: (value) {
                if ( value!.isEmpty ) {
                  return "Descripción, campo obligatorio";
                }
                return null;
              },
              decoration: const InputDecoration(
                label: Text('Ingrese una descripción')
              ),
            ),
            //TextFormField monto
            TextFormField(
              keyboardType: TextInputType.number,
              controller: monto,
              validator: (value) {
                if ( value!.isEmpty ) {
                  return "Monto en Bs, campo obligatorio";
                }
                return null;
              },
              decoration: const InputDecoration(
                label: Text('Ingrese un monto de expensa')
              ),
            ),
            // DropDownButtonItem() isPagado
            DropdownButtonFormField<String>(
              value: isPagado,
              items: const [
                DropdownMenuItem(
                  value: "Pago realizado",
                  child: Text( 'Pago realizado' )
                ),
                DropdownMenuItem(
                  value: "Pago no realizado",
                  child: Text( 'Pago no realizado' )
                )
              ], 
              onChanged: (value) {
                setState(() {
                  isPagado = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return "Pago realizado, campo obligatorio";
                }
                return null;
              },
              decoration: const InputDecoration(
                label: Text('¿Pago realizado?')
              ),
            ),
          ],
        )
      ),
    );
  }
}