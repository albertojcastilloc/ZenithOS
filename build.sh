#!/usr/bin/env bash
# ==============================================================================
# ZenithOS - Script de Compilación Automatizado de la ISO
# ==============================================================================

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${DIR}/work"
OUT_DIR="${DIR}/out"

echo "=========================================================="
echo "          COMPILADOR DE ISO - ZenithOS GAMING             "
echo "=========================================================="

# 1. Comprobar permisos de superusuario
if [ "$EUID" -ne 0 ]; then
    echo "[-] Error: Este script debe ejecutarse como root (usa sudo ./build.sh)."
    exit 1
fi

# 2. Comprobar dependencias requeridas
if ! command -v mkarchiso &> /dev/null; then
    echo "[-] mkarchiso no está instalado. Instalándolo vía pacman..."
    pacman -Sy --noconfirm archiso git
fi

# 3. Limpiar compilaciones anteriores si el usuario lo solicita
if [ -d "$WORK_DIR" ]; then
    echo "[*] Limpiando directorio de trabajo previo ($WORK_DIR)..."
    rm -rf "$WORK_DIR"
fi

mkdir -p "$OUT_DIR"

# 4. Asegurar permisos correctos en airootfs scripts
echo "[*] Ajustando permisos de ejecutables en airootfs..."
chmod +x "$DIR"/airootfs/usr/local/bin/* 2>/dev/null || true

# 5. Ejecutar la compilación
echo "[*] Iniciando creación de la imagen ISO con mkarchiso..."
mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$DIR"

echo "=========================================================="
echo "          ¡COMPILACIÓN DE ZenithOS COMPLETADA!            "
echo "=========================================================="
echo "La imagen ISO ha sido generada en: $OUT_DIR"
ls -lh "$OUT_DIR"/*.iso
echo "=========================================================="
