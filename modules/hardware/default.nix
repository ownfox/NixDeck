# ╔══════════════════════════════════════════════════════════════════╗
# ║  Модуль: Hardware — Steam Deck OLED специфика                   ║
# ║  GPU, firmware, OpenGL, Vulkan                                  ║
# ╚══════════════════════════════════════════════════════════════════╝
{ config, pkgs, ... }:

{
  # ── GPU / Mesa / Vulkan (AMD APU — Van Gogh) ───────────────────
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      vulkan-loader
      vulkan-tools
      vulkan-validation-layers
    ];
  };

  # ── Firmware ───────────────────────────────────────────────────
  hardware.enableRedistributableFirmware = true;

  # ── Bluetooth ──────────────────────────────────────────────────
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true; # для Battery Level индикации контроллеров
      };
    };
  };

  # ── Сенсоры (акселерометр, гироскоп) ───────────────────────────
  hardware.sensor.iio.enable = true;
}
