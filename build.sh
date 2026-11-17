#!/usr/bin/env bash
# ==============================================================================
# ZenithOS - Script de Compilación Automatizado de la ISO
# ==============================================================================

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${DIR}/work"
OUT_DIR="${DIR}/out"
BUILD_PROFILE="${DIR}/.build_profile"

echo "=========================================================="
echo "          COMPILADOR DE ISO - ZenithOS GAMING             "
echo "=========================================================="

# 1. Comprobar permisos de superusuario
if [ "$EUID" -ne 0 ]; then
    echo "[-] Error: Este script debe ejecutarse como root."
    exit 1
fi

# 2. Comprobar dependencias requeridas
if ! command -v mkarchiso &> /dev/null; then
    echo "[*] Instalando dependencias de archiso..."
    pacman -Sy --noconfirm archiso git
fi

# 3. Limpiar compilaciones anteriores si existen
rm -rf "$WORK_DIR" "$BUILD_PROFILE"
mkdir -p "$OUT_DIR" "$BUILD_PROFILE"

# 4. Preparar perfil combinando el estándar releng con nuestras optimizaciones
echo "[*] Preparando estructura de booteo (UEFI / BIOS / GRUB / Syslinux)..."
if [ -d "/usr/share/archiso/configs/releng" ]; then
    cp -r /usr/share/archiso/configs/releng/* "$BUILD_PROFILE"/
fi

# 5. Sobrescribir con nuestros paquetes, configuraciones y ajustes de gaming
echo "[*] Aplicando configuraciones de ZenithOS..."
cp "$DIR/profiledef.sh" "$BUILD_PROFILE"/
cp "$DIR/pacman.conf" "$BUILD_PROFILE"/

# Combinar lista de paquetes (evitando duplicados)
cat "$DIR/packages.x86_64" >> "$BUILD_PROFILE/packages.x86_64"
sort -u "$BUILD_PROFILE/packages.x86_64" -o "$BUILD_PROFILE/packages.x86_64"

# Copiar el árbol airootfs con todas las optimizaciones del kernel y scripts
mkdir -p "$BUILD_PROFILE/airootfs"
cp -r "$DIR/airootfs/"* "$BUILD_PROFILE/airootfs/"

# Asegurar permisos de ejecución en scripts
chmod +x "$BUILD_PROFILE/airootfs/usr/local/bin/"* 2>/dev/null || true

# 6. Ejecutar la compilación
echo "[*] Iniciando creación de la imagen ISO con mkarchiso..."
mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$BUILD_PROFILE"

echo "=========================================================="
echo "          ¡COMPILACIÓN DE ZenithOS COMPLETADA!            "
echo "=========================================================="
ls -lh "$OUT_DIR"/*.iso
echo "=========================================================="
