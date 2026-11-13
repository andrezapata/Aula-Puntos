# 🎓 AULA PUNTOS – SENATI
### Sistema de Apoyo al Instructor para la Gestión de Asistencia y Participación Académica

[![Flutter](https://img.shields.io/badge/Flutter-3.47.9-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.7-0175C2?logo=dart)](https://dart.dev)
[![Android](https://img.shields.io/badge/Android-APK%20Disponible-3DDC84?logo=android)](https://developer.android.com)
[![SENATI](https://img.shields.io/badge/SENATI-Escuela%20de%20TI-003876)](https://www.senati.edu.pe)

---

## 📌 Planteamiento del Caso Práctico
En las sesiones de formación profesional y dual en **SENATI**, el registro manual de asistencia y evaluaciones participativas ocasiona demoras y pérdida de trazabilidad. **Aula Puntos** centraliza en una sola aplicación multiplataforma el control integral del aula, optimizado para sesiones de teoría y taller dual.

---

## 🚀 Características Principales

1. **Panel del Instructor (Inicio):**
   - Banner de rol institucional con diseño corporativo SENATI (`#002B49` y `#003876`).
   - Métricas en tiempo real: *Mis Grupos* y *Estado del Sistema* (Offline / Online).
   - Accesos directos a los 4 módulos operativos.

2. **Gestión de Grupos Académicos:**
   - Registro de NRC, programas (ej. `2026-20`), asignatura (`FORMACION MONITORES EMPRESA`) y código de sección (`2026-20-202601`).
   - Diálogo modal con validación y estados vacíos asistidos.

3. **Gestión de Sesiones Pedagógicas:**
   - Organización secuencial de clases (*Sesión N° 1 - FORMACION DUAL SENATI*).
   - Clasificación por tipo: *Teoría (Tecnología)*, *Taller (Práctica)*, *Laboratorio* y *Evaluación*.
   - Botones de acceso directo a *Asistencia* y *Puntuación*.

4. **Control de Asistencia Matricial:**
   - Barra con 4 contadores en tiempo real: **Presentes**, **Tardanzas**, **Faltas** y **Justificados**.
   - Botón de marcación rápida *"✓ Marcar todos Presente"*.
   - Botones segmentados de estado por estudiante: `P | T | F | J`.

5. **Puntuación de Participación Rápida:**
   - Selector dinámico de actividad evaluativa (*Participación en clase*, *Resolución de ejercicios*, *Exposiciones*).
   - Botones de incremento inmediato: `+1` (Celeste), `+2` (Azul SENATI) y `+3` (Naranja taller).

6. **Reportes y Exportación Oficial:**
   - **Exportar PDF:** Genera y descarga el documento oficial A4 con membrete SENATI, datos del grupo, tabla de calificaciones y firmas de responsabilidad (*Instructor Luque Chambi Jorge*).
   - **Excel / WhatsApp:** Genera el archivo CSV con UTF-8 BOM para Microsoft Excel y estructura el mensaje listo para enviar por WhatsApp a monitores de empresa.

7. **Arquitectura Offline & Sincronización:**
   - Tolerancia a fallos: almacena localmente las operaciones en cola mientras no hay conexión.
   - Sincronización hacia backend REST API (ASP.NET Core & SQL Server).

---

## 📁 Estructura del Proyecto

```text
c:\Aula-Puntos/
├── android/                 # Configuración nativa Android y Gradle
├── codigo/                  # Evidencias en capturas CodeSnap (Resolución 2x Retina)
│   ├── codesnap_modulo1_inicio.png
│   ├── codesnap_modulo2_grupos.png
│   ├── codesnap_modulo3_sesiones.png
│   └── codesnap_modulo4_reportes.png
├── lib/
│   ├── main.dart            # Entrada y navegación Scaffold BottomNavigationBar
│   ├── models/
│   │   └── models.dart      # Entidades (Grupo, Sesion, Estudiante, Asistencia, Puntos)
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── grupos_screen.dart
│   │   ├── sesiones_screen.dart
│   │   ├── asistencia_screen.dart
│   │   ├── puntuacion_screen.dart
│   │   └── reportes_screen.dart
│   ├── services/
│   │   └── app_state.dart   # Gestor de estado ChangeNotifier y persistencia
│   ├── theme/
│   │   └── app_theme.dart   # Sistema de diseño institucional SENATI
│   └── utils/
│       ├── csv_generator.dart
│       ├── downloader.dart
│       └── pdf_generator.dart
└── pubspec.yaml             # Dependencias del proyecto
```

---

## 🛠️ Ejecución Local

### Ejecutar en la Web
```powershell
flutter run -d chrome
```

### Ejecutar en Escritorio Windows
```powershell
flutter run -d windows
```

### Compilar Instalable Android (APK)
```powershell
flutter build apk --debug
```

---

## 👨‍💻 Autoría y Créditos
* **Estudiante:** Andre Bryam Zapata Vega (ID: 001679960)
* **Carrera:** Informática y Desarrollo de Aplicaciones Web • Semestre IV
* **Instructor del Curso:** Luque Chambi Jorge
* **Institución:** SENATI – Dirección Zonal Lima Callao (CFP Independencia)
