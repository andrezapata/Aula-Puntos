import 'dart:convert';
import 'dart:typed_data';
import '../models/models.dart';

class SenatiCsvGenerator {
  static Uint8List generateCsv({
    required Grupo grupo,
    required List<Estudiante> estudiantes,
    required Map<String, int> puntos,
    required Map<String, EstadoAsistencia> asistencias,
    required String sesionId,
  }) {
    final buffer = StringBuffer();
    // UTF-8 BOM para que Microsoft Excel lo abra con acentos perfectos
    buffer.write('\uFEFF');

    buffer.writeln('SENATI - REPORTE CONSOLIDADO AULA PUNTOS');
    buffer.writeln('Grupo:;${grupo.nombre}');
    buffer.writeln('Programa:;${grupo.programa}');
    buffer.writeln('Asignatura:;${grupo.asignatura}');
    buffer.writeln('Periodo:;${grupo.periodo}');
    buffer.writeln('Seccion:;${grupo.seccion}');
    buffer.writeln('Fecha de Generacion:;${DateTime.now().toLocal().toString().split(' ')[0]}');
    buffer.writeln('');

    buffer.writeln('N°;Estudiante;Código SENATI;Estado Asistencia;Total Puntos Participación');

    for (int i = 0; i < estudiantes.length; i++) {
      final est = estudiantes[i];
      final pts = puntos['${sesionId}_${est.estudianteId}'] ?? 0;
      final att = asistencias['${sesionId}_${est.estudianteId}'] ?? EstadoAsistencia.presente;
      String estadoStr = 'Presente';
      switch (att) {
        case EstadoAsistencia.presente: estadoStr = 'Presente'; break;
        case EstadoAsistencia.tardanza: estadoStr = 'Tardanza'; break;
        case EstadoAsistencia.falta: estadoStr = 'Falta'; break;
        case EstadoAsistencia.justificado: estadoStr = 'Justificado'; break;
      }
      buffer.writeln('${i + 1};"${est.nombreCompleto}";"${est.codigoInstitucional}";$estadoStr;$pts');
    }

    return Uint8List.fromList(utf8.encode(buffer.toString()));
  }

  static String generateWhatsAppText({
    required Grupo grupo,
    required Sesion? sesion,
    required List<Estudiante> estudiantes,
    required Map<String, int> puntos,
    required String sesionId,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('*SENATI - AULA PUNTOS*');
    buffer.writeln('*Grupo:* ${grupo.nombre} | *Asignatura:* ${grupo.asignatura}');
    buffer.writeln('*Sesión:* N° ${sesion?.numero ?? 1} - ${sesion?.tema ?? "FORMACION DUAL"}');
    buffer.writeln('*Fecha:* ${DateTime.now().toLocal().toString().split(' ')[0]}');
    buffer.writeln('');
    buffer.writeln('*RESUMEN DE PARTICIPACIÓN:*\n');

    final topStudents = estudiantes.take(8).toList();
    for (final est in topStudents) {
      final pts = puntos['${sesionId}_${est.estudianteId}'] ?? 0;
      final cleanName = est.nombreCompleto.split(',')[0];
      buffer.writeln('• $cleanName (${est.codigoInstitucional}): $pts pts');
    }

    if (estudiantes.length > 8) {
      buffer.writeln('... y ${estudiantes.length - 8} alumnos más.');
    }

    buffer.writeln('\n_Instructor Luque Chambi Jorge - Escuela de TI SENATI_');
    return buffer.toString();
  }
}

