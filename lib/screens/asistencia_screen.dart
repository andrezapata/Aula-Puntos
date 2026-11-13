import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class AsistenciaScreen extends StatelessWidget {
  final AppStateNotifier state;
  final VoidCallback onBackToSesiones;

  const AsistenciaScreen({
    super.key,
    required this.state,
    required this.onBackToSesiones,
  });

  @override
  Widget build(BuildContext context) {
    final ses = state.currentSesion;
    int countP = 0, countT = 0, countF = 0, countJ = 0;

    for (var est in state.estudiantes) {
      final st = state.getAsistencia(est.estudianteId);
      switch (st) {
        case EstadoAsistencia.presente: countP++; break;
        case EstadoAsistencia.tardanza: countT++; break;
        case EstadoAsistencia.falta: countF++; break;
        case EstadoAsistencia.justificado: countJ++; break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackToSesiones,
        ),
        title: Text(
          ses != null ? 'Asistencia: Sesión ${ses.numero} - ${ses.tema}' : 'Control de Asistencia',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Confirmar Asistencia',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✓ Asistencia guardada localmente')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra superior de contadores
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
            ),
            child: Row(
              children: [
                _buildCounterItem('Presentes', countP, AppTheme.statusPresente),
                _buildDivider(),
                _buildCounterItem('Tardanzas', countT, AppTheme.statusTardanza),
                _buildDivider(),
                _buildCounterItem('Faltas', countF, AppTheme.statusFalta),
                _buildDivider(),
                _buildCounterItem('Justif.', countJ, AppTheme.statusJustificado),
              ],
            ),
          ),

          // Herramienta rápida: Marcar todos Presente
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.check_circle_outline, size: 16, color: AppTheme.statusPresente),
                  label: const Text('Marcar todos Presente', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppTheme.statusPresente)),
                  backgroundColor: AppTheme.statusPresenteBg,
                  side: const BorderSide(color: Color(0xFF86EFAC)),
                  onPressed: state.markAllPresent,
                ),
                Text(
                  '${state.estudiantes.length} Alumnos',
                  style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Lista de Estudiantes
          Expanded(
            child: state.estudiantes.isEmpty
                ? const Center(child: Text('No hay estudiantes registrados'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: state.estudiantes.length,
                    itemBuilder: (context, index) {
                      final est = state.estudiantes[index];
                      final currentStatus = state.getAsistencia(est.estudianteId);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppTheme.senatiNavy,
                              child: Text(
                                est.inicial,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    est.nombreCompleto,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Código: ${est.codigoInstitucional}',
                                    style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, fontFamily: 'monospace'),
                                  ),
                                ],
                              ),
                            ),
                            // Segmented pills P | T | F | J
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildPill(
                                  label: 'P',
                                  isActive: currentStatus == EstadoAsistencia.presente,
                                  activeColor: AppTheme.statusPresente,
                                  onTap: () => state.setAsistencia(est.estudianteId, EstadoAsistencia.presente),
                                ),
                                const SizedBox(width: 4),
                                _buildPill(
                                  label: 'T',
                                  isActive: currentStatus == EstadoAsistencia.tardanza,
                                  activeColor: AppTheme.statusTardanza,
                                  onTap: () => state.setAsistencia(est.estudianteId, EstadoAsistencia.tardanza),
                                ),
                                const SizedBox(width: 4),
                                _buildPill(
                                  label: 'F',
                                  isActive: currentStatus == EstadoAsistencia.falta,
                                  activeColor: AppTheme.statusFalta,
                                  onTap: () => state.setAsistencia(est.estudianteId, EstadoAsistencia.falta),
                                ),
                                const SizedBox(width: 4),
                                _buildPill(
                                  label: 'J',
                                  isActive: currentStatus == EstadoAsistencia.justificado,
                                  activeColor: AppTheme.statusJustificado,
                                  onTap: () => state.setAsistencia(est.estudianteId, EstadoAsistencia.justificado),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterItem(String label, int count, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 24,
      color: const Color(0xFFE2E8F0),
    );
  }

  Widget _buildPill({
    required String label,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? activeColor : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive ? activeColor : const Color(0xFFCBD5E1),
            width: 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

