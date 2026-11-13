import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class GruposScreen extends StatelessWidget {
  final AppStateNotifier state;
  final Function(String) onSelectGroup;

  const GruposScreen({
    super.key,
    required this.state,
    required this.onSelectGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grupos SENATI - AULA PUNTOS'),
      ),
      body: state.grupos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 54, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  const Text(
                    'No hay grupos registrados.\nCrea un grupo para comenzar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.grupos.length,
              itemBuilder: (context, index) {
                final grp = state.grupos[index];
                return InkWell(
                  onTap: () => onSelectGroup(grp.grupoId),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
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
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 4,
                            decoration: const BoxDecoration(
                              color: AppTheme.senatiBlue,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    grp.nombre,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.senatiBlue,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: AppTheme.borderInteractive),
                                    ),
                                    child: const Text(
                                      'SENATI',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Programa: ${grp.programa} | Asignatura: ${grp.asignatura}',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Periodo: ${grp.periodo} | Sección: ${grp.seccion}',
                                style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogNuevoGrupo(context),
        backgroundColor: AppTheme.senatiNavy,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  void _mostrarDialogNuevoGrupo(BuildContext context) {
    final nombreCtrl = TextEditingController(text: '202601');
    final progCtrl = TextEditingController(text: '2026-20');
    final asigCtrl = TextEditingController(text: 'FORMACION MONITORES EMPRESA');
    final perCtrl = TextEditingController(text: '2026-20');
    final secCtrl = TextEditingController(text: '2026-20-202601');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Nuevo Grupo SENATI',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.senatiNavy),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre del Grupo (ej. NRC_2044)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: progCtrl,
                decoration: const InputDecoration(labelText: 'Programa Académico'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: asigCtrl,
                decoration: const InputDecoration(labelText: 'Asignatura / Curso'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: perCtrl,
                decoration: const InputDecoration(labelText: 'Periodo (ej. 2026-II)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: secCtrl,
                decoration: const InputDecoration(labelText: 'Código de Sección'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nombreCtrl.text.trim().isEmpty) return;
              final nuevo = Grupo(
                grupoId: 'grp_${DateTime.now().millisecondsSinceEpoch}',
                codigo: nombreCtrl.text.trim(),
                nombre: nombreCtrl.text.trim(),
                programa: progCtrl.text.trim(),
                asignatura: asigCtrl.text.trim(),
                periodo: perCtrl.text.trim(),
                seccion: secCtrl.text.trim(),
                instructorId: 'inst_luque',
              );
              state.addGrupo(nuevo);
              Navigator.pop(ctx);
              onSelectGroup(nuevo.grupoId);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
