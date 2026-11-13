import 'dart:convert';
import 'dart:typed_data';
import '../models/models.dart';

class SenatiPdfGenerator {
  static Uint8List generateAcademicReport({
    required Grupo grupo,
    required List<Estudiante> estudiantes,
    required Map<String, int> puntos,
    required String sesionId,
  }) {
    final buffer = StringBuffer();
    final objects = <int>[];

    void write(String s) => buffer.write(s);
    int currentOffset() => utf8.encode(buffer.toString()).length;

    // Header PDF
    write('%PDF-1.4\n%\n');

    // Object 1: Catalog
    objects.add(currentOffset());
    write('1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n');

    // Object 2: Pages
    objects.add(currentOffset());
    write('2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n');

    // Build Content Stream
    final streamContent = StringBuffer();

    // Background and Header Bar (SENATI Blue #003876 -> 0.0, 0.22, 0.46)
    streamContent.write('0.0 0.22 0.46 rg\n');
    streamContent.write('40 760 515 35 re f\n'); // top banner bar

    // Title in White
    streamContent.write('1.0 1.0 1.0 rg\n');
    streamContent.write('BT /F2 16 Tf 55 773 Td (SENATI - AULA PUNTOS) Tj ET\n');

    // Subtitle & Group Info in Dark Slate (0.06, 0.09, 0.16)
    streamContent.write('0.06 0.09 0.16 rg\n');
    streamContent.write('BT /F2 11 Tf 40 735 Td (Grupo: ${grupo.nombre}  |  Programa: ${grupo.programa}  |  Periodo: ${grupo.periodo}) Tj ET\n');
    streamContent.write('BT /F1 10 Tf 40 720 Td (Asignatura: ${grupo.asignatura}  |  Seccion: ${grupo.seccion}) Tj ET\n');

    // Section title
    streamContent.write('0.0 0.22 0.46 rg\n');
    streamContent.write('BT /F2 12 Tf 40 690 Td (Reporte Consolidado de Calificaciones y Participacion) Tj ET\n');

    // Table Header Box (Light Gray #F1F5F9 -> 0.94, 0.96, 0.97)
    streamContent.write('0.94 0.96 0.97 rg\n');
    streamContent.write('40 660 515 20 re f\n');

    // Table Border
    streamContent.write('0.75 0.8 0.85 RG\n1.0 w\n');
    streamContent.write('40 660 515 20 re S\n');

    // Header Texts
    streamContent.write('0.0 0.17 0.29 rg\n'); // Navy
    streamContent.write('BT /F2 10 Tf 50 666 Td (Estudiante) Tj ET\n');
    streamContent.write('BT /F2 10 Tf 340 666 Td (Codigo) Tj ET\n');
    streamContent.write('BT /F2 10 Tf 460 666 Td (Total Pts) Tj ET\n');

    // Student Rows
    double y = 638;
    for (int i = 0; i < estudiantes.length; i++) {
      final est = estudiantes[i];
      final pts = puntos['${sesionId}_${est.estudianteId}'] ?? 0;

      // Alternating row background
      if (i % 2 == 1) {
        streamContent.write('0.97 0.98 0.99 rg\n');
        streamContent.write('40 ${y - 4} 515 18 re f\n');
      }

      // Row Border bottom
      streamContent.write('0.88 0.91 0.94 RG\n0.5 w\n');
      streamContent.write('40 ${y - 4} m 555 ${y - 4} l S\n');

      // Student name (truncate if too long)
      String cleanName = est.nombreCompleto
          .replaceAll('Á', 'A').replaceAll('É', 'E').replaceAll('Í', 'I').replaceAll('Ó', 'O').replaceAll('Ú', 'U')
          .replaceAll('Ñ', 'N');
      if (cleanName.length > 38) cleanName = '${cleanName.substring(0, 36)}...';

      streamContent.write('0.06 0.09 0.16 rg\n');
      streamContent.write('BT /F1 9 Tf 50 $y Td ($cleanName) Tj ET\n');
      streamContent.write('BT /F1 9 Tf 340 $y Td (${est.codigoInstitucional}) Tj ET\n');

      // Points bold navy
      streamContent.write('0.0 0.22 0.46 rg\n');
      streamContent.write('BT /F2 9.5 Tf 475 $y Td ($pts pts) Tj ET\n');

      y -= 20;
    }

    // Outer table border
    double tableHeight = (estudiantes.length * 20.0) + 20.0;
    streamContent.write('0.75 0.8 0.85 RG\n1.0 w\n');
    streamContent.write('40 ${680 - tableHeight} 515 $tableHeight re S\n');

    // Signatures at bottom
    streamContent.write('0.58 0.64 0.72 RG\n0.8 w\n');
    streamContent.write('70 120 m 230 120 l S\n'); // Line 1
    streamContent.write('365 120 m 525 120 l S\n'); // Line 2

    streamContent.write('0.0 0.17 0.29 rg\n');
    streamContent.write('BT /F2 9 Tf 85 106 Td (Instructor Luque Chambi Jorge) Tj ET\n');
    streamContent.write('0.4 0.45 0.5 rg\n');
    streamContent.write('BT /F1 8 Tf 82 94 Td (Escuela de Tecnologias de la Informacion) Tj ET\n');

    streamContent.write('0.0 0.17 0.29 rg\n');
    streamContent.write('BT /F2 9 Tf 390 106 Td (Jefatura Academica SENATI) Tj ET\n');
    streamContent.write('0.4 0.45 0.5 rg\n');
    streamContent.write('BT /F1 8 Tf 398 94 Td (Control y Trazabilidad Dual) Tj ET\n');

    // Footer note
    streamContent.write('BT /F1 7.5 Tf 40 50 Td (Generado desde AULA PUNTOS - SENATI | Sistema de Apoyo al Instructor) Tj ET\n');

    final streamBytes = utf8.encode(streamContent.toString());

    // Object 4: Content Stream
    objects.add(currentOffset());
    write('4 0 obj\n<< /Length ${streamBytes.length} >>\nstream\n');
    write(streamContent.toString());
    write('\nendstream\nendobj\n');

    // Object 5: Font Regular (Helvetica)
    objects.add(currentOffset());
    write('5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n');

    // Object 6: Font Bold (Helvetica-Bold)
    objects.add(currentOffset());
    write('6 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >>\nendobj\n');

    // Object 3: Page
    objects.add(currentOffset());
    write('3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595.28 841.89] /Contents 4 0 R /Resources << /Font << /F1 5 0 R /F2 6 0 R >> >> >>\nendobj\n');

    // Cross-reference table (xref)
    final xrefOffset = currentOffset();
    write('xref\n0 ${objects.length + 1}\n');
    write('0000000000 65535 f \n');
    for (final offset in objects) {
      write('${offset.toString().padLeft(10, '0')} 00000 n \n');
    }

    // Trailer
    write('trailer\n<< /Size ${objects.length + 1} /Root 1 0 R >>\n');
    write('startxref\n$xrefOffset\n%%EOF\n');

    return Uint8List.fromList(utf8.encode(buffer.toString()));
  }
}

