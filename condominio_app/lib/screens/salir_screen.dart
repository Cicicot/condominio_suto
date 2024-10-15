import 'package:condominio_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SalirScreen extends StatefulWidget {
  const SalirScreen({super.key});

  @override
  State<SalirScreen> createState() => _SalirScreenState();
}

class _SalirScreenState extends State<SalirScreen> {

  final fontSize25boldWhite = const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 73, 160, 236));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Gracias por utilizar Conforty', style: fontSize25boldWhite ),
              const SizedBox(height: 10),
              Text('click sobre el ícono para salir', style: fontSize25boldWhite ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: SvgPicture.asset(
                  'lib/assets/salir.svg',
                  height: 150,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}