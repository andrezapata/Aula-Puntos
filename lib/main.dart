import 'package:flutter/material.dart';
import 'services/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/grupos_screen.dart';
import 'screens/sesiones_screen.dart';
import 'screens/asistencia_screen.dart';
import 'screens/puntuacion_screen.dart';
import 'screens/reportes_screen.dart';

void main() {
  runApp(const AulaPuntosApp());
}

class AulaPuntosApp extends StatelessWidget {
  const AulaPuntosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AULA PUNTOS – SENATI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final AppStateNotifier _state = AppStateNotifier();
  int _currentTabIndex = 0;
  String _activeSubScreen = ''; // 'asistencia' o 'puntuacion'

  @override
  void initState() {
    super.initState();
    _state.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
      _activeSubScreen = '';
    });
  }

  void _openAsistencia(String sesionId) {
    _state.setSelectedSesion(sesionId);
    setState(() {
      _activeSubScreen = 'asistencia';
    });
  }

  void _openPuntuacion(String sesionId) {
    _state.setSelectedSesion(sesionId);
    setState(() {
      _activeSubScreen = 'puntuacion';
    });
  }

  void _backToSesiones() {
    setState(() {
      _activeSubScreen = '';
      _currentTabIndex = 2; // Pestaña Sesiones
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentBody;

    if (_activeSubScreen == 'asistencia') {
      currentBody = AsistenciaScreen(
        state: _state,
        onBackToSesiones: _backToSesiones,
      );
    } else if (_activeSubScreen == 'puntuacion') {
      currentBody = PuntuacionScreen(
        state: _state,
        onBackToSesiones: _backToSesiones,
      );
    } else {
      switch (_currentTabIndex) {
        case 0:
          currentBody = HomeScreen(
            state: _state,
            onNavigateTab: _onTabTapped,
            onOpenAsistencia: () {
              if (_state.sesiones.isNotEmpty) {
                _openAsistencia(_state.sesiones.first.sesionId);
              } else {
                _onTabTapped(1);
              }
            },
            onOpenPuntos: () {
              if (_state.sesiones.isNotEmpty) {
                _openPuntuacion(_state.sesiones.first.sesionId);
              } else {
                _onTabTapped(1);
              }
            },
          );
          break;
        case 1:
          currentBody = GruposScreen(
            state: _state,
            onSelectGroup: (grpId) {
              _state.setSelectedGrupo(grpId);
              _onTabTapped(2); // Ir a sesiones
            },
          );
          break;
        case 2:
          currentBody = SesionesScreen(
            state: _state,
            onBackToGrupos: () => _onTabTapped(1),
            onOpenAsistencia: _openAsistencia,
            onOpenPuntuacion: _openPuntuacion,
            onOpenReportes: () => _onTabTapped(3),
          );
          break;
        case 3:
          currentBody = ReportesScreen(
            state: _state,
          );
          break;
        default:
          currentBody = HomeScreen(
            state: _state,
            onNavigateTab: _onTabTapped,
            onOpenAsistencia: () {},
            onOpenPuntos: () {},
          );
      }
    }

    final showBottomNav = _activeSubScreen.isEmpty;

    return Scaffold(
      body: currentBody,
      bottomNavigationBar: showBottomNav
          ? BottomNavigationBar(
              currentIndex: _currentTabIndex,
              onTap: _onTabTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_outline),
                  activeIcon: Icon(Icons.people),
                  label: 'Mis grupos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month_outlined),
                  activeIcon: Icon(Icons.calendar_month),
                  label: 'Sesiones',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  activeIcon: Icon(Icons.bar_chart),
                  label: 'Reportes',
                ),
              ],
            )
          : null,
    );
  }
}
