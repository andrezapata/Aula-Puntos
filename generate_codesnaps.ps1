Add-Type -AssemblyName System.Drawing

function Get-RoundRect($x, $y, $w, $h, $r) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = $r * 2
    $path.AddArc($x, $y, $d, $d, 180, 90)
    $path.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
    $path.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90)
    $path.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
    $path.CloseFigure()
    return $path
}

function New-CodeSnapImage {
    param(
        [string]$OutputPath,
        [string]$WindowTitle,
        [array]$Lines
    )

    $scale = 2
    $width = 960 * $scale
    $lineHeight = 25 * $scale
    $codeTopPadding = 22 * $scale
    $codeBottomPadding = 26 * $scale
    $titleBarHeight = 46 * $scale
    $outerMargin = 46 * $scale

    $winHeight = $titleBarHeight + $codeTopPadding + ($Lines.Count * $lineHeight) + $codeBottomPadding
    $height = $winHeight + ($outerMargin * 2)

    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    # Fondo degradado institucional estilo CodeSnap (Azul SENATI #002B49 a #003876)
    $rectBg = New-Object System.Drawing.Rectangle(0, 0, $width, $height)
    $c1 = [System.Drawing.Color]::FromArgb(255, 0, 43, 73)
    $c2 = [System.Drawing.Color]::FromArgb(255, 0, 75, 145)
    $gradBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rectBg, $c1, $c2, 135.0)
    $g.FillRectangle($gradBrush, $rectBg)

    $winX = $outerMargin
    $winY = $outerMargin
    $winW = $width - ($outerMargin * 2)
    $radius = 12 * $scale

    # Sombra multicapa suave
    for ($s = 14; $s -ge 1; $s--) {
        $alpha = [int](95 / ($s * 0.75))
        if ($alpha -gt 75) { $alpha = 75 }
        $sBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($alpha, 0, 0, 0))
        $sPath = Get-RoundRect ($winX - $s*$scale) ($winY + ($s*1.4*$scale)) ($winW + ($s*2*$scale)) ($winHeight + ($s*2*$scale)) ($radius + $s*$scale)
        $g.FillPath($sBrush, $sPath)
        $sBrush.Dispose()
        $sPath.Dispose()
    }

    # Ventana principal (#1E1E1E / Atom Dark)
    $winPath = Get-RoundRect $winX $winY $winW $winHeight $radius
    $winBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 30, 30, 30))
    $g.FillPath($winBrush, $winPath)

    # Borde sutil
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(55, 255, 255, 255), (1.5 * $scale))
    $g.DrawPath($borderPen, $winPath)

    # Controles de ventana macOS (Rojo, Amarillo, Verde)
    $dotY = $winY + (17 * $scale)
    $dotSize = 12 * $scale
    $redBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 95, 86))
    $yelBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 189, 46))
    $grnBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 39, 201, 63))
    $g.FillEllipse($redBrush, $winX + (20 * $scale), $dotY, $dotSize, $dotSize)
    $g.FillEllipse($yelBrush, $winX + (40 * $scale), $dotY, $dotSize, $dotSize)
    $g.FillEllipse($grnBrush, $winX + (60 * $scale), $dotY, $dotSize, $dotSize)

    # Título de la ventana
    $titleFont = New-Object System.Drawing.Font("Segoe UI", (13 * $scale), [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
    $titleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 156, 220, 254))
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $g.DrawString($WindowTitle, $titleFont, $titleBrush, ($winX + ($winW / 2)), ($winY + (14 * $scale)), $sf)

    # Línea separadora
    $sepPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 45, 45, 48), (1 * $scale))
    $g.DrawLine($sepPen, $winX, ($winY + $titleBarHeight), ($winX + $winW), ($winY + $titleBarHeight))

    # Fuente y colores (VS Code Dark+)
    $codeFont = New-Object System.Drawing.Font("Consolas", (14 * $scale), [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
    $colors = @{
        "ln"   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 110, 118, 129))
        "kw"   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 86, 156, 214))
        "ctrl" = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 197, 134, 192))
        "cls"  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 78, 201, 176))
        "fn"   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 220, 220, 170))
        "str"  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 206, 145, 120))
        "cmt"  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 106, 153, 85))
        "prop" = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 156, 220, 254))
        "txt"  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 212, 212, 212))
    }

    $w10 = $g.MeasureString("MMMMMMMMMM", $codeFont, 10000, [System.Drawing.StringFormat]::GenericTypographic).Width
    $w1 = $g.MeasureString("M", $codeFont, 10000, [System.Drawing.StringFormat]::GenericTypographic).Width
    $charAdvance = ($w10 - $w1) / 9.0

    $currY = $winY + $titleBarHeight + $codeTopPadding

    for ($i = 0; $i -lt $Lines.Count; $i++) {
        $lineNumStr = "{0,2}" -f ($i + 1)
        $g.DrawString($lineNumStr, $codeFont, $colors["ln"], ($winX + (22 * $scale)), $currY, [System.Drawing.StringFormat]::GenericTypographic)

        $colIndex = 0
        $baseX = $winX + (60 * $scale)
        $tokens = $Lines[$i]
        foreach ($tok in $tokens) {
            $type = [string]$tok.t
            $text = [string]$tok.v
            if ($text.Length -gt 0) {
                $brush = $colors[$type]
                if ($null -eq $brush) { $brush = $colors["txt"] }
                $drawX = $baseX + ($colIndex * $charAdvance)
                $g.DrawString($text, $codeFont, $brush, $drawX, $currY, [System.Drawing.StringFormat]::GenericTypographic)
                $colIndex += $text.Length
            }
        }
        $currY += $lineHeight
    }

    $bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
}

