# ╔══════════════════════════════════════════════════════════════════╗
# ║  Модуль: Audio — PipeWire (звук, микрофон, Bluetooth Audio)     ║
# ╚══════════════════════════════════════════════════════════════════╝
{ config, pkgs, ... }:

{
  # ── Отключение PulseAudio (заменяем PipeWire) ──────────────────
  hardware.pulseaudio.enable = false;

  # ── RealtimeKit (приоритет звуковых потоков) ────────────────────
  security.rtkit.enable = true;

  # ── PipeWire ───────────────────────────────────────────────────
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;   # для 32-битных игр через Proton
    pulse.enable = true;        # совместимость с PulseAudio-приложениями
    jack.enable = false;        # JACK не нужен на портативной консоли

    # ── Настройки для Steam Deck (низкая задержка) ───────────────
    extraConfig.pipewire = {
      "99-steamdeck" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 512;
        };
      };
    };
  };
}
