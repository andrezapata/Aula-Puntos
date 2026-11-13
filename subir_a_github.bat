@echo off
chcp 65001 >nul
title Subiendo Aula Puntos a GitHub...
cd /d "C:\Aula-Puntos"

echo ========================================================
echo        SUBIENDO PROYECTO AULA PUNTOS A GITHUB
echo ========================================================
echo.

if not exist .git (
    echo [1/5] Inicializando repositorio Git...
    git init
) else (
    echo [1/5] Repositorio Git ya existente.
)

echo [2/5] Preparando archivos para commit...
git add .

echo [3/5] Registrando commit oficial...
git commit -m "feat: implementacion completa Aula Puntos SENATI (Flutter, APK, CodeSnap)"

echo [4/5] Estableciendo rama principal main...
git branch -M main

echo [5/5] Vinculando repositorio remoto...
git remote remove origin 2>nul
git remote add origin https://github.com/andrezapata/Aula-Puntos.git

echo.
echo ========================================================
echo  Enviando datos a: https://github.com/andrezapata/Aula-Puntos.git
echo  (Si aparece la ventana de GitHub, haz clic en Autorizar)
echo ========================================================
echo.
git push -u origin main

echo.
if %ERRORLEVEL% equ 0 (
    echo ========================================================
    echo   ✓ PROYECTO SUBIDO CON EXITO A GITHUB!
    echo ========================================================
) else (
    echo ========================================================
    echo   Se requiere confirmacion de inicio de sesion en GitHub.
    echo ========================================================
)

echo.
echo Presiona cualquier tecla para cerrar esta ventana...
pause >nul