function T($t, $v) { return @{ t = $t; v = $v } }

$outDir = "C:\Aula-Puntos\codigo"
$artDir = "C:\Users\Alumno-ETI\.gemini\antigravity\brain\f9292ffa-bc32-4178-9fe4-32a3091b4a60"
$webDir = "C:\Aula-Puntos\build\web\codigo"

New-Item -ItemType Directory -Force -Path $outDir | Out-Null
New-Item -ItemType Directory -Force -Path $webDir | Out-Null

# -------------------------------------------------------------
# MÓDULO 1: INICIO (lib/screens/home_screen.dart)
# -------------------------------------------------------------
$linesModulo1 = @(
    ,@((T "cmt" "// Módulo 1: Panel del Instructor SENATI (Inicio)"))
    ,@((T "kw" "class "), (T "cls" "HomeScreen "), (T "kw" "extends "), (T "cls" "StatelessWidget "), (T "txt" "{"))
    ,@((T "txt" "  "), (T "kw" "final "), (T "cls" "AppStateNotifier "), (T "prop" "state"), (T "txt" ";"))
    ,@((T "txt" "  "), (T "kw" "final "), (T "cls" "Function"), (T "txt" "("), (T "kw" "int"), (T "txt" ") "), (T "prop" "onNavigateTab"), (T "txt" ";"))
    ,@((T "txt" ""))
    ,@((T "txt" "  "), (T "prop" "@override"))
    ,@((T "txt" "  "), (T "cls" "Widget "), (T "fn" "build"), (T "txt" "("), (T "cls" "BuildContext "), (T "prop" "context"), (T "txt" ") {"))
    ,@((T "txt" "    "), (T "ctrl" "return "), (T "cls" "Scaffold"), (T "txt" "("))
    ,@((T "txt" "      "), (T "prop" "appBar"), (T "txt" ": "), (T "cls" "AppBar"), (T "txt" "("), (T "prop" "title"), (T "txt" ": "), (T "kw" "const "), (T "cls" "Text"), (T "txt" "("), (T "str" "'AULA PUNTOS - SENATI'"), (T "txt" ")),"))
    ,@((T "txt" "      "), (T "prop" "body"), (T "txt" ": "), (T "cls" "SingleChildScrollView"), (T "txt" "("))
    ,@((T "txt" "        "), (T "prop" "padding"), (T "txt" ": "), (T "kw" "const "), (T "cls" "EdgeInsets"), (T "txt" "."), (T "fn" "all"), (T "txt" "(16),"))
    ,@((T "txt" "        "), (T "prop" "child"), (T "txt" ": "), (T "cls" "Column"), (T "txt" "("))
    ,@((T "txt" "          "), (T "prop" "children"), (T "txt" ": ["))
    ,@((T "txt" "            "), (T "cmt" "// Banner Hero: Panel del Instructor"))
    ,@((T "txt" "            "), (T "fn" "_buildInstructorBanner"), (T "txt" "(),"))
    ,@((T "txt" "            "), (T "kw" "const "), (T "cls" "SizedBox"), (T "txt" "("), (T "prop" "height"), (T "txt" ": 14),"))
    ,@((T "txt" "            "), (T "cmt" "// Métricas: Mis Grupos y Estado Offline/Online"))
    ,@((T "txt" "            "), (T "fn" "_buildMetricCardsRow"), (T "txt" "("), (T "prop" "state"), (T "txt" "),"))
    ,@((T "txt" "            "), (T "kw" "const "), (T "cls" "SizedBox"), (T "txt" "("), (T "prop" "height"), (T "txt" ": 18),"))
    ,@((T "txt" "            "), (T "cmt" "// Accesos Rápidos: Grupos, Asistencia, Puntos, Reportes"))
    ,@((T "txt" "            "), (T "fn" "_buildQuickAccessGrid"), (T "txt" "("), (T "prop" "onNavigateTab"), (T "txt" "),"))
    ,@((T "txt" "          ],"))
    ,@((T "txt" "        ),"))
    ,@((T "txt" "      ),"))
    ,@((T "txt" "    );"))
    ,@((T "txt" "  }"))
    ,@((T "txt" "}"))
)

