import 'package:condominio_app/screens/screens.dart';
import 'package:flutter/material.dart';

class HomeResidente extends StatefulWidget {
  const HomeResidente({super.key});

  @override
  State<HomeResidente> createState() => _HomeResidenteState();
}

class _HomeResidenteState extends State<HomeResidente> {

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MenuResidente(),
    ReservaScreen(),
    ReportesScreen()
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
            icon: Icon( Icons.menu ),
            activeIcon: Icon( Icons.menu_rounded ),
            label: 'Menú'
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.yard ),
            activeIcon: Icon( Icons.yard_rounded ),
            label: 'Reservas'
          ),
          BottomNavigationBarItem(
            icon: Icon( Icons.report ),
            activeIcon: Icon( Icons.report_outlined ),
            label: 'Reportes'
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}