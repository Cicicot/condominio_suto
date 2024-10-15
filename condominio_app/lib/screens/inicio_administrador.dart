import 'package:condominio_app/screens/home_administrador.dart';
import 'package:flutter/material.dart';

class InicioAdministrador extends StatefulWidget {
  const InicioAdministrador({super.key});

  @override
  State<InicioAdministrador> createState() => _InicioAdministradorState();
}

class _InicioAdministradorState extends State<InicioAdministrador> {

  final fontSize26title = const TextStyle(fontSize: 26, fontWeight: FontWeight.bold);
  final fontSize20 = const TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text( 'Bienvenido Sr. Administrador.', style: fontSize26title ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (context) => const HomeAdministrador(),
            )
          );
        },
        label: const Text( 'Ingresar', style: TextStyle(color: Colors.white) ),
      ),
    );
  }
}