# -------------------------------------------------------------
# MÓDULO 2: MIS GRUPOS (lib/screens/grupos_screen.dart)
# -------------------------------------------------------------
$linesModulo2 = @(
    ,@((T "cmt" "// Módulo 2: Gestión de Grupos SENATI y Formulario Modal"))
    ,@((T "kw" "class "), (T "cls" "GruposScreen "), (T "kw" "extends "), (T "cls" "StatelessWidget "), (T "txt" "{"))
    ,@((T "txt" "  "), (T "kw" "final "), (T "cls" "AppStateNotifier "), (T "prop" "state"), (T "txt" ";"))
    ,@((T "txt" "  "), (T "kw" "final "), (T "cls" "Function"), (T "txt" "("), (T "cls" "String"), (T "txt" ") "), (T "prop" "onSelectGroup"), (T "txt" ";"))
    ,@((T "txt" ""))
    ,@((T "txt" "  "), (T "kw" "void "), (T "fn" "_mostrarDialogNuevoGrupo"), (T "txt" "("), (T "cls" "BuildContext "), (T "prop" "context"), (T "txt" ") {"))
    ,@((T "txt" "    "), (T "fn" "showDialog"), (T "txt" "("))
    ,@((T "txt" "      "), (T "prop" "context"), (T "txt" ": "), (T "prop" "context"), (T "txt" ","))
    ,@((T "txt" "      "), (T "prop" "builder"), (T "txt" ": ("), (T "prop" "ctx"), (T "txt" ") => "), (T "cls" "AlertDialog"), (T "txt" "("))
    ,@((T "txt" "        "), (T "prop" "title"), (T "txt" ": "), (T "kw" "const "), (T "cls" "Text"), (T "txt" "("), (T "str" "'Nuevo Grupo SENATI'"), (T "txt" "),"))
    ,@((T "txt" "        "), (T "prop" "content"), (T "txt" ": "), (T "cls" "Column"), (T "txt" "("))
    ,@((T "txt" "          "), (T "prop" "children"), (T "txt" ": ["))
    ,@((T "txt" "            "), (T "cls" "TextField"), (T "txt" "("), (T "prop" "decoration"), (T "txt" ": "), (T "cls" "InputDecoration"), (T "txt" "("), (T "prop" "labelText"), (T "txt" ": "), (T "str" "'Nombre del Grupo (ej. 202601)'"), (T "txt" ")),"))
    ,@((T "txt" "            "), (T "cls" "TextField"), (T "txt" "("), (T "prop" "decoration"), (T "txt" ": "), (T "cls" "InputDecoration"), (T "txt" "("), (T "prop" "labelText"), (T "txt" ": "), (T "str" "'Programa Académico (ej. 2026-20)'"), (T "txt" ")),"))
    ,@((T "txt" "            "), (T "cls" "TextField"), (T "txt" "("), (T "prop" "decoration"), (T "txt" ": "), (T "cls" "InputDecoration"), (T "txt" "("), (T "prop" "labelText"), (T "txt" ": "), (T "str" "'Asignatura / Curso'"), (T "txt" ")),"))
    ,@((T "txt" "          ],"))
    ,@((T "txt" "        ),"))
    ,@((T "txt" "        "), (T "prop" "actions"), (T "txt" ": ["))
    ,@((T "txt" "          "), (T "cls" "TextButton"), (T "txt" "("), (T "prop" "onPressed"), (T "txt" ": () => "), (T "cls" "Navigator"), (T "txt" "."), (T "fn" "pop"), (T "txt" "("), (T "prop" "ctx"), (T "txt" "), "), (T "prop" "child"), (T "txt" ": "), (T "kw" "const "), (T "cls" "Text"), (T "txt" "("), (T "str" "'Cancelar'"), (T "txt" ")),"))
    ,@((T "txt" "          "), (T "cls" "ElevatedButton"), (T "txt" "("), (T "prop" "onPressed"), (T "txt" ": () => "), (T "fn" "_guardarGrupo"), (T "txt" "(), "), (T "prop" "child"), (T "txt" ": "), (T "kw" "const "), (T "cls" "Text"), (T "txt" "("), (T "str" "'Guardar'"), (T "txt" ")),"))
    ,@((T "txt" "        ],"))
    ,@((T "txt" "      ),"))
    ,@((T "txt" "    );"))
    ,@((T "txt" "  }"))
    ,@((T "txt" "}"))
)

