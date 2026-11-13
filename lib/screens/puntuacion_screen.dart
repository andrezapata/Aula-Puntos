import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class PuntuacionScreen extends StatelessWidget {
  final AppStateNotifier state;
  final VoidCallback onBackToSesiones;

  const PuntuacionScreen({
    super.key,
    required this.state,
    required this.onBackToSesiones,
  });

  @override
  Widget build(BuildContext context) {
    final ses = state.currentSesion;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackToSesiones,
        ),
        title: Text(
          ses != null ? 'Puntuación: Sesión ${ses.numero} - ${ses.tema}' : 'Puntuación Rápida',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Rúbrica de Puntuación',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Text('Criterios de Puntuación SENATI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.senatiNavy)),
                  content: const Text(
                    '• +1 Punto: Intervención breve o respuesta a pregunta rápida.\n\n'
                    '• +2 Puntos: Resolución de ejercicio técnico o caso práctico en pizarra.\n\n'
                    '• +3 Puntos: Aporte sobresaliente, sustentación o solución óptima de taller dual.',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Entendido'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Selector de Actividad Actual
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
            ),
            child: DropdownButtonFormField<String>(
              initialValue: state.currentActividad,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'Participación en clase', child: Text('Actividad: Participación en clase', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700))),
                DropdownMenuItem(value: 'Resolución de ejercicios', child: Text('Actividad: Resolución de ejercicios', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700))),
                DropdownMenuItem(value: 'Exposición técnica', child: Text('Actividad: Exposición técnica', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700))),
                DropdownMenuItem(value: 'Desempeño en taller dual', child: Text('Actividad: Desempeño en taller dual', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700))),
              ],
              onChanged: (val) {
                if (val != null) state.setCurrentActividad(val);
              },
            ),
          ),

          // Lista de Estudiantes para puntuación
          Expanded(
            child: state.estudiantes.isEmpty
                ? const Center(child: Text('No hay estudiantes registrados'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.estudiantes.length,
                    itemBuilder: (context, index) {
                      final est = state.estudiantes[index];
                      final pts = state.getPuntos(est.estudianteId);

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
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: AppTheme.borderColor),
                                    ),
                                    child: Text(
                                      'Total: $pts pts',
                                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppTheme.senatiNavy),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Botones Rápidos +1 | +2 | +3
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildPtsButton(
                                  label: '+1',
                                  color: AppTheme.pts1,
                                  onTap: () {
                                    state.addPuntos(est.estudianteId, 1);
                                    _showFeedback(context, '+1 pt a ${est.apellidos}');
                                  },
                                ),
                                const SizedBox(width: 5),
                                _buildPtsButton(
                                  label: '+2',
                                  color: AppTheme.pts2,
                                  onTap: () {
                                    state.addPuntos(est.estudianteId, 2);
                                    _showFeedback(context, '+2 pts a ${est.apellidos}');
                                  },
                                ),
                                const SizedBox(width: 5),
                                _buildPtsButton(
                                  label: '+3',
                                  color: AppTheme.pts3,
                                  onTap: () {
                                    state.addPuntos(est.estudianteId, 3);
                                    _showFeedback(context, '+3 pts a ${est.apellidos}');
                                  },
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

  void _showFeedback(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⭐ $msg'),
        duration: const Duration(milliseconds: 1400),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildPtsButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
