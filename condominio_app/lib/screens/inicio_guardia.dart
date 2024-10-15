
import 'package:condominio_app/screens/screens.dart';
import 'package:flutter/material.dart';

class InicioGuardia extends StatefulWidget {
  const InicioGuardia({super.key});

  @override
  State<InicioGuardia> createState() => _InicioGuardiaState();
}

class _InicioGuardiaState extends State<InicioGuardia> {

  final fontSize26title = const TextStyle(fontSize: 26, fontWeight: FontWeight.bold);
  final fontSize20 = const TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text( 'Bienvenido Sr. Guardia.', style: fontSize26title ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (context) => const HomeGuardia(),
            )
          );
        },
        label: const Text( 'Ingresar', style: TextStyle(color: Colors.white) ),
      ),
    );
  }
}