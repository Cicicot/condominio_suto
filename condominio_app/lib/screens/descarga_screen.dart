import 'package:condominio_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Descarga extends StatefulWidget {
  const Descarga({super.key});

  @override
  State<Descarga> createState() => _DescargaState();
}

class _DescargaState extends State<Descarga> {

  final fontSize25boldWhite = const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 73, 160, 236));
  final fontSize20title = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  final fontSize20 = const TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Administra tu tiempo', style: fontSize25boldWhite ),
              const SizedBox(height: 10),
              SvgPicture.asset(
                'lib/assets/building.svg',
                height: 150,
              ),
              const SizedBox(height: 10),
              Text( 'Reserva áreas comunes', style: fontSize25boldWhite ),
              Text( 'para tus momentos especiales', style: fontSize25boldWhite ),
              SvgPicture.asset(
                'lib/assets/home.svg',
                height: 200,
              ),
              Text( 'Paga tus expensas', style: fontSize25boldWhite ),
              SvgPicture.asset(
                'lib/assets/money.svg',
                height: 150,
              ),
              const SizedBox(height: 10),
              Text( 'Descarga la App ', style: fontSize25boldWhite ),
              Text( 'Conforty ', style: fontSize25boldWhite ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: SvgPicture.asset(
                  'lib/assets/download.svg',
                  height: 150,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      )
    );
  }
}