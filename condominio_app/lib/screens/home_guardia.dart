import 'package:condominio_app/screens/screens.dart';
import 'package:flutter/material.dart';

class HomeGuardia extends StatefulWidget {
  const HomeGuardia({super.key});

  @override
  State<HomeGuardia> createState() => _HomeGuardiaState();
}

class _HomeGuardiaState extends State<HomeGuardia> {

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    VisitaScreen(),
    VehiculoScreen(),
    SalirScreen()
  ];

  void _onItemTapped( int index ) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt( _selectedIndex ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon( Icons.person ),
            activeIcon: Icon( Icons.person_2_outlined ),
            label: 'Visitas'
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.commute ),
            activeIcon: Icon( Icons.commute_outlined ),
            label: 'Vehículos'
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.output ),
            activeIcon: Icon( Icons.outbond_outlined ),
            label: 'Salir'
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}