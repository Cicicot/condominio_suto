import 'package:condominio_app/screens/screens.dart';
import 'package:flutter/material.dart';

class HomeAdministrador extends StatefulWidget {
  const HomeAdministrador({super.key});

  @override
  State<HomeAdministrador> createState() => _HomeAdministradorState();
}

class _HomeAdministradorState extends State<HomeAdministrador> {

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    UsuarioScreen(),
    ResidenteScreen(),
    AreaComunScreen(),
    PropiedadScreen(),
    VehiculoScreen(),
    VisitaScreen()
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
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon( Icons.boy ),
            activeIcon: Icon( Icons.boy_outlined ),
            label: 'Usuarios'
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.person_outline ),
            activeIcon: Icon( Icons.person ),
            label: 'Residente'
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.home_outlined ),
            activeIcon: Icon( Icons.home ),
            label: 'Área Común'
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.article_outlined ),
            activeIcon: Icon( Icons.article ),
            label: 'Propiedades'
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.commute ),
            activeIcon: Icon( Icons.commute_outlined ),
            label: 'Vehículos'
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.car_crash_outlined ),
            activeIcon: Icon( Icons.car_crash ),
            label: 'Visitas'
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}