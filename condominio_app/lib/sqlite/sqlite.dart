import 'package:condominio_app/jsonmodels/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  final databaseName = "condominio.db";

  String propiedadTable = "CREATE TABLE propiedad(idPropiedad INTEGER PRIMARY KEY AUTOINCREMENT, nroPiso TEXT NOT NULL, nroDpto TEXT NOT NULL, estado TEXT NOT NULL, fecha_alta TEXT DEFAULT CURRENT_TIMESTAMP, fecha_edit TEXT DEFAULT CURRENT_TIMESTAMP)";
  String areacomunTable = "CREATE TABLE areacomun(idAreaComun INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL, costoAlquiler INTEGER NOT NULL, estado TEXT NOT NULL, fecha_alta TEXT DEFAULT CURRENT_TIMESTAMP, fecha_edit TEXT DEFAULT CURRENT_TIMESTAMP)";
  String vehiculoTable = "CREATE TABLE vehiculo(idVehiculo TEXT UNIQUE PRIMARY KEY NOT NULL, tipo TEXT NOT NULL, marca TEXT NOT NULL, color TEXT NOT NULL, estado TEXT NOT NULL, fecha_alta TEXT DEFAULT CURRENT_TIMESTAMP, fecha_edit TEXT DEFAULT CURRENT_TIMESTAMP)";
  String residenteTable = "CREATE TABLE residente(idResidente INTEGER UNIQUE PRIMARY KEY NOT NULL, password TEXT NOT NULL, nombre TEXT NOT NULL, aPaterno TEXT NOT NULL, aMaterno TEXT NOT NULL, fechaNacimiento TEXT NOT NULL, telefono TEXT NOT NULL, email TEXT NOT NULL, genero TEXT NOT NULL, estado TEXT NOT NULL, fecha_alta TEXT DEFAULT CURRENT_TIMESTAMP, fecha_edit TEXT DEFAULT CURRENT_TIMESTAMP)";
  String usuarioTable = "CREATE TABLE usuario(idUsuario TEXT UNIQUE PRIMARY KEY NOT NULL, password TEXT NOT NULL, nombre TEXT NOT NULL, aPaterno TEXT NOT NULL, aMaterno TEXT NOT NULL, tipo TEXT NOT NULL, telefono TEXT NOT NULL, genero TEXT NOT NULL, estado TEXT NOT NULL, fecha_alta TEXT DEFAULT CURRENT_TIMESTAMP, fecha_edit TEXT DEFAULT CURRENT_TIMESTAMP)";
  String visitaTable = "CREATE TABLE visita(idVisita TEXT UNIQUE PRIMARY KEY NOT NULL, nombre TEXT NOT NULL, aPaterno TEXT NOT NULL, aMaterno TEXT NOT NULL, genero TEXT NOT NULL, estado TEXT NOT NULL, fecha_alta TEXT DEFAULT CURRENT_TIMESTAMP, fecha_edit TEXT DEFAULT CURRENT_TIMESTAMP)";
  String reservaTable = "CREATE TABLE reserva(idReserva INTEGER PRIMARY KEY AUTOINCREMENT, idResidente INTEGER NOT NULL, idAreaComun INTEGER NOT NULL, fechaHora_inicio TEXT NOT NULL, fechaHora_final TEXT NOT NULL, isAceptado TEXT NOT NULL, FOREIGN KEY(idResidente) REFERENCES residente(idResidente), FOREIGN KEY(idAreaComun) REFERENCES areacomun(idAreaComun))";

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(areacomunTable);
      await db.execute(propiedadTable);
      await db.execute(vehiculoTable);
      await db.execute(residenteTable);
      await db.execute(usuarioTable);
      await db.execute(visitaTable);
      await db.execute(reservaTable);
    });
  }

  //Método Login
  Future<Map<String, dynamic>> login(String id, String password) async {
    final Database db = await initDB();

    // Consulta en la tabla usuario
    var usuarioResult = await db.rawQuery(
      "SELECT * FROM usuario WHERE idUsuario = ? AND password = ?",
      [id, password]
    );

    if (usuarioResult.isNotEmpty) {
      String tipoUsuario = usuarioResult.first['tipo'].toString();
      return {
        'success': true,
        'tipo': tipoUsuario,
        'usuario': tipoUsuario == 'ADMINISTRADOR' ? 'ADMINISTRADOR' : 'GUARDIA DE SEGURIDAD'
      };
    }

    // Consulta en la tabla residente
    var residenteResult = await db.rawQuery(
      "SELECT * FROM residente WHERE idResidente = ? AND password = ?",
      [id, password]
    );

    if (residenteResult.isNotEmpty) {
      return {
        'success': true,
        'usuario': 'residente'
      };
    }

    // Si no encuentra los credenciales en ninguna de las tablas
    return {
      'success': false
    };
  }

  //Verificación de existencia, antes de agregar una reserva
  Future<bool> existsResidente(int id) async {
    final Database db = await initDB();
    var result = await db.query(
      'residente',
      where: 'idResidente = ? AND estado = ?',
      whereArgs: [id, 1],
    );
    return result.isNotEmpty;
  }

  Future<bool> existsAreaComun(int id) async {
    final Database db = await initDB();
    var result = await db.query(
      'areacomun',
      where: 'idAreaComun = ? AND estado = ?',
      whereArgs: [id, 1],
    );
    return result.isNotEmpty;
  }
  
  //CRUD
  //------------------- CREATE -------------------//
  Future<int> createPropiedad(PropiedadModel propiedad) async {
    final Database db = await initDB();
    return db.insert('propiedad', propiedad.toMap());
  }

  Future<int> createAreaComun(AreaComunModel areacomun) async {
    final Database db = await initDB();
    return db.insert('areacomun', areacomun.toMap());
  }

  Future<int> createVehiculo(VehiculoModel vehiculo) async {
    final Database db = await initDB();
    return db.insert('vehiculo', vehiculo.toMap());
  }

  Future<int> createResidente(ResidenteModel residente) async {
    final Database db = await initDB();
    return db.insert('residente', residente.toMap());
  }

  Future<int> createUsuario(UsuarioModel usuario) async {
    final Database db = await initDB();
    return db.insert('usuario', usuario.toMap());
  }

  Future<int> createVisita(VisitaModel visita) async {
    final Database db = await initDB();
    return db.insert('visita', visita.toMap());
  }

  Future<int> createReserva(ReservaModel reserva) async {
    final Database db = await initDB();

    // Verificar si existen el residente y el área común
    if (await existsResidente(reserva.idResidente) && await existsAreaComun(reserva.idAreaComun)) {
      
      // Insertar la reserva en la tabla "reserva"
      return await db.insert('reserva', {
        'idResidente': reserva.idResidente,
        'idAreaComun': reserva.idAreaComun,
        'fechaHora_inicio': reserva.fechaHoraInicio,
        'fechaHora_final': reserva.fechaHoraFinal,
        'isAceptado': 'Pendiente', // valor por defecto al crear //reserva.isAceptado ?? 'Pendiente',
      });
    } else {
      throw Exception('Residente o Área Común no existen');
    }
  }

  //------------------- READ - GET -------------------//
  Future<List<PropiedadModel>> getPropiedades() async { //READ - Muestra todos los registros
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('propiedad');
    return result.map((e) => PropiedadModel.fromMap(e)).toList();
  }

  Future<List<PropiedadModel>> getPropiedadesActivas() async { //READ - Muestra registros con estado = 1
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query(
      'propiedad',
      where: 'estado = ?',
      whereArgs: [1],
    );
    return result.map((e) => PropiedadModel.fromMap(e)).toList();
  }

  Future<List<AreaComunModel>> getAreasComunes() async { //READ - Muestra todos los registros
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('areacomun');
    return result.map((e) => AreaComunModel.fromMap(e)).toList();
  }

  Future<List<AreaComunModel>> getAreasComunesActivas() async { //READ - Muestra registros con estado = 1
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query(
      'areacomun',
      where: 'estado = ?',
      whereArgs: [1]
    );
    return result.map((e) => AreaComunModel.fromMap(e)).toList();
  }

  Future<List<VehiculoModel>> getVehiculos() async { //READ - Muestra todos los registros
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('vehiculo');
    return result.map((e) => VehiculoModel.fromMap(e)).toList(); 
  }

  Future<List<VehiculoModel>> getVehiculosActivos() async { // READ - Muestra registros con estado = 1
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query(
      'vehiculo',
      where: 'estado = ?',
      whereArgs: [1]
    );
    return result.map((e) => VehiculoModel.fromMap(e)).toList();
  }

  Future<List<ResidenteModel>> getResidentes() async { //READ - Muestra todos los registros
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('residente');
    return result.map((e) => ResidenteModel.fromMap(e)).toList();
  }

  Future<List<ResidenteModel>> getResidentesActivos() async { //READ - Muestra registros con estado = 1
    final Database db = await initDB();
    List<Map<String,Object?>> result = await db.query(
      'residente',
      where: 'estado = ?',
      whereArgs: [1]
    );
    return result.map((e) => ResidenteModel.fromMap(e)).toList();
  }

  Future<List<UsuarioModel>> getUsuarios() async { //READ - Muestra todos los registros
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('usuario');
    return result.map((e) => UsuarioModel.fromMap(e)).toList();
  }

  Future<List<UsuarioModel>> getUsuariosActivos() async { //READ - Muestra los registros con estado = 1
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query(
      'usuario',
      where: 'estado = ?',
      whereArgs: [1]
    );
    return result.map((e) => UsuarioModel.fromMap(e)).toList();
  }

  Future<List<VisitaModel>> getVisitas() async { //READ - Muestra todos los registros
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('visita');
    return result.map((e) => VisitaModel.fromMap(e)).toList();
  }

  Future<List<VisitaModel>> getVisitasActivas() async { //READ - Muestra los registros con estado = 1
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query(
      'visita',
      where: 'estado = ?',
      whereArgs: [1]
    );
    return result.map((e) => VisitaModel.fromMap(e)).toList();
  }

