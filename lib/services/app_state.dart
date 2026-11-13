import 'package:flutter/material.dart';
import '../models/models.dart';

class AppStateNotifier extends ChangeNotifier {
  bool _isOnline = false;
  String? _selectedGrupoId;
  String? _selectedSesionId;
  String _currentActividad = 'Participación en clase';

  final List<Grupo> _grupos = [];
  final List<Sesion> _sesiones = [];
  final List<Estudiante> _estudiantes = [];
  final Map<String, EstadoAsistencia> _asistencias = {};
  final Map<String, int> _puntos = {};
  final List<SyncOperation> _syncQueue = [];

  AppStateNotifier() {
    loadPdfDefaults();
  }

  // Getters
  bool get isOnline => _isOnline;
  String? get selectedGrupoId => _selectedGrupoId;
  String? get selectedSesionId => _selectedSesionId;
  String get currentActividad => _currentActividad;

  List<Grupo> get grupos => List.unmodifiable(_grupos);
  List<Sesion> get sesiones => List.unmodifiable(_sesiones);
  List<Estudiante> get estudiantes => List.unmodifiable(_estudiantes);
  List<SyncOperation> get syncQueue => List.unmodifiable(_syncQueue);

  Grupo? get currentGrupo => _grupos.cast<Grupo?>().firstWhere(
        (g) => g?.grupoId == _selectedGrupoId,
        orElse: () => _grupos.isNotEmpty ? _grupos.first : null,
      );

  Sesion? get currentSesion => _sesiones.cast<Sesion?>().firstWhere(
        (s) => s?.sesionId == _selectedSesionId,
        orElse: () => _sesiones.isNotEmpty ? _sesiones.first : null,
      );

  // Setters
  void setSelectedGrupo(String grupoId) {
    _selectedGrupoId = grupoId;
    notifyListeners();
  }

  void setSelectedSesion(String sesionId) {
    _selectedSesionId = sesionId;
    notifyListeners();
  }

  void setCurrentActividad(String actividad) {
    _currentActividad = actividad;
    notifyListeners();
  }

  void toggleOnline() {
    _isOnline = !_isOnline;
    notifyListeners();
  }

  // Cargar datos demo idénticos al PDF (Páginas 4, 5, 6 y 7)
  void loadPdfDefaults() {
    _grupos.clear();
    _sesiones.clear();
    _estudiantes.clear();
    _asistencias.clear();
    _puntos.clear();
    _syncQueue.clear();

    // 1. Grupo del PDF
    final g1 = Grupo(
      grupoId: 'grp_202601',
      codigo: '202601',
      nombre: '202601',
      programa: '2026-20',
      asignatura: 'FORMACION MONITORES EMPRESA',
      periodo: '2026-20',
      seccion: '2026-20-202601',
      instructorId: 'inst_luque',
    );
    _grupos.add(g1);
    _selectedGrupoId = g1.grupoId;

    // 2. Sesión del PDF
    final s1 = Sesion(
      sesionId: 'ses_1',
      grupoId: g1.grupoId,
      numero: 1,
      tema: 'FORMACION DUAL SENATI',
      tipo: 'Teoría (Tecnología)',
      fecha: '2026-11-13',
      duracionHoras: 4,
      observaciones: 'CLASE 01',
    );
    _sesiones.add(s1);
    _selectedSesionId = s1.sesionId;

    // 3. Estudiantes del PDF (Captura Página 6)
    final listaEst = [
      const Estudiante(estudianteId: 'e1', codigoInstitucional: '001507084', nombres: 'JULIANA FRANCESCA', apellidos: 'CABALLERO HUANAQUIRI'),
      const Estudiante(estudianteId: 'e2', codigoInstitucional: '001607280', nombres: 'CHRISTIAN ANGEL', apellidos: 'CAMPOMANES CAPRISTANO'),
      const Estudiante(estudianteId: 'e3', codigoInstitucional: '001591227', nombres: 'JULIO BRANDO', apellidos: 'CASTROMONTE'),
      const Estudiante(estudianteId: 'e4', codigoInstitucional: '001286163', nombres: 'PAOLO CESAR', apellidos: 'HANCCO HUARHUACHI'),
      const Estudiante(estudianteId: 'e5', codigoInstitucional: '001556472', nombres: 'ARIANNA GUADALUPE', apellidos: 'HUAYTA TINOCO'),
      const Estudiante(estudianteId: 'e6', codigoInstitucional: '001131690', nombres: 'AXEL PAOLO', apellidos: 'MENDO MUÑOZ'),
      const Estudiante(estudianteId: 'e7', codigoInstitucional: '001593789', nombres: 'SALVADOR SANTIAGO', apellidos: 'NUÑEZ HERRERA'),
      const Estudiante(estudianteId: 'e8', codigoInstitucional: '20260101', nombres: 'JUAN', apellidos: 'PÉREZ GÓMEZ'),
      const Estudiante(estudianteId: 'e9', codigoInstitucional: '20260102', nombres: 'MARÍA', apellidos: 'LÓPEZ TORRES'),
      const Estudiante(estudianteId: 'e10', codigoInstitucional: '20260103', nombres: 'CARLOS', apellidos: 'SILVA ROJAS'),
    ];
    _estudiantes.addAll(listaEst);

    // Asistencias iniciales
    _asistencias['${s1.sesionId}_e1'] = EstadoAsistencia.presente;
    _asistencias['${s1.sesionId}_e2'] = EstadoAsistencia.presente;
    _asistencias['${s1.sesionId}_e3'] = EstadoAsistencia.tardanza;
    _asistencias['${s1.sesionId}_e4'] = EstadoAsistencia.presente;
    _asistencias['${s1.sesionId}_e5'] = EstadoAsistencia.presente;
    _asistencias['${s1.sesionId}_e6'] = EstadoAsistencia.falta;
    _asistencias['${s1.sesionId}_e7'] = EstadoAsistencia.justificado;
    _asistencias['${s1.sesionId}_e8'] = EstadoAsistencia.presente;
    _asistencias['${s1.sesionId}_e9'] = EstadoAsistencia.presente;
    _asistencias['${s1.sesionId}_e10'] = EstadoAsistencia.presente;

    // Puntos del consolidado (Página 7)
    _puntos['${s1.sesionId}_e1'] = 5;
    _puntos['${s1.sesionId}_e2'] = 3;
    _puntos['${s1.sesionId}_e3'] = 2;
    _puntos['${s1.sesionId}_e4'] = 4;
    _puntos['${s1.sesionId}_e5'] = 6;
    _puntos['${s1.sesionId}_e6'] = 0;
    _puntos['${s1.sesionId}_e7'] = 1;
    _puntos['${s1.sesionId}_e8'] = 16;
    _puntos['${s1.sesionId}_e9'] = 16;
    _puntos['${s1.sesionId}_e10'] = 9;

    // Cola de sincronización inicial
    _syncQueue.add(SyncOperation(
      id: 'sync_1',
      tipo: 'REGISTRO_ASISTENCIA',
      descripcion: 'Asistencia inicial Sesión 1',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ));
    _syncQueue.add(SyncOperation(
      id: 'sync_2',
      tipo: 'PUNTUACION_PARTICIPACION',
      descripcion: 'Consolidado participaciones',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ));

    notifyListeners();
  }

