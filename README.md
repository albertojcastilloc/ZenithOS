# ZenithOS - Linux Gaming Distribution Blueprint

**ZenithOS** es una distribución GNU/Linux basada en Arch Linux, diseñada bajo una filosofía **ultraminimalista, libre y de máximo rendimiento** enfocada en videojuegos modernos, emulación y baja latencia.

---

## ⚡ Principios de Diseño

1. **Kernel Optimizado para Latencia (`linux-zen` / `linux-cachyos`):**
   * Preempción completa del kernel (`PREEMPT_DYNAMIC`).
   * Tasa de interrupción a 1000 Hz (`CONFIG_HZ=1000`) para una latencia de respuesta mínima en ratón, teclado y mandos.
   * `futex_waitv` (FUTEX2) nativo para acelerar el multithreading en Wine/Proton.
2. **Cero Bloatware:**
   * Sin indexadores pesados en segundo plano (sin Baloo, sin Tracker).
   * Servicios en segundo plano reducidos a lo esencial: Red, Bluetooth, Audio y GPU.
3. **Pila Gráfica Wayland + Gamescope:**
   * Wayland elimina el *screen tearing* sin añadir el input lag del VSync de X11.
   * Gamescope permite reescalado por hardware vía **AMD FSR**, limitación de FPS con frametimes constantes y soporte HDR/VRR (FreeSync / G-Sync).
4. **Audio de Baja Latencia con PipeWire:**
   * Sustituto nativo de PulseAudio y JACK configurado a buffers de 128 muestras para latencias < 5ms.
5. **Multi-arquitectura Completa (64-bit y 32-bit):**
   * Controladores Mesa, RADV, Intel ANV y bibliotecas Vulkan de 32 bits activadas en `[multilib]` para compatibilidad total con juegos de Windows heredados y Steam.

---

## 📂 Estructura del Proyecto

```
ZenithOS/
├── build.sh                         # Script de compilación automatizado (mkarchiso)
├── packages.x86_64                   # Lista curada de paquetes y dependencias
├── pacman.conf                       # Configuración de repositorios con [multilib] activo
├── README.md                         # Documentación técnica del sistema
├── INSTALLER.md                      # Guía de instalación en disco duro (Calamares / CLI)
└── airootfs/                         # Árbol raíz que se integrará en la ISO viva
    ├── etc/
    │   ├── sysctl.d/
    │   │   └── 99-gaming.conf        # vm.max_map_count, swappiness y parámetros del kernel
    │   ├── security/
    │   │   └── limits.d/
    │   │       └── 99-gaming.conf    # Límites de archivos abiertos para Esync y Fsync
    │   ├── udev/
    │   │   └── rules.d/
    │   │       └── 99-game-controllers.rules # Reglas para PS5 DualSense, Xbox, Switch, etc.
    │   ├── gamemode.ini              # Perfil de Feral GameMode (CPU performance + GPU clocks)
    │   ├── mangohud/
    │   │   └── MangoHud.conf         # Overlay minimalista con métricas clave de frametime
    │   ├── systemd/
    │   │   ├── zram-generator.conf   # Memoria zRAM comprimida con zstd
    │   │   └── system/
    │   │       └── zenith-setup.service # Optimización I/O SSD y mitigación de split lock
    │   └── profile.d/
    │       └── gaming-env.sh         # Variables de entorno globales (RADV GPL, Wayland SDL)
    └── usr/
        └── local/
            └── bin/
                ├── zenith-game-session # Lanzador de sesión dedicada Gamescope + Steam
                └── zenith-gpu-detect   # Detección automática de GPU (AMD/Intel/Nvidia Prime)
```

---

## 🛠️ Cómo Compilar la ISO

Para generar la imagen `.iso` booteable necesitas una máquina o máquina virtual corriendo Arch Linux:

### 1. Clonar y dar permisos de ejecución
```bash
cd ZenithOS
chmod +x build.sh
chmod +x airootfs/usr/local/bin/*
```

### 2. Ejecutar el compilador
```bash
sudo ./build.sh
```
El script descargará los paquetes oficiales, configurará la compresión `zstd` y generará la imagen final en el directorio `out/zenithos-*.iso`.

---

## 🎮 Cómo Probar la ISO en QEMU

Puedes probar la imagen generada directamente antes de grabarla a un pendrive:

```bash
qemu-system-x86_64 \
    -enable-kvm \
    -m 4G \
    -smp 4 \
    -vga virtio \
    -display gtk,gl=on \
    -audiodev pa,id=snd0 \
    -device intel-hda -device hda-output,audiodev=snd0 \
    -cdrom out/zenithos-*.iso \
    -boot d
```

---

## 🚀 Modos de Uso de ZenithOS

1. **Modo Escritorio (Hyprland):**
   * Un entorno de ventanas dinámico en mosaico (*tiling*) ultra rápido sobre Wayland, con consumo de RAM inferior a 400 MB en reposo.
2. **Modo Consola Dedicado (Gamescope Session):**
   * Ejecutando `zenith-game-session`, la interfaz de escritorio se aparta y Steam arranca en modo **Big Picture / Gamepad UI** aislado dentro de Gamescope, simulando la experiencia de una consola Steam Deck o consola de salón para jugar con mando a distancia.