//   Future<List<Map<String, dynamic>>> getReservas(int idReserva) async {
//     final Database db = await initDB();

//     return await db.rawQuery('''
//       SELECT 
//         r.idReserva, 
//         r.fechaHora_inicio, 
//         r.fechaHora_final, 
//         r.isAceptado, 
//         res.nombreResidente, 
//         res.aPaternoResidente, 
//         res.aMaternoResidente, 
//         ac.nombreAreaComun, 
//         ac.precioAreaComun
//       FROM reserva r
//       JOIN residente res ON r.idResidente = res.idResidente
//       JOIN areaComun ac ON r.idAreaComun = ac.idAreaComun
//       WHERE r.idReserva = ?
//     ''', [idReserva]);
// }


  Future<List<ReservaModel>> getReservas() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT  r.idReserva, 
              r.idResidente, 
              res.nombre AS nombreResidente, 
              res.aPaterno AS aPaternoResidente, 
              res.aMaterno AS aMaternoResidente,
              r.idAreaComun, 
              ac.nombre AS nombreAreaComun, 
              ac.costoAlquiler AS precioAreaComun,
              r.fechaHora_inicio AS fechaHoraInicio, 
              r.fechaHora_final AS fechaHoraFinal, 
              r.isAceptado
            FROM reserva r
            JOIN residente res ON r.idResidente = res.idResidente
            JOIN areacomun ac ON r.idAreaComun = ac.idAreaComun
        ''');

      return List.generate(maps.length, (i) {
        return ReservaModel(
          idReserva: maps[i]['idReserva'],
          idResidente: maps[i]['idResidente'],
          nombreResidente: maps[i]['nombreResidente'],
          aPaternoResidente: maps[i]['aPaternoResidente'],
          aMaternoResidente: maps[i]['aMaternoResidente'],
          idAreaComun: maps[i]['idAreaComun'],
          nombreAreaComun: maps[i]['nombreAreaComun'],
          alquilerAreaComun: maps[i]['precioAreaComun'],
          fechaHoraInicio: maps[i]['fechaHoraInicio'],
          fechaHoraFinal: maps[i]['fechaHoraFinal'],
          isAceptado: maps[i]['isAceptado'],
        );
      });
  }

  // READ - Obtener las reservas hechas por Residente 
  Future<List<ReservaModel>> getReservasByResidente(int idResidente) async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query(
      'reserva',
      where: 'idResidente = ?',
      whereArgs: [idResidente]
    );
    return result.map((e) => ReservaModel.fromMap(e)).toList();
  }

  // Read - Obtener las reservas por nombre de área común
  Future<List<ReservaModel>> getReservasByAreaComun(int idAreaComun) async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query(
      'reserva',
      where: 'idAreaComun = ?',
      whereArgs: [idAreaComun]
    );
    return result.map((e) => ReservaModel.fromMap(e)).toList();
  }
  
  //------------------- UPDATE -------------------//
  Future<int> updatePropiedad(nroPiso, nroDpto, idPropiedad) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'UPDATE propiedad SET nroPiso = ?, nroDpto = ?, fecha_edit = CURRENT_TIMESTAMP WHERE idPropiedad = ?',
      [nroPiso, nroDpto, idPropiedad]);
  }

  Future<int> updateAreaComun(nombre, costoAlquiler, idAreaComun) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'UPDATE areacomun SET nombre = ?, costoAlquiler = ?, fecha_edit = CURRENT_TIMESTAMP WHERE idAreaComun = ?',
      [nombre, costoAlquiler, idAreaComun]
    );
  }
                                    
  Future<int> updateVehiculo(tipo, marca, color, idVehiculo) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'UPDATE vehiculo SET tipo = ?, marca = ?, color = ?, fecha_edit = CURRENT_TIMESTAMP WHERE idVehiculo = ?',
      [tipo, marca, color, idVehiculo]
    );
  }
                              
  Future<int> updateResidente(password, nombre, aPaterno, aMaterno, fechaNacimiento, telefono, email, genero, idResidente) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'UPDATE residente SET password = ?, nombre = ?, aPaterno = ?, aMaterno = ?, fechaNacimiento = ?, telefono = ?, email = ?, genero = ? WHERE idResidente = ?',
      [password, nombre, aPaterno, aMaterno, fechaNacimiento, telefono, email, genero, idResidente]
    );
  }

  Future<int> updateUsuario(password, nombre, aPaterno, aMaterno, tipo, telefono, genero, idUsuario) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'UPDATE usuario SET password = ?, nombre = ?, aPaterno = ?, aMaterno = ?, tipo = ?, telefono = ?, genero = ? WHERE idUsuario = ?',
      [password, nombre, aPaterno, aMaterno, tipo, telefono, genero, idUsuario]
    );
  }

  Future<int> updateVisita(nombre, aPaterno, aMaterno, genero, idVisita) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'UPDATE visita SET nombre = ?, aPaterno = ?, aMaterno = ?, genero = ? WHERE idVisita = ?',
      [nombre, aPaterno, aMaterno, genero, idVisita]
    );
  }
  
  Future<int> updateReserva(fechaHoraInicio, fechaHoraFinal, idReserva) async {
    final Database db = await initDB();
    return db.rawUpdate(
      'UPDATE reserva SET fechaHora_inicio = ?, fechaHora_final = ? WHERE idReserva = ?',
      [fechaHoraInicio, fechaHoraFinal, idReserva]
    );
  }

  //------------------- DELETE -------------------//
  Future<int> deletePropiedad(int id) async { //Delete Físico
    final Database db = await initDB();
    return db.delete('propiedad', where: 'idPropiedad = ?', whereArgs: [id]);
  }

  Future<int> deleteLogicoPropiedad(int id) async { //Delete Lógico
    final Database db = await initDB();
    return db.update(
      'propiedad',
      {'estado': 0},
      where: 'idPropiedad = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAreaComun(int id) async { //Delete Físico
    final Database db = await initDB();
    return db.delete('areacomun', where: 'idAreaComun = ?', whereArgs: [id]);
  }

  Future<int> deleteLogicoAreaComun(int id) async { //Delete Lógico
    final Database db = await initDB();
    return db.update(
      'areacomun', 
      {'estado': 0},
      where: 'idAreaComun = ?',
      whereArgs: [id]
    );
  }

  Future<int> deleteVehiculo(String id) async { //Delete Físico
    final Database db = await initDB();
    return db.delete('vehiculo', where: 'idVehiculo = ?', whereArgs: [id]);
  }

  Future<int> deleteLogicoVehiculo(String id) async { //Delete Lógico
    final Database db = await initDB();
    return db.update(
      'vehiculo',
      {'estado': 0}, 
      where: 'idVehiculo = ?',
      whereArgs: [id]
    );
  }

  Future<int> deleteResidente(String id) async { //Delete Físico
    final Database db = await initDB();
    return db.delete('residente', where: 'idResidente = ?', whereArgs: [id]);
  }
  
  Future<int> deleteLogicoResidente(String id) async { //Delete Lógico
    final Database db = await initDB();
    return db.update(
      'residente',
      {'estado': 0}, 
      where: 'idResidente = ?',
      whereArgs: [id]
    );
  }

  Future<int> deleteUsuario(String id) async { //Delete Físico
    final Database db = await initDB();
    return db.delete('usuario', where: 'idUsuario = ?', whereArgs: [id]);
  }

  Future<int> deleteLogicoUsuario(String id) async { //Delete Lógico
    final Database db = await initDB();
    return db.update(
      'usuario', 
      {'estado': 0},
      where: 'idUsuario = ?',
      whereArgs: [id]
    );
  }

  Future<int> deleteVisita(String id) async { //Delete Físico
    final Database db = await initDB();
    return db.delete('visita', where: 'idVisita = ?', whereArgs: [id]);
  }

  Future<int> deleteLogicoVisita(String id) async { //Delete Lógico
    final Database db = await initDB();
    return db.update(
      'visita', 
      {'estado': 0},
      where: 'idVisita = ?',
      whereArgs: [id]
    );
  }

  Future<int> deleteReserva(int id) async {
    final Database db = await initDB();
    return db.delete('reserva', where: 'idReserva = ?', whereArgs: [id]);
  } 

}