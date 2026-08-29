{ config, pkgs, ... }:

{
  # ── Настройка AMD GPU (Mesa) ──────────────────────────────────
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  # Загрузка драйвера AMD на раннем этапе (для Wayland)
  boot.initrd.kernelModules = [ "amdgpu" ];

  # ── Настройка Bluetooth ──────────────────────────────────────
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # ── Firmware (микрокод) ──────────────────────────────────────
  hardware.enableRedistributableFirmware = true;
}
