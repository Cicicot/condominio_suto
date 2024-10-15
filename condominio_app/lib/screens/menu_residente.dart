import 'package:condominio_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MenuResidente extends StatefulWidget {
  const MenuResidente({super.key});

  @override
  State<MenuResidente> createState() => _MenuResidenteState();
}

class _MenuResidenteState extends State<MenuResidente> {

  final fontSize25 = const TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold);
  final fontSize20 = const TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( 'Conforty', style: fontSize25 ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue
              ),
              child: Column(
                children: [
                  Text('Residente', style: fontSize25 ),
                  Text('Condominio Sutó', style: fontSize20 )
                ],
              )
            ),
            Column(
              children: [
                ListTile(
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon( Icons.logout ),
                      Text('Cerrar sesión'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
                  },
                ),
              ],
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
             const SizedBox(height: 100),
              SvgPicture.asset(
                'lib/assets/businesswoman.svg',
                height: 150,
              ),
              const SizedBox(height: 100),
              SvgPicture.asset(
                'lib/assets/businessman.svg',
                height: 150,
              ),
          ],
        ),
      )
    );
  }
}