  // Vaciar datos
  void clearData() {
    _grupos.clear();
    _sesiones.clear();
    _estudiantes.clear();
    _asistencias.clear();
    _puntos.clear();
    _syncQueue.clear();
    _selectedGrupoId = null;
    _selectedSesionId = null;
    notifyListeners();
  }

  // Asistencia
  EstadoAsistencia getAsistencia(String estudianteId) {
    final sesId = _selectedSesionId ?? 'ses_default';
    return _asistencias['${sesId}_$estudianteId'] ?? EstadoAsistencia.presente;
  }

  void setAsistencia(String estudianteId, EstadoAsistencia estado) {
    final sesId = _selectedSesionId ?? 'ses_default';
    _asistencias['${sesId}_$estudianteId'] = estado;
    queueSync('CAMBIO_ASISTENCIA', 'Estudiante $estudianteId -> $estado');
    notifyListeners();
  }

  void markAllPresent() {
    final sesId = _selectedSesionId ?? 'ses_default';
    for (var est in _estudiantes) {
      _asistencias['${sesId}_${est.estudianteId}'] = EstadoAsistencia.presente;
    }
    queueSync('ASISTENCIA_MASIVA', 'Marcados todos como Presente');
    notifyListeners();
  }

  // Puntos
  int getPuntos(String estudianteId) {
    final sesId = _selectedSesionId ?? 'ses_default';
    return _puntos['${sesId}_$estudianteId'] ?? 0;
  }

  void addPuntos(String estudianteId, int cantidad) {
    final sesId = _selectedSesionId ?? 'ses_default';
    final key = '${sesId}_$estudianteId';
    _puntos[key] = (_puntos[key] ?? 0) + cantidad;
    queueSync('AGREGAR_PUNTOS', '+$cantidad pts a $estudianteId ($_currentActividad)');
    notifyListeners();
  }

  // Grupos
  void addGrupo(Grupo g) {
    _grupos.add(g);
    _selectedGrupoId = g.grupoId;
    if (_estudiantes.isEmpty) {
      loadPdfDefaults();
    }
    queueSync('CREAR_GRUPO', 'Grupo ${g.nombre} - ${g.asignatura}');
    notifyListeners();
  }

  // Sesiones
  void addSesion(Sesion s) {
    _sesiones.add(s);
    _selectedSesionId = s.sesionId;
    queueSync('CREAR_SESION', 'Sesión N° ${s.numero}: ${s.tema}');
    notifyListeners();
  }

  // Sync
  void queueSync(String tipo, String descripcion) {
    _syncQueue.insert(0, SyncOperation(
      id: 'sync_${DateTime.now().millisecondsSinceEpoch}',
      tipo: tipo,
      descripcion: descripcion,
      timestamp: DateTime.now(),
    ));
    if (_syncQueue.length > 50) _syncQueue.removeLast();
  }

  void clearSyncQueue() {
    _syncQueue.clear();
    notifyListeners();
  }
}