# -------------------------------------------------------------
# MÓDULO 3: SESIONES Y ASISTENCIA (lib/screens/sesiones_screen.dart)
# -------------------------------------------------------------
$linesModulo3 = @(
    ,@((T "cmt" "// Módulo 3: Sesiones Académicas, Asistencia P/T/F/J y Puntuación"))
    ,@((T "kw" "class "), (T "cls" "SesionesScreen "), (T "kw" "extends "), (T "cls" "StatelessWidget "), (T "txt" "{"))
    ,@((T "txt" "  "), (T "cmt" "// Renderizado de Tarjeta de Sesión con Acciones Directas"))
    ,@((T "txt" "  "), (T "cls" "Widget "), (T "fn" "_buildSessionCard"), (T "txt" "("), (T "cls" "BuildContext "), (T "prop" "ctx"), (T "txt" ", "), (T "cls" "Sesion "), (T "prop" "ses"), (T "txt" ") {"))
    ,@((T "txt" "    "), (T "ctrl" "return "), (T "cls" "Container"), (T "txt" "("))
    ,@((T "txt" "      "), (T "prop" "decoration"), (T "txt" ": "), (T "cls" "BoxDecoration"), (T "txt" "("), (T "prop" "color"), (T "txt" ": "), (T "cls" "Colors"), (T "txt" "."), (T "prop" "white"), (T "txt" ", "), (T "prop" "borderRadius"), (T "txt" ": "), (T "cls" "BorderRadius"), (T "txt" "."), (T "fn" "circular"), (T "txt" "(14)),"))
    ,@((T "txt" "      "), (T "prop" "child"), (T "txt" ": "), (T "cls" "Column"), (T "txt" "("))
    ,@((T "txt" "        "), (T "prop" "children"), (T "txt" ": ["))
    ,@((T "txt" "          "), (T "cls" "Text"), (T "txt" "("), (T "prop" "ses"), (T "txt" "."), (T "prop" "tipo"), (T "txt" ", "), (T "prop" "style"), (T "txt" ": "), (T "kw" "const "), (T "cls" "TextStyle"), (T "txt" "("), (T "prop" "color"), (T "txt" ": "), (T "cls" "AppTheme"), (T "txt" "."), (T "prop" "senatiNavy"), (T "txt" ")),"))
    ,@((T "txt" "          "), (T "cls" "Text"), (T "txt" "("), (T "prop" "ses"), (T "txt" "."), (T "prop" "tema"), (T "txt" ", "), (T "prop" "style"), (T "txt" ": "), (T "kw" "const "), (T "cls" "TextStyle"), (T "txt" "("), (T "prop" "fontWeight"), (T "txt" ": "), (T "cls" "FontWeight"), (T "txt" "."), (T "prop" "w800"), (T "txt" ")),"))
    ,@((T "txt" "          "), (T "cls" "Row"), (T "txt" "("))
    ,@((T "txt" "            "), (T "prop" "children"), (T "txt" ": ["))
    ,@((T "txt" "              "), (T "cmt" "// Botón Asistencia -> Contadores P, T, F, J"))
    ,@((T "txt" "              "), (T "cls" "OutlinedButton"), (T "txt" "."), (T "fn" "icon"), (T "txt" "("), (T "prop" "icon"), (T "txt" ": "), (T "kw" "const "), (T "cls" "Icon"), (T "txt" "("), (T "cls" "Icons"), (T "txt" "."), (T "prop" "fact_check"), (T "txt" "), "), (T "prop" "label"), (T "txt" ": "), (T "kw" "const "), (T "cls" "Text"), (T "txt" "("), (T "str" "'Asistencia'"), (T "txt" ")),"))
    ,@((T "txt" "              "), (T "cmt" "// Botón Puntuación -> Botones Rápidos +1, +2, +3"))
    ,@((T "txt" "              "), (T "cls" "ElevatedButton"), (T "txt" "."), (T "fn" "icon"), (T "txt" "("), (T "prop" "icon"), (T "txt" ": "), (T "kw" "const "), (T "cls" "Icon"), (T "txt" "("), (T "cls" "Icons"), (T "txt" "."), (T "prop" "star"), (T "txt" "), "), (T "prop" "label"), (T "txt" ": "), (T "kw" "const "), (T "cls" "Text"), (T "txt" "("), (T "str" "'Puntuación'"), (T "txt" ")),"))
    ,@((T "txt" "            ],"))
    ,@((T "txt" "          ),"))
    ,@((T "txt" "        ],"))
    ,@((T "txt" "      ),"))
    ,@((T "txt" "    );"))
    ,@((T "txt" "  }"))
    ,@((T "txt" "}"))
)

