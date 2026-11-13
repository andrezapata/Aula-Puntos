import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class SesionesScreen extends StatelessWidget {
  final AppStateNotifier state;
  final VoidCallback onBackToGrupos;
  final Function(String) onOpenAsistencia;
  final Function(String) onOpenPuntuacion;
  final VoidCallback onOpenReportes;

  const SesionesScreen({
    super.key,
    required this.state,
    required this.onBackToGrupos,
    required this.onOpenAsistencia,
    required this.onOpenPuntuacion,
    required this.onOpenReportes,
  });

  @override
  Widget build(BuildContext context) {
    final currentGroup = state.currentGrupo;
    final groupSessions = currentGroup != null
        ? state.sesiones.where((s) => s.grupoId == currentGroup.grupoId).toList()
        : <Sesion>[];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackToGrupos,
        ),
        title: Text(currentGroup != null ? 'Sesiones: ${currentGroup.nombre}' : 'Seleccionar Grupo - Sesiones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.description_outlined),
            tooltip: 'Exportar Reporte',
            onPressed: onOpenReportes,
          ),
        ],
      ),
      body: currentGroup == null
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No hay grupos registrados.\nVaya a la pestaña "Mis Grupos" para crear uno antes de gestionar sesiones.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
                ),
              ),
            )
          : groupSessions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_month_outlined, size: 54, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      const Text(
                        'No hay sesiones registradas para este grupo.\nCrea una sesión para comenzar la clase.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: groupSessions.length,
                  itemBuilder: (context, index) {
                    final ses = groupSessions[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.senatiNavy,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  ses.tipo,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                'Sesión N° ${ses.numero}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            ses.tema,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fecha: ${ses.fecha} | Duración: ${ses.duracionHoras} horas',
                            style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
                          ),
                          if (ses.observaciones.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Obs: ${ses.observaciones}',
                              style: const TextStyle(fontSize: 11.5, color: AppTheme.textSecondary, fontStyle: FontStyle.italic),
                            ),
                          ],
                          const SizedBox(height: 14),
                          const Divider(height: 1, color: Color(0xFFF1F5F9)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.senatiNavy,
                                    side: const BorderSide(color: AppTheme.borderInteractive),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  icon: const Icon(Icons.fact_check_outlined, size: 16),
                                  label: const Text('Asistencia', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                  onPressed: () => onOpenAsistencia(ses.sesionId),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.senatiNavy,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  icon: const Icon(Icons.star_rounded, size: 16),
                                  label: const Text('Puntuación', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                  onPressed: () => onOpenPuntuacion(ses.sesionId),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: currentGroup != null
          ? FloatingActionButton.extended(
              onPressed: () => _mostrarDialogNuevaSesion(context),
              backgroundColor: AppTheme.senatiNavy,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Nueva Sesión', style: TextStyle(fontWeight: FontWeight.w700)),
            )
          : null,
    );
  }

  void _mostrarDialogNuevaSesion(BuildContext context) {
    final nextNum = state.sesiones.where((s) => s.grupoId == state.selectedGrupoId).length + 1;
    final numCtrl = TextEditingController(text: '$nextNum');
    final temaCtrl = TextEditingController(text: 'FORMACION DUAL SENATI');
    final durCtrl = TextEditingController(text: '4');
    final obsCtrl = TextEditingController(text: 'CLASE 01');
    String tipoSeleccionado = 'Teoría (Tecnología)';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Crear Sesión Académica',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.senatiNavy),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: numCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Número de Sesión'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: temaCtrl,
                decoration: const InputDecoration(labelText: 'Tema Desarrollado (ej. Circuitos Electrónicos)'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: tipoSeleccionado,
                decoration: const InputDecoration(labelText: 'Tipo de Sesión'),
                items: const [
                  DropdownMenuItem(value: 'Teoría (Tecnología)', child: Text('Teoría (Tecnología)')),
                  DropdownMenuItem(value: 'Taller (Práctica)', child: Text('Taller (Práctica)')),
                  DropdownMenuItem(value: 'Laboratorio Informático', child: Text('Laboratorio Informático')),
                  DropdownMenuItem(value: 'Evaluación', child: Text('Evaluación')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setModalState(() => tipoSeleccionado = val);
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: durCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Duración (Horas, ej. 4)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: obsCtrl,
                decoration: const InputDecoration(labelText: 'Observaciones (Opcional)'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (temaCtrl.text.trim().isEmpty) return;
                  final nueva = Sesion(
                    sesionId: 'ses_${DateTime.now().millisecondsSinceEpoch}',
                    grupoId: state.selectedGrupoId ?? '',
                    numero: int.tryParse(numCtrl.text) ?? 1,
                    tema: temaCtrl.text.trim(),
                    tipo: tipoSeleccionado,
                    fecha: '2026-11-13',
                    duracionHoras: int.tryParse(durCtrl.text) ?? 4,
                    observaciones: obsCtrl.text.trim(),
                  );
                  state.addSesion(nueva);
                  Navigator.pop(ctx);
                },
                child: const Text('Guardar y Crear Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
