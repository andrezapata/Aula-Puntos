library;

/// Modelos de Datos para AULA PUNTOS - SENATI
/// Entidades principales especificadas en la Sección 9 del Caso Práctico:
/// Instructor, Grupo, Estudiante, Sesion, Asistencia, Participacion.

enum EstadoAsistencia { presente, tardanza, falta, justificado }

class Instructor {
  final String instructorId;
  final String nombres;
  final String apellidos;
  final String correo;
  final String sede;

  const Instructor({
    required this.instructorId,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.sede,
  });

  String get nombreCompleto => '$apellidos, $nombres';
}

class Grupo {
  final String grupoId;
  final String codigo;
  final String nombre;
  final String programa;
  final String asignatura;
  final String periodo;
  final String seccion;
  final String instructorId;

  Grupo({
    required this.grupoId,
    required this.codigo,
    required this.nombre,
    required this.programa,
    required this.asignatura,
    required this.periodo,
    required this.seccion,
    required this.instructorId,
  });

  Map<String, dynamic> toMap() => {
    'grupoId': grupoId,
    'codigo': codigo,
    'nombre': nombre,
    'programa': programa,
    'asignatura': asignatura,
    'periodo': periodo,
    'seccion': seccion,
    'instructorId': instructorId,
  };
}

class Estudiante {
  final String estudianteId;
  final String codigoInstitucional;
  final String nombres;
  final String apellidos;

  const Estudiante({
    required this.estudianteId,
    required this.codigoInstitucional,
    required this.nombres,
    required this.apellidos,
  });

  String get nombreCompleto => '$apellidos, $nombres';
  String get inicial => apellidos.isNotEmpty ? apellidos[0].toUpperCase() : 'E';
}

class Sesion {
  final String sesionId;
  final String grupoId;
  final int numero;
  final String tema;
  final String tipo;
  final String fecha;
  final int duracionHoras;
  final String observaciones;

  Sesion({
    required this.sesionId,
    required this.grupoId,
    required this.numero,
    required this.tema,
    required this.tipo,
    required this.fecha,
    required this.duracionHoras,
    this.observaciones = '',
  });

  Map<String, dynamic> toMap() => {
    'sesionId': sesionId,
    'grupoId': grupoId,
    'numero': numero,
    'tema': tema,
    'tipo': tipo,
    'fecha': fecha,
    'duracionHoras': duracionHoras,
    'observaciones': observaciones,
  };
}

class AsistenciaRegistro {
  final String sesionId;
  final String estudianteId;
  EstadoAsistencia estado;
  final DateTime fechaRegistro;

  AsistenciaRegistro({
    required this.sesionId,
    required this.estudianteId,
    this.estado = EstadoAsistencia.presente,
    required this.fechaRegistro,
  });
}

class ParticipacionRegistro {
  final String sesionId;
  final String estudianteId;
  final String actividad;
  final int puntos;
  final DateTime fecha;

  ParticipacionRegistro({
    required this.sesionId,
    required this.estudianteId,
    required this.actividad,
    required this.puntos,
    required this.fecha,
  });
}

class SyncOperation {
  final String id;
  final String tipo;
  final String descripcion;
  final DateTime timestamp;

  SyncOperation({
    required this.id,
    required this.tipo,
    required this.descripcion,
    required this.timestamp,
  });
}