# -------------------------------------------------------------
# MÓDULO 4: REPORTES (lib/screens/reportes_screen.dart)
# -------------------------------------------------------------
$linesModulo4 = @(
    ,@((T "cmt" "// Módulo 4: Reportes, Exportación PDF Oficial y Excel/WhatsApp"))
    ,@((T "kw" "class "), (T "cls" "ReportesScreen "), (T "kw" "extends "), (T "cls" "StatelessWidget "), (T "txt" "{"))
    ,@((T "txt" "  "), (T "cmt" "// Generación y descarga directa del documento PDF (Página 7)"))
    ,@((T "txt" "  "), (T "kw" "void "), (T "fn" "_exportarYDescargarPdf"), (T "txt" "("), (T "cls" "BuildContext "), (T "prop" "context"), (T "txt" ") {"))
    ,@((T "txt" "    "), (T "kw" "final "), (T "prop" "pdfBytes "), (T "txt" "= "), (T "cls" "SenatiPdfGenerator"), (T "txt" "."), (T "fn" "generateAcademicReport"), (T "txt" "("))
    ,@((T "txt" "      "), (T "prop" "grupo"), (T "txt" ": "), (T "prop" "currentGroup"), (T "txt" ","))
    ,@((T "txt" "      "), (T "prop" "estudiantes"), (T "txt" ": "), (T "prop" "state"), (T "txt" "."), (T "prop" "estudiantes"), (T "txt" ","))
    ,@((T "txt" "      "), (T "prop" "puntos"), (T "txt" ": "), (T "prop" "puntosMap"), (T "txt" ","))
    ,@((T "txt" "    );"))
    ,@((T "txt" "    "), (T "fn" "downloadFile"), (T "txt" "("), (T "prop" "pdfBytes"), (T "txt" ", "), (T "str" "'Reporte_Aula_Puntos_SENATI.pdf'"), (T "txt" ", "), (T "str" "'application/pdf'"), (T "txt" ");"))
    ,@((T "txt" "  }"))
    ,@((T "txt" ""))
    ,@((T "txt" "  "), (T "cmt" "// Generación de Excel CSV y apertura de WhatsApp"))
    ,@((T "txt" "  "), (T "kw" "void "), (T "fn" "_exportarExcelYWhatsApp"), (T "txt" "("), (T "cls" "BuildContext "), (T "prop" "context"), (T "txt" ") {"))
    ,@((T "txt" "    "), (T "kw" "final "), (T "prop" "csvBytes "), (T "txt" "= "), (T "cls" "SenatiCsvGenerator"), (T "txt" "."), (T "fn" "generateCsv"), (T "txt" "("), (T "prop" "grupo"), (T "txt" ": "), (T "prop" "currentGroup"), (T "txt" ");"))
    ,@((T "txt" "    "), (T "fn" "downloadFile"), (T "txt" "("), (T "prop" "csvBytes"), (T "txt" ", "), (T "str" "'Reporte_Aula_Puntos_SENATI.csv'"), (T "txt" ", "), (T "str" "'text/csv'"), (T "txt" ");"))
    ,@((T "txt" "    "), (T "kw" "final "), (T "prop" "waText "), (T "txt" "= "), (T "cls" "SenatiCsvGenerator"), (T "txt" "."), (T "fn" "generateWhatsAppText"), (T "txt" "("), (T "prop" "grupo"), (T "txt" ": "), (T "prop" "currentGroup"), (T "txt" ");"))
    ,@((T "txt" "    "), (T "fn" "openWhatsAppWeb"), (T "txt" "("), (T "prop" "waText"), (T "txt" ");"))
    ,@((T "txt" "  }"))
    ,@((T "txt" "}"))
)

New-CodeSnapImage -OutputPath "$outDir\codesnap_modulo1_inicio.png" -WindowTitle "lib/screens/home_screen.dart - Módulo 1: Inicio / Panel Instructor" -Lines $linesModulo1
New-CodeSnapImage -OutputPath "$outDir\codesnap_modulo2_grupos.png" -WindowTitle "lib/screens/grupos_screen.dart - Módulo 2: Mis Grupos" -Lines $linesModulo2
New-CodeSnapImage -OutputPath "$outDir\codesnap_modulo3_sesiones.png" -WindowTitle "lib/screens/sesiones_screen.dart - Módulo 3: Sesiones / Asistencia" -Lines $linesModulo3
New-CodeSnapImage -OutputPath "$outDir\codesnap_modulo4_reportes.png" -WindowTitle "lib/screens/reportes_screen.dart - Módulo 4: Reportes y Exportación" -Lines $linesModulo4

# Copiar a artifacts y web distribution
Copy-Item "$outDir\codesnap_*.png" "$artDir\" -Force
Copy-Item "$outDir\codesnap_*.png" "$webDir\" -Force
Write-Output "ALL_CODESNAPS_GENERATED_SUCCESSFULLY"

