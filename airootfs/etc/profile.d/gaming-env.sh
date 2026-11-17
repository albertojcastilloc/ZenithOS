#!/bin/sh
# ==============================================================================
# ZenithOS - Variables de Entorno Globales para Optimización de Juegos
# /etc/profile.d/gaming-env.sh
# ==============================================================================

# [1. AMD Radeon Mesa / RADV Optimizations]
# Habilitar Graphics Pipeline Library (GPL) para eliminar el tartamudeo (stutter) por compilación de shaders
export RADV_PERFTEST=gpl

# [2. Configuración de Shaders en Caché]
# Aumentar el tamaño de la caché de shaders en disco a 10GB
export MESA_SHADER_CACHE_MAX_SIZE=10G

# [3. SDL y Entrada de Video]
# Priorizar Wayland nativo para aplicaciones SDL2/SDL3 con fallback a X11
export SDL_VIDEODRIVER="wayland,x11"
export _JAVA_AWT_WM_NONREPARENTING=1

# [4. Qt / GTK sobre Wayland]
export QT_QPA_PLATFORM="wayland;xcb"
export GDK_BACKEND="wayland,x11"
export MOZ_ENABLE_WAYLAND=1

# [5. PipeWire Low-Latency Default]
export PIPEWIRE_LATENCY="128/48000"
