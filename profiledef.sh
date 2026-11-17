#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="zenithos"
iso_label="ZENITHOS_$(date +%Y%m)"
iso_publisher="ZenithOS Gaming <https://github.com/albertojcastilloc/ZenithOS>"
iso_application="ZenithOS Linux Gaming Live"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
build_modes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito'
           'uefi-ia32.systemd-boot.esp' 'uefi-x64.systemd-boot.esp'
           'uefi-ia32.systemd-boot.eltorito' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/usr/local/bin/zenith-game-session"]="0:0:755"
  ["/usr/local/bin/zenith-gpu-detect"]="0:0:755"
)
