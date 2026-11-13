import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/pdf_generator.dart';
import '../utils/csv_generator.dart';
import '../utils/downloader.dart';

class ReportesScreen extends StatelessWidget {
  final AppStateNotifier state;

  const ReportesScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final currentGroup = state.currentGrupo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes y Exportación'),
      ),
      body: currentGroup == null
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No hay grupos registrados para generar reportes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tarjeta Resumen del Grupo
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentGroup.nombre,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.senatiBlue,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Programa: ${currentGroup.programa} | Asignatura: ${currentGroup.asignatura}',
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Periodo: ${currentGroup.periodo} | Sección: ${currentGroup.seccion}',
                          style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red.shade700,
                                  side: BorderSide(color: Colors.red.shade300),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 11),
                                ),
                                icon: const Icon(Icons.picture_as_pdf_outlined, size: 17),
                                label: const Text('Exportar PDF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                onPressed: () => _exportarYDescargarPdf(context),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF15803D),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 11),
                                ),
                                icon: const Icon(Icons.table_chart_outlined, size: 17),
                                label: const Text('Excel / WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                onPressed: () => _exportarExcelYWhatsApp(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Previsualización de la Hoja Oficial SENATI (Página 7)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                          child: Text(
                            'SENATI - AULA PUNTOS',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.senatiNavy),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            'Grupo: ${currentGroup.nombre} | Programa: ${currentGroup.programa}',
                            style: const TextStyle(fontSize: 11.5, color: AppTheme.textSecondary),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Periodo: ${currentGroup.periodo}',
                            style: const TextStyle(fontSize: 11.5, color: AppTheme.textSecondary),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Reporte Consolidado de Calificaciones',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.senatiBlue),
                        ),
                        const SizedBox(height: 8),

                        // Tabla de Estudiantes
                        Table(
                          border: TableBorder.all(color: const Color(0xFFCBD5E1), width: 1),
                          columnWidths: const {
                            0: FlexColumnWidth(2.5),
                            1: FlexColumnWidth(1.5),
                            2: FlexColumnWidth(1.2),
                          },
                          children: [
                            const TableRow(
                              decoration: BoxDecoration(color: Color(0xFFF1F5F9)),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('Estudiante', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.senatiNavy)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('Código', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.senatiNavy)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('Total Pts', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.senatiNavy)),
                                ),
                              ],
                            ),
                            ...state.estudiantes.map((est) {
                              final pts = state.getPuntos(est.estudianteId);
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(est.nombreCompleto, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(est.codigoInstitucional, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10.5, fontFamily: 'monospace')),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text('$pts', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.senatiNavy)),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ACCIÓN 1: EXPORTAR Y DESCARGAR PDF REAL
  void _exportarYDescargarPdf(BuildContext context) {
    final currentGroup = state.currentGrupo;
    if (currentGroup == null) return;

    final sesId = state.selectedSesionId ?? (state.sesiones.isNotEmpty ? state.sesiones.first.sesionId : 'ses_default');

    // 1. Generar bytes del documento PDF oficial
    final pdfBytes = SenatiPdfGenerator.generateAcademicReport(
      grupo: currentGroup,
      estudiantes: state.estudiantes,
      puntos: {
        for (var e in state.estudiantes)
          '${sesId}_${e.estudianteId}': state.getPuntos(e.estudianteId),
      },
      sesionId: sesId,
    );

    // 2. Disparar descarga directa del archivo .pdf en el navegador
    final fileName = 'Reporte_Aula_Puntos_SENATI_${currentGroup.nombre}.pdf';
    downloadFile(pdfBytes, fileName, 'application/pdf');

    // 3. Notificación con confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📄 PDF "$fileName" descargado correctamente en tu equipo.'),
        backgroundColor: AppTheme.senatiNavy,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Imprimir',
          textColor: Colors.white,
          onPressed: triggerPrint,
        ),
      ),
    );
  }

  // ACCIÓN 2: EXPORTAR EXCEL Y ABRIR WHATSAPP
  void _exportarExcelYWhatsApp(BuildContext context) {
    final currentGroup = state.currentGrupo;
    if (currentGroup == null) return;

    final ses = state.currentSesion;
    final sesId = state.selectedSesionId ?? (state.sesiones.isNotEmpty ? state.sesiones.first.sesionId : 'ses_default');

    // 1. Generar y descargar archivo Excel (CSV UTF-8 BOM)
    final csvBytes = SenatiCsvGenerator.generateCsv(
      grupo: currentGroup,
      estudiantes: state.estudiantes,
      puntos: {
        for (var e in state.estudiantes)
          '${sesId}_${e.estudianteId}': state.getPuntos(e.estudianteId),
      },
      asistencias: {
        for (var e in state.estudiantes)
          '${sesId}_${e.estudianteId}': state.getAsistencia(e.estudianteId),
      },
      sesionId: sesId,
    );

    final fileName = 'Reporte_Aula_Puntos_SENATI_${currentGroup.nombre}.csv';
    downloadFile(csvBytes, fileName, 'text/csv');

    // 2. Generar texto de WhatsApp
    final waText = SenatiCsvGenerator.generateWhatsAppText(
      grupo: currentGroup,
      sesion: ses,
      estudiantes: state.estudiantes,
      puntos: {
        for (var e in state.estudiantes)
          '${sesId}_${e.estudianteId}': state.getPuntos(e.estudianteId),
      },
      sesionId: sesId,
    );

    // 3. Mostrar diálogo para enviar o copiar en WhatsApp
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF15803D)),
            SizedBox(width: 8),
            Text('Excel Descargado y WhatsApp', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('✓ Archivo "$fileName" descargado para Microsoft Excel.', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: Color(0xFF15803D))),
            const SizedBox(height: 12),
            const Text('Mensaje formateado para WhatsApp:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Text(
                waText,
                style: const TextStyle(fontSize: 11, fontFamily: 'monospace', height: 1.35),
                maxLines: 7,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF16A34A)),
            icon: const Icon(Icons.send, size: 16),
            label: const Text('Abrir WhatsApp Web'),
            onPressed: () {
              Navigator.pop(ctx);
              openWhatsAppWeb(waText);
            },
          ),
        ],
      ),
    );
  }
}
