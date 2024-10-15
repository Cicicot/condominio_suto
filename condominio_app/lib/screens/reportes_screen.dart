import 'package:flutter/material.dart';

class ReportesScreen extends StatefulWidget {
  const ReportesScreen({super.key});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text( 'REPORTES',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)  ),
      ),  
      body: const Center(
        child: Text( 'Pantalla de Reportes' )
      ),
    );
  }
}