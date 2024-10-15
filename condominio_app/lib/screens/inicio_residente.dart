import 'package:condominio_app/screens/home_residente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InicioResidente extends StatefulWidget {
  const InicioResidente({super.key});

  @override
  State<InicioResidente> createState() => _InicioResidenteState();
}

class _InicioResidenteState extends State<InicioResidente> {
  
final fontSize25boldLightBlue = const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 73, 160, 236));
final fontSize20title = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
final fontSize20 = const TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text( 'Bienvenido, Sr. Residente', style: fontSize25boldLightBlue ),
                const SizedBox(height: 10),
                Text( 'Ud. puede:', style: fontSize25boldLightBlue ),
                const SizedBox(height: 15),
                Text( '1. Solicitar reserva de', style: fontSize25boldLightBlue ),
                Text( 'áreas comunes', style: fontSize25boldLightBlue ),
                const SizedBox(height: 15),
                SvgPicture.asset(
                  'lib/assets/buildings.svg',
                  height: 150,
                ),
                const SizedBox(height: 15),
                Text( '2. Ver pagos realizados, y', style: fontSize25boldLightBlue ),
                const SizedBox(height: 15),
                SvgPicture.asset(
                  'lib/assets/payments.svg',
                  height: 150,
                ),
                const SizedBox(height: 15),
                Text( '3. Ver reportes.', style: fontSize25boldLightBlue ),
                const SizedBox(height: 15),
                SvgPicture.asset(
                  'lib/assets/reportes.svg',
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (context) => const HomeResidente(),
            )
          );
        }, 
        label: const Text('Continuar', style: TextStyle(color: Colors.white))
      ),
    );
  }
}