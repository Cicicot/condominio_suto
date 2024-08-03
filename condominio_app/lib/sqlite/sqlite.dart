import 'package:condominio_app/jsonmodels/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  final databaseName = "cond.db";

  String propiedadTable = "CREATE TABLE propiedad(idPropiedad INTEGER PRIMARY KEY AUTOINCREMENT, nroPiso TEXT NOT NULL, nroDpto TEXT NOT NULL, estado TEXT NOT NULL, fecha_alta TEXT DEFAULT CURRENT_TIMESTAMP, fecha_edit TEXT DEFAULT CURRENT_TIMESTAMP)";
  String areacomunTable = "CREATE TABLE areacomun(idAreaComun INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL, costoAlquiler REAL, estado TEXT NOT NULL, fecha_alta TEXT DEFAULT CURRENT_TIMESTAMP, fecha_edit TEXT DEFAULT CURRENT_TIMESTAMP)";
  String vehiculoTable = "CREATE TABLE vehiculo(idVehiculo TEXT UNIQUE PRIMARY KEY NOT NULL, tipo TEXT NOT NULL, marca TEXT NOT NULL, color TEXT NOT NULL, estado TEXT NOT NULL, fecha_alta TEXT DEFAULT CURRENT_TIMESTAMP, fecha_edit TEXT DEFAULT CURRENT_TIMESTAMP)";
  String residenteTable = "CREATE TABLE residente(idResidente TEXT UNIQUE PRIMARY KEY NOT NULL, password TEXT NOT NULL, nombre TEXT NOT NULL, aPaterno TEXT NOT NULL, aMaterno TEXT NOT NULL, fechaNacimiento TEXT NOT NULL, telefono TEXT NOT NULL, email TEXT NOT NULL, genero TEXT NOT NULL, estado TEXT NOT NULL, fecha_alta TEXT DEFAULT CURRENT_TIMESTAMP, fecha_edit TEXT DEFAULT CURRENT_TIMESTAMP)";                                                  

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(areacomunTable);
      await db.execute(propiedadTable);
      await db.execute(vehiculoTable);
      await db.execute(residenteTable);
    });
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

  //------------------- REAG - GET -------------------//
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

  Future<List<ResidenteModel>> getResidentesActivos() async {
    final Database db = await initDB();
    List<Map<String,Object?>> result = await db.query(
      'residente',
      where: 'estado = ?',
      whereArgs: [1]
    );
    return result.map((e) => ResidenteModel.fromMap(e)).toList();
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
      'UPDATE residente SET password = ?, nombre = ?, aPaterno = ?, aMaterno = ?, fechaNacimiento = ?, telefono = ?, email = ?, genero = ?',
      [password, nombre, aPaterno, aMaterno, fechaNacimiento, telefono, email, genero, idResidente]
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

}