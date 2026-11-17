# Métodos de Instalación de ZenithOS en Disco Físico

Una vez que inicias el pendrive booteable de **ZenithOS**, tienes dos vías principales para instalar el sistema en el disco duro o SSD de tu ordenador:

---

## Opción 1: Instalación Rápida con Archinstall (Recomendada)

La ISO incluye el instalador guiado en texto `archinstall`, adaptado para mantener todas las optimizaciones:

1. Inicia sesión en la consola en vivo con el usuario `root`.
2. Ejecuta el comando:
   ```bash
   archinstall
   ```
3. Selecciona:
   * **Disco y Particionado:** Se recomienda **Btrfs** con compresión `zstd:1` para tiempos de carga de juegos ultrarrápidos y menor desgaste del SSD.
   * **Perfil:** Minimal / Desktop (Wayland / Hyprland).
   * **Kernel:** `linux-zen`.
   * **Audio:** `pipewire`.
   * **Network configuration:** `NetworkManager`.
4. Una vez terminada la instalación base, copia las configuraciones de `/etc/sysctl.d/99-gaming.conf` y `/etc/security/limits.d/99-gaming.conf` a la nueva partición.

---

## Opción 2: Integración con Instalador Gráfico (Calamares)

Si deseas que la ISO arranque directamente con un asistente visual de bienvenida (tipo Ubuntu, Fedora o Manjaro):

### 1. Añadir paquetes de Calamares a `packages.x86_64`:
```
calamares
kconfig
kcoreaddons
kiconthemes
ki18n
kio
solid
yaml-cpp
parted
boost-libs
```

### 2. Flujo de Calamares:
Crea el archivo `/etc/calamares/settings.conf` dentro de `airootfs/` definiendo la secuencia de módulos:
* `partition` (creación y redimensionado de particiones EFI y raíz)
* `users` (creación de usuario gaming y contraseña)
* `locale` / `keyboard` (idioma y distribución de teclado)
* `unpackfs` (copia la imagen squashfs de la ISO al disco)
* `machineid`, `fstab`, `networkmanager`
* `bootloader` (instalación de `systemd-boot` o `GRUB` en modo UEFI)

---

## 💡 Recomendaciones de Almacenamiento para Juegos
* **Formato Btrfs con Compresión zstd:**
  * Al formatear la partición de juegos con `mkfs.btrfs -L "Games" /dev/nvme0n1pX` y montarla con opciones:
    ```
    compress=zstd:1,noatime,space_cache=v2,discard=async
    ```
  * Los juegos ocupan entre un 15% y 25% menos de espacio y las texturas no comprimidas se cargan más rápido desde el disco gracias a la descompresión ultrarrápida en CPU